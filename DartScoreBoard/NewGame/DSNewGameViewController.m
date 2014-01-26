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
#import "DSAssetGenerator.h"
#import "DSGame.h"

const int DefaultNumberOfPlayers = 4;
const int MaxNumberOfPlayers = 8;
const int DartGap = 60;

@interface DSNewGameViewController () <NewPlayerCellDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameInstructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

//Dyanmics
@property (nonatomic, strong) NSMutableArray *darts;
@property (nonatomic, strong) NSMutableArray *droppedDarts;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@property (nonatomic, strong) NSMutableArray *newPlayers;
@property (nonatomic, strong) DSAppSkinnerViewController *settingsViewController;

@property int indexOfPlayerInEditMode;


- (IBAction)addPlayerButtonTapped:(id)sender;
- (IBAction)startGameTapped:(id)sender;
- (IBAction)settingsButtonTapped:(id)sender;
@end

@implementation DSNewGameViewController
static NSString *const NewPlayerCollectionViewCellIdentifier = @"NewPlayerCollectionViewCellIdentifier";

- (void)setInitialPlayers:(NSArray *)players
{
    self.newPlayers = nil;
    [self.newPlayers addObjectsFromArray:players];
    [self performSelector:@selector(throwDartsForCurrentPlayers) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSNewPlayerCollectionViewCell"
                                                    bundle:[NSBundle mainBundle]]
                                forCellWithReuseIdentifier:NewPlayerCollectionViewCellIdentifier];
    
    // Add the tap gesture to the view so that we can dismiss the keyboard if applicable
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleSingleTap:)];
    [tapGesture setCancelsTouchesInView:NO];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    //Reset DSGame
    [[DSGame sharedGame] setPlayers:[NSArray array]];
    
    //UIDynamics
    self.darts = [NSMutableArray array];
    self.droppedDarts = [NSMutableArray array];
        
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Set the interface colors
    [self.view setBackgroundColor:[DSAppSkinner globalBackgroundColor]];
    [self.appTitleLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.gameInstructionLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.addPlayerButton setBackgroundColor:[DSAppSkinner globalTextColor]];
    [self.startGameButton setBackgroundColor:[DSAppSkinner globalTextColor]];
    [self.settingsButton setBackgroundColor:[DSAppSkinner globalTextColor]];
    
    [self.addPlayerButton setTitleColor:[DSAppSkinner globalBackgroundColor] forState:UIControlStateNormal];
    [self.startGameButton setTitleColor:[DSAppSkinner globalBackgroundColor] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[DSAppSkinner globalBackgroundColor] forState:UIControlStateNormal];
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    if (![self.newPlayers count]) {
        [self setupDefaultNewGame];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL shouldReceiveTouch = YES;
    if ([touch.view isDescendantOfView:self.collectionView]) {
        shouldReceiveTouch = NO;
    }
        
    return shouldReceiveTouch;
}

// Allows us to dismiss keyboard by tapping anywhere outside of the text view
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self findAndResignFirstResponder];
}

- (void)findAndResignFirstResponder
{
    for (int i = 0; i < self.newPlayers.count; i++) {
        NSIndexPath *indexPathForCell = [NSIndexPath indexPathForItem:i inSection:0];
        DSNewPlayerCollectionViewCell *cell = (DSNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPathForCell];
        DSPlayer *playerForCell = [self.newPlayers objectAtIndex:indexPathForCell.row];
        
        if ([cell.playerNameTextField isFirstResponder]) {
            [cell.playerNameTextField resignFirstResponder];
            [playerForCell setIsEditMode:NO];
            break;
        }
    }
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

- (void)setUpGameWithPlayers:(NSArray *)players
{
    self.newPlayers = nil;
    [self.newPlayers addObjectsFromArray:players];
    
    [self.collectionView performBatchUpdates:^{
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < [self.newPlayers count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        [self.collectionView insertItemsAtIndexPaths:[indexPaths copy]];
    } completion:^(BOOL finished) {
        for (DSPlayer *player in self.newPlayers) {
            [self newPlayerAddedWithName:player.playerName];
        }
    }];
}

- (IBAction)addPlayerButtonTapped:(id)sender
{
    DSPlayer *newPlayer = [[DSPlayer alloc] initWithPlayerName:[self defaultNameForNewPlayer]];
    [self.newPlayers addObject:newPlayer];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.newPlayers.count - 1  inSection:0]]];
    
    [self newPlayerAddedWithName:newPlayer.playerName];
    
    // Dont allow more than the max players
    if (self.newPlayers.count == MaxNumberOfPlayers) {
        [self.addPlayerButton setEnabled:NO];
    }
}

