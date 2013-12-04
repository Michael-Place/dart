//
//  DSNewGameViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSNewGameViewController.h"
#import "DSNewGameViewController.h"
#import "DSNewPlayerCollectionViewCell.h"
#import "DSPlayer.h"
#import "DSGame.h"

const int kDefaultNumberOfPlayers = 4;
const int kMaxNumberOfPlayers = 8;
const int kDartGap = 60;

@interface DSNewGameViewController () <NewPlayerCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//Dyanmics
@property (nonatomic, strong) NSMutableArray *darts;
@property (nonatomic, strong) NSMutableArray *droppedDarts;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@property (nonatomic, strong) NSMutableArray *newPlayers;


- (IBAction)addPlayerButtonTapped:(id)sender;
- (IBAction)startGameTapped:(id)sender;
@end

@implementation DSNewGameViewController
static NSString *const NewPlayerCollectionViewCellIdentifier = @"NewPlayerCollectionViewCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSNewPlayerCollectionViewCell"
                                                    bundle:[NSBundle mainBundle]]
                                forCellWithReuseIdentifier:NewPlayerCollectionViewCellIdentifier];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
    
    
    //Reset DSGame
    [[DSGame sharedGame] setPlayers:[NSArray array]];
    
    //UIDynamics
    self.darts = [NSMutableArray array];
    self.droppedDarts = [NSMutableArray array];
    
    [self addCollisionBoundaryForView:self.startGameButton];
    
}

// Allows us to dismiss keyboard by tapping anywhere outside of the text view
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    for (int i = 0; i < self.newPlayers.count; i++) {
        NSIndexPath *indexPathForCell = [NSIndexPath indexPathForItem:i inSection:0];
        DSNewPlayerCollectionViewCell *cell = (DSNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathForCell];
        if ([cell.playerNameTextField isFirstResponder]) {
            [cell.playerNameTextField resignFirstResponder];
            [[self.newPlayers objectAtIndex:indexPathForCell.row] setIsEditMode:NO];
            break;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupDefaultNewGame];
}

- (void)setupDefaultNewGame
{
    
    DSPlayer *playerOne = [[DSPlayer alloc] initWithPlayerName:[self defaultNameForNewPlayer]];
    [self.newPlayers addObject:playerOne];
    DSPlayer *playerTwo = [[DSPlayer alloc] initWithPlayerName:[self defaultNameForNewPlayer]];
    [self.newPlayers addObject:playerTwo];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0]]];
    } completion:^(BOOL finished) {
        [self newPlayerAddedWithName:playerOne.playerName];
        [self newPlayerAddedWithName:playerTwo.playerName];
    }];
}

- (IBAction)addPlayerButtonTapped:(id)sender
{
    DSPlayer *newPlayer = [[DSPlayer alloc] initWithPlayerName:[self defaultNameForNewPlayer]];
    [self.newPlayers addObject:newPlayer];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.newPlayers.count - 1  inSection:0]]];
    
    [self newPlayerAddedWithName:newPlayer.playerName];
    
    // Dont allow more than the max players
    if (self.newPlayers.count == kMaxNumberOfPlayers) {
        [self.addPlayerButton setEnabled:NO];
    }
}

- (IBAction)startGameTapped:(id)sender
{
    if (self.newPlayers.count > 1) {
        [[DSGame sharedGame] setPlayers:[NSArray arrayWithArray:[self.newPlayers copy]]];
        [self.delegate startGame];
    } else {
        UIAlertView *needMorePlayersAlert = [[UIAlertView alloc] initWithTitle:@"Need More Players" message:@"Need minimum of two players to start game." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [needMorePlayersAlert show];
    }
}

#pragma mark - NewPlayer delegates
- (void)throwDart:(UIView *)dartView
{
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[dartView]];
    itemBehaviour.elasticity = 0.3;
    [itemBehaviour addAngularVelocity:20.0 forItem:dartView];
    
    //    itemBehaviour.angularResistance = 10.0;
    
    [self.darts addObject:dartView];
    [self.view addSubview:dartView];
    
    [dartView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    
    
    CGPoint endPoint = [self getDartEndPoint];
    
    [self addGravityForView:dartView];
    [self addSnapForView:dartView toPoint:endPoint];
}

- (void)newPlayerAddedWithName:(NSString *)playerName
{
    NSLog(@"New Player Added!! Throw Dart");
    
    UIImageView *dartView;
    if (self.darts.count + 1 <= kMaxNumberOfPlayers/2) {
        dartView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        [dartView setImage:[UIImage imageNamed:@"dart_right.png"]];
    }
    else {
        dartView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 100, 15)];
        [dartView setImage:[UIImage imageNamed:@"dart_left.png"]];
    }
    
    [self throwDart:dartView];
}

- (CGPoint)getDartEndPoint
{
    int minY = 50;
    int currentDart;
    int yOffset;
    
    CGPoint endPoint;
    if (self.darts.count <= kMaxNumberOfPlayers/2) {
        currentDart = (int)self.darts.count - 1;
        yOffset = minY + (currentDart * kDartGap);
        endPoint = CGPointMake(self.view.bounds.size.width - 55, yOffset);
    }
    else {
        currentDart = abs(kMaxNumberOfPlayers/2 - (int)self.darts.count + 1);
        yOffset = minY + (currentDart * kDartGap);
        endPoint = CGPointMake(self.view.bounds.origin.y + 55, yOffset);
    }

    
    return endPoint;
}

- (void)newPlayerRemoved
{
    NSLog(@"New Player Removed. Drop Dart");
    
    if (self.darts && self.darts.count) {
        UIView *dartView = [self.darts lastObject];
        UIImageView *dropDart = [[UIImageView alloc] initWithFrame:dartView.frame];
        
        if (self.darts.count <= kMaxNumberOfPlayers/2) {
            [dropDart setImage:[UIImage imageNamed:@"dart_right.png"]];
        }
        else {
            [dropDart setImage:[UIImage imageNamed:@"dart_left.png"]];
        }
        
        [self.darts removeLastObject];
        [dartView removeFromSuperview];
        
        [self.droppedDarts addObject:dropDart];
        [self.view addSubview:dropDart];
        
        UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[dropDart]];
        itemBehaviour.elasticity = 1.0;
        //    [itemBehaviour addAngularVelocity:20.0 forItem:dropDart];
        
        
        [self addPushForView:dropDart];
        [self addGravityForView:dropDart];
        [self addCollisionForView:dropDart];
    }
}

#pragma mark - UIDynamic helpers
- (void)addSnapForView:(UIView *)view toPoint:(CGPoint)point
{
    UISnapBehavior *snapDart = [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    snapDart.damping = 0.8;
    [self.animator addBehavior:snapDart];
}

- (void)addGravityForView:(UIView *)view
{
    [self.gravity addItem:view];
    [self.animator addBehavior:self.gravity];
}

- (void)addPushForView:(UIView *)view
{
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
    
    [push setPushDirection:CGVectorMake(0, 1.0)];
    [push setAngle:-0.2];
    [self.animator addBehavior:push];
}

- (void)addCollisionForView:(UIView *)view
{
    [self.collision addItem:view];
    [self.animator addBehavior:self.collision];
    
}

- (void)addCollisionBoundaryForView:(UIView *)view
{
    [self addTopEdgeBarrierForView:view];
    [self addRightEdgeBarrierForView:view];
    [self addLeftEdgeBarrierForView:view];
}

- (void)addTopEdgeBarrierForView:(UIView *)view
{
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_TopEdgeBarrier", (unsigned long)self.newPlayers.count];
    CGPoint topRightEdge = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:view.frame.origin toPoint:topRightEdge];
}

- (void)addRightEdgeBarrierForView:(UIView *)view
{
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_RightEdgeBarrier", (unsigned long)self.newPlayers.count];
    CGPoint topRightEdge = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
    CGPoint bottomRightEdge = CGPointMake(view.frame.size.width + view.frame.origin.x, view.frame.origin.y + view.frame.size.height);
    
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:topRightEdge toPoint:bottomRightEdge];
}