- (IBAction)startGameTapped:(id)sender
{
    if (self.newPlayers.count > 1) {
        [[DSGame sharedGame] setPlayers:[NSArray arrayWithArray:[self.newPlayers copy]]];
        [self.delegate startGame];
    }
}

- (IBAction)settingsButtonTapped:(id)sender
{
    [self presentViewController:self.settingsViewController animated:YES completion:nil];
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
    if (self.darts.count + 1 <= MaxNumberOfPlayers/2) {
        dartView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        [dartView setImage:[DSAssetGenerator imageForDartWithFrame:dartView.frame]];
    }
    else {
        dartView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 150, 50)];
        [dartView setImage:[self rotateImage:[DSAssetGenerator imageForDartWithFrame:dartView.frame]]];
    }
    
    [self throwDart:dartView];
}

- (CGPoint)getDartEndPoint
{
    int minY = 50;
    int currentDart;
    int yOffset;
    
    CGPoint endPoint;
    if (self.darts.count <= MaxNumberOfPlayers/2) {
        currentDart = (int)self.darts.count - 1;
        yOffset = minY + (currentDart * DartGap);
        endPoint = CGPointMake(self.view.bounds.size.width - 55, yOffset);
    }
    else {
        currentDart = abs(MaxNumberOfPlayers/2 - (int)self.darts.count + 1);
        yOffset = minY + (currentDart * DartGap);
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
        
        if (self.darts.count <= MaxNumberOfPlayers/2) {
            [dropDart setImage:[DSAssetGenerator imageForDartWithFrame:dartView.frame]];
        }
        else {
            [dropDart setImage:[self rotateImage:[DSAssetGenerator imageForDartWithFrame:dartView.frame]]];
        }
        
        [self.darts removeLastObject];
        [dartView removeFromSuperview];
        
        [self.droppedDarts addObject:dropDart];
        [self.view addSubview:dropDart];
        
        UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[dropDart]];
        itemBehaviour.elasticity = 1.0;
        
        [self addPushForView:dropDart];
        [self addGravityForView:dropDart];
        [self addCollisionForView:dropDart];
    }
    
    [self.collision removeAllBoundaries];
    [self addCollisionBoundaryForView:self.startGameButton];
    [self addCollisionBoundaryForView:self.addPlayerButton];
    [self addCollisionBoundaryForView:self.settingsButton];
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
    
    // Make the background view circular
    CGPoint saveCenter = newPlayerCell.backgroundColorView.center;
    newPlayerCell.backgroundColorView.layer.cornerRadius = newPlayerCell.backgroundColorView.frame.size.width / 2.0;
    newPlayerCell.backgroundColorView.center = saveCenter;

    DSPlayer *playerForIndexPath = [self.newPlayers objectAtIndex:indexPath.row];
    
    // Set the interface colors
    if (indexPath.row % 2 == 0) {
        if ([DSAppSkinner globalBackgroundColor] != [DSAppSkinner evenPlayerScoreBoardColor]) {
            [newPlayerCell.backgroundColorView setBackgroundColor:[DSAppSkinner evenPlayerScoreBoardColor]];
        }
        else {
            [newPlayerCell.backgroundColorView setBackgroundColor:[DSAppSkinner globalTextColor]];
        }
    }
    else {
        if ([DSAppSkinner globalBackgroundColor] != [DSAppSkinner oddPlayerScoreboardColor]) {
            [newPlayerCell.backgroundColorView setBackgroundColor:[DSAppSkinner oddPlayerScoreboardColor]];
        }
        else {
            [newPlayerCell.backgroundColorView setBackgroundColor:[DSAppSkinner globalTextColor]];
        }
    }
    
    [newPlayerCell.playerNameTextField setText:playerForIndexPath.playerName];
    [newPlayerCell.playerNameLabel setText:playerForIndexPath.playerName];
    [newPlayerCell.playerNameLabel setTextColor:[DSAppSkinner globalBackgroundColor]];
    [newPlayerCell.playerNameTextField setTextColor:[DSAppSkinner globalBackgroundColor]];
    
    // First two players can't be deleted
    [newPlayerCell.deletePlayerButton setHidden:(indexPath.row < 2) ? YES : NO];
    [newPlayerCell.deletePlayerButton setImage:[DSAssetGenerator imageForNewPlayerDeletionButtonForFrame:newPlayerCell.deletePlayerButton.frame] forState:UIControlStateNormal];
    
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
    DSNewPlayerCollectionViewCell *cell = (DSNewPlayerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    DSPlayer *playerForCell = (DSPlayer *)[self.newPlayers objectAtIndex:indexPath.row];
    
    // Toggle edit mode on tap
    if (playerForCell.isEditMode) {
        [playerForCell setIsEditMode:NO];
        [self exitEditModeForCell:cell atIndexPath:indexPath animated:YES];
    }
    else {
        [playerForCell setIsEditMode:YES];
        [self setIndexOfPlayerInEditMode:indexPath.row];
        [self enterEditModeForCell:cell atIndexPath:indexPath animated:YES];

    }
    
}