- (void)addLeftEdgeBarrierForView:(UIView *)view
{
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_LeftEdgeBarrier", (unsigned long)self.newPlayers.count];
    CGPoint topLeftEdge = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    CGPoint bottomLeftEdge = CGPointMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height);
    
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:topLeftEdge toPoint:bottomLeftEdge];
}

- (void)resetDartDynamics
{
    self.animator = nil;
    self.gravity = nil;
    self.collision = nil;
    
    for (UIView *dart in self.darts) {
        [dart removeFromSuperview];
    }
    
    for (UIView *droppedDart in self.droppedDarts) {
        [droppedDart removeFromSuperview];
    }
    
    self.darts = [NSMutableArray array];
    self.droppedDarts = [NSMutableArray array];
    
    [self addCollisionBoundaryForView:self.startGameButton];
    [self addCollisionBoundaryForView:self.addPlayerButton];
}

- (void)throwDartsForCurrentPlayers
{
    for (DSPlayer *player in self.newPlayers) {
        [self newPlayerAddedWithName:player.playerName];
    }
}

#pragma mark - UICollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.newPlayers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSNewPlayerCollectionViewCell *newPlayerCell = [collectionView dequeueReusableCellWithReuseIdentifier:NewPlayerCollectionViewCellIdentifier forIndexPath:indexPath];
    [newPlayerCell setCellDelegate:self];
    
    DSPlayer *playerForIndexPath = [self.newPlayers objectAtIndex:indexPath.row];
    
    [newPlayerCell.playerNameTextField setText:playerForIndexPath.playerName];
    [newPlayerCell.playerNameLabel setText:playerForIndexPath.playerName];
    
    // First two players can't be deleted
    [newPlayerCell.deletePlayerButton setHidden:(indexPath.row < 2) ? YES : NO];
    
    // Update the cells edit mode in case we are dequeing
    (playerForIndexPath.isEditMode) ? [self enterEditModeForCell:newPlayerCell atIndexPath:indexPath animated:NO] :
                                    [self exitEditModeForCell:newPlayerCell atIndexPath:indexPath animated:NO];
    
    return newPlayerCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self loadNewPlayerCollectionViewCellFromNib].frame.size;
}

#pragma mark - UICollectionView Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

static float playerNameAnimationDuration = 1.0;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select cell: %i", indexPath.row);
    
    DSNewPlayerCollectionViewCell *cell = (DSNewPlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DSPlayer *playerForCell = (DSPlayer *)[self.newPlayers objectAtIndex:indexPath.row];
    
    [self exitEditModeForAllPlayersAsideFromPlayer:playerForCell];
    
    // Toggle edit mode on tap
    if (playerForCell.isEditMode) {
        [playerForCell setIsEditMode:NO];
        [self exitEditModeForCell:cell atIndexPath:indexPath animated:YES];
    }
    else {
        [playerForCell setIsEditMode:YES];
        [self enterEditModeForCell:cell atIndexPath:indexPath animated:YES];

    }
    
}

#pragma mark - New Player Cell Delegate
- (void)didFinishEditingForCell:(DSNewPlayerCollectionViewCell *)cell
{
    NSIndexPath *indexPathForCell = [self.collectionView indexPathForCell:cell];
    
    if ([self indexPathIsBackedByData:indexPathForCell]) {
        [self exitEditModeForCell:cell atIndexPath:indexPathForCell animated:YES];
    }
}

- (void)deletedPlayerForCell:(DSNewPlayerCollectionViewCell *)cell
{
    NSIndexPath *indexPathForCell = [self.collectionView indexPathForCell:cell];
    
    [cell.playerNameTextField resignFirstResponder];
    [self.newPlayers removeObjectAtIndex:indexPathForCell.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPathForCell]];
    
    [self newPlayerRemoved];
    
    if (self.newPlayers.count < kMaxNumberOfPlayers) {
        [self.addPlayerButton setEnabled:YES];
    }
    
    [self rectifyPlayerNamesIfNecessaryStartingAtIndexPath:indexPathForCell];
}