#pragma mark - New Player Cell Delegate
- (void)didFinishEditingForCell:(DSNewPlayerCollectionViewCell *)cell
{
    NSIndexPath *indexPathForCell = [self.collectionView indexPathForCell:cell];
    DSPlayer *playerForCell = (DSPlayer *)[self.newPlayers objectAtIndex:indexPathForCell.row];

    if ([self indexPathIsBackedByData:indexPathForCell]) {
        [playerForCell setIsEditMode:NO];
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
    
    if (self.newPlayers.count < MaxNumberOfPlayers) {
        [self.addPlayerButton setEnabled:YES];
    }
    
    [self rectifyPlayerNamesIfNecessaryStartingAtIndexPath:indexPathForCell];
}

- (void)rectifyPlayerNamesIfNecessaryStartingAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL needToReloadCollectionView = NO;
    
    for (DSPlayer *player in self.newPlayers) {
        int numberOfPlayer = (int)[self.newPlayers indexOfObject:player] + 1;
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

#pragma mark - Settings Delegate
- (void)didFinishWithSettings
{
    [self resetDartDynamics];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self throwDartsForCurrentPlayers];
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
        if ([self playerNameIsValidForPlayer:playerForCell andPotentialName:cell
            .playerNameTextField.text]) {
            // Set player name to user entered value
            [cell.playerNameLabel setText:cell.playerNameTextField.text];
            
            // If the players current name does not match what the user entered, update it and note that it has been edited
            if (![playerForCell.playerName isEqualToString:cell.playerNameTextField.text]) {
                [playerForCell setPlayerName:cell.playerNameTextField.text];
                [playerForCell setPlayerNameHasBeenEdited:YES];
            }
        }
        else {
            [cell.playerNameTextField setText:playerForCell.playerName];
            [self showInvalidNameAlert];
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

- (BOOL)playerNameIsValidForPlayer:(DSPlayer *)player andPotentialName:(NSString *)potentialName
{
    BOOL nameIsValid = YES;
    for (DSPlayer *otherPlayer in self.newPlayers) {
        if (player != otherPlayer && [potentialName isEqualToString:otherPlayer.playerName]) {
            nameIsValid = NO;
            break;
        }
    }
    
    return nameIsValid;
}

- (void)showInvalidNameAlert
{
    UIAlertView *invalidNameAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!" message:@"Sorry, but no two players can have the same name. Please choose another name for this player." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [invalidNameAlert show];
}

- (NSString *)defaultNameForNewPlayer
{
    return [NSString stringWithFormat:@"Player %lu", (self.newPlayers.count + 1)];
}

- (BOOL)indexPathIsBackedByData:(NSIndexPath *)indexPath
{
    BOOL indexPathIsValid = NO;
    if (self.newPlayers.count >= indexPath.row) {
        indexPathIsValid = YES;
    }
    
    return indexPathIsValid;
}

- (UIImage *)rotateImage:(UIImage *)image
{
    CGFloat rads = M_PI;
    float newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide/2, newSide/2);
    CGContextRotateCTM(ctx, rads);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,size.width, size.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
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

#pragma mark - Keyboard Notifications
- (void)keyboardDidShow
{
    // Only scroll the collection view if we are in landscape
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.bounds);
        CGFloat cellHeight = [self loadNewPlayerCollectionViewCellFromNib].frame.size.height;
        
        [UIView animateWithDuration:.2 animations:^{
            [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, (collectionViewHeight - cellHeight), 0)];
            
        } completion:^(BOOL finished) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.indexOfPlayerInEditMode inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }];
    }
}

- (void)keyboardDidHide
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [UIView animateWithDuration:.2 animations:^{
            [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }];
    }
}


#pragma mark - Getters
- (DSAppSkinnerViewController *)settingsViewController
{
    if (!_settingsViewController) {
        _settingsViewController = [[DSAppSkinnerViewController alloc] initWithNibName:@"DSAppSkinnerViewController" bundle:nil];
        [_settingsViewController setSettingsDelegate:self];
    }
    return _settingsViewController;
}
@end