- (void)rectifyPlayerNamesIfNecessaryStartingAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL needToReloadCollectionView = NO;
    
    for (DSPlayer *player in self.newPlayers) {
        int numberOfPlayer = [self.newPlayers indexOfObject:player] + 1;
        if (!player.playerNameHasBeenEdited) {
            needToReloadCollectionView = YES;
            [[self.newPlayers objectAtIndex:numberOfPlayer -1 ] setPlayerName:[NSString stringWithFormat:@"Player %i", numberOfPlayer]];
        }
    }
    
    if (needToReloadCollectionView) {
        [self.collectionView reloadData];
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    }
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self resetDartDynamics];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self throwDartsForCurrentPlayers];
}

#pragma mark - Helpers
- (DSNewPlayerCollectionViewCell *)loadNewPlayerCollectionViewCellFromNib
{
    NSArray *newPlayerCellNib = [[NSBundle mainBundle] loadNibNamed:@"DSNewPlayerCollectionViewCell" owner:self options:nil];
    DSNewPlayerCollectionViewCell *newPlayerCell = [newPlayerCellNib objectAtIndex:0];
    return newPlayerCell;
}

- (void)enterEditModeForCell:(DSNewPlayerCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [cell.playerNameTextField setText:cell.playerNameLabel.text];

    if (animated) {
        [UIView animateWithDuration:playerNameAnimationDuration animations:^{
            [cell.playerNameLabel setHidden:YES];
            [cell.playerNameTextField setHidden:NO];
        } completion:^(BOOL finished) {
            [cell.playerNameTextField becomeFirstResponder];
        }];
    }
    else {
        [cell.playerNameLabel setHidden:YES];
        [cell.playerNameTextField setHidden:NO];
        [cell.playerNameTextField becomeFirstResponder];
    }
    
}

- (void)exitEditModeForCell:(DSNewPlayerCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    DSPlayer *playerForCell = (DSPlayer *)[self.newPlayers objectAtIndex:indexPath.row];
    
    if ([[cell.playerNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) {
        // Set player name to default
        [cell.playerNameLabel setText:playerForCell.playerName];
    }
    else {
        // Set player name to user entered value
        [cell.playerNameLabel setText:cell.playerNameTextField.text];
        
        // If the players current name does not match what the user entered, update it and note that it has been edited
        if (![playerForCell.playerName isEqualToString:cell.playerNameTextField.text]) {
            [playerForCell setPlayerName:cell.playerNameTextField.text];
            [playerForCell setPlayerNameHasBeenEdited:YES];
        }
    }

    if (animated) {
        [UIView animateWithDuration:playerNameAnimationDuration animations:^{
            [cell.playerNameLabel setHidden:NO];
            [cell.playerNameTextField setHidden:YES];
        } completion:^(BOOL finished) {
            [cell.playerNameTextField resignFirstResponder];
        }];
    }
    else {
        [cell.playerNameLabel setHidden:NO];
        [cell.playerNameTextField setHidden:YES];
        [cell.playerNameTextField resignFirstResponder];
    }
    
}

- (void)exitEditModeForAllPlayersAsideFromPlayer:(DSPlayer *)playerInFocus
{
    for (DSPlayer *player in self.newPlayers) {
        if (player != playerInFocus) {
            [player setIsEditMode:NO];
        }
    }
    
    [self.collectionView reloadData];
}

- (NSString *)defaultNameForNewPlayer
{
    return [NSString stringWithFormat:@"Player %i", (self.newPlayers.count + 1)];
}

- (BOOL)indexPathIsBackedByData:(NSIndexPath *)indexPath
{
    BOOL indexPathIsValid = NO;
    if (self.newPlayers.count >= indexPath.row) {
        indexPathIsValid = YES;
    }
    
    return indexPathIsValid;
}

#pragma mark - UIDynamic properties
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        [_collision setTranslatesReferenceBoundsIntoBoundary:YES];
        _collision.collisionDelegate = (id)self;
    }
    return _collision;
}

- (NSMutableArray *)newPlayers
{
    if (!_newPlayers) {
        _newPlayers = [NSMutableArray array];
    }
    return _newPlayers;
}

@end
