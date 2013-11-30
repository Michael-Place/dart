//
//  DSNewGameViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSNewGameViewController.h"
#import "DSNewGameViewController.h"
#import "DSAddNewPlayerViewController.h"
#import "DSPlayer.h"
#import "DSGame.h"

const int kDefaultNumberOfPlayers = 4;
const int kMaxNumberOfPlayers = 8;
const int kDartGap = 60;

@interface DSNewGameViewController () <NewPlayerAdded>
@property (strong, nonatomic)NSMutableArray *addNewPlayerViewControllers;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

//Dyanmics
@property (nonatomic, strong)NSMutableArray *darts;
@property (nonatomic, strong)UIDynamicAnimator *animator;
@property (nonatomic, strong)UIGravityBehavior *gravity;
@property (nonatomic, strong)UICollisionBehavior *collision;



- (IBAction)startGameClicked:(id)sender;
@end

@implementation DSNewGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Did load New Game view");
    //Reset DSGame
    self.addNewPlayerViewControllers = [NSMutableArray array];
    [[DSGame sharedGame] setPlayers:[NSArray array]];
    [self setupDefaultNewGame];
    
    //UIDynamics
    self.darts = [NSMutableArray array];
    [self addCollisionBoundaryForView:self.startGameButton];
    
}

- (void)setupDefaultNewGame
{
    //test code
    [self createAddNewGameViewForPlayer:0];
}

- (void)createAddNewGameViewForPlayer:(int)nthPlayer
{
    int currentPlayerCount = (int)[DSGame sharedGame].players.count;
    int counter = 0;
    if (currentPlayerCount < 4) {
        currentPlayerCount = kDefaultNumberOfPlayers;
    }
    
    while (counter < currentPlayerCount) {
        DSAddNewPlayerViewController *addNewPlayerVC = [[DSAddNewPlayerViewController alloc]initWithNibName:@"NewPlayerViewController" bundle:nil];
        [self updateFrameForNewPlayerView:addNewPlayerVC.view ForIndex:counter outOf:currentPlayerCount];
        addNewPlayerVC.delegate = self;
        [self.view addSubview:addNewPlayerVC.view];
        [self.addNewPlayerViewControllers addObject:addNewPlayerVC];
        
        //UIDynamic Shanigian
        [self addCollisionBoundaryForView:addNewPlayerVC.view];
        counter++;
    }
    
    
}

- (void)updateFrameForNewPlayerView:(UIView *)view ForIndex:(int)index outOf:(int)totalPlayercount
{
    //Update X
    int xIndex = index;
    CGPoint centerForView = self.view.center;
    if (xIndex > 3) {
        xIndex = xIndex - 4;
    }
    switch (xIndex) {
        case 0:{
            centerForView.x = centerForView.x - centerForView.x/2 - centerForView.x/4;
            break;
        }
        case 1:{
            centerForView.x = centerForView.x - centerForView.x/2 + centerForView.x/4;
            break;
        }
        case 2:{
            centerForView.x = centerForView.x + centerForView.x/2 - centerForView.x/4;
            break;
        }
        case 3:{
            centerForView.x = centerForView.x + centerForView.x/2 + centerForView.x/4;
            break;
        }
        default:
            break;
    }
    
    view.center = centerForView;
    CGRect updatedFrame = view.frame;
    
    //Update Y
    view.center = self.view.center;
    if (index > 3) {
        updatedFrame.origin.y = updatedFrame.origin.y + updatedFrame.size.height + updatedFrame.size.height/4;
    }
    view.frame = updatedFrame;
    
}


- (IBAction)startGameClicked:(id)sender
{
    NSMutableArray *players = [NSMutableArray array];
    
    for (DSAddNewPlayerViewController *addNewPlayerVC in self.addNewPlayerViewControllers) {
        if (addNewPlayerVC.playerNameLabel.text.length) {
            NSLog(@"Add player: %@", addNewPlayerVC.playerNameLabel.text);
            DSPlayer *player = [[DSPlayer alloc]initWithPlayerName:addNewPlayerVC.playerNameLabel.text];
            [players addObject:player];
        }
    }
    
    if (players.count > 1) {
        [[DSGame sharedGame] setPlayers:[NSArray arrayWithArray:players]];
        [self.delegate startGame];
    } else {
        NSLog(@"Place holder for need more players");
        UIAlertView *needMorePlayersAlert = [[UIAlertView alloc]initWithTitle:@"Need More Players" message:@"Need minimum of two players to start game." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [needMorePlayersAlert show];
        
    }
}

#pragma mark - NewPlayer delegates
- (void)newPlayerAddedWithName:(NSString *)playerName
{
    NSLog(@"New Player Added!! Throw Dart");
    UIImageView *dartView = [[UIImageView alloc]initWithFrame:CGRectMake(-100, 30, 200, 30)];
    [dartView setImage:[UIImage imageNamed:@"dart.png"]];
    
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[dartView]];
    itemBehaviour.elasticity = 0.3;
    [itemBehaviour addAngularVelocity:20.0 forItem:dartView];
    
    //    itemBehaviour.angularResistance = 10.0;
    
    [self.darts addObject:dartView];
    [self.view addSubview:dartView];
    
    
    CGPoint endPoint = [self getDartEndPoint];
    
    [self addGravityForView:dartView];
    [self addSnapForView:dartView toPoint:endPoint];
}

- (CGPoint)getDartEndPoint
{
    int minY = 50;
    int currentDart = (int)self.darts.count - 1;
    int yOffset = minY + (currentDart * kDartGap);
    
    CGPoint endPoint = CGPointMake(self.view.frame.size.width-55, yOffset);
    return endPoint;
}

- (void)newPlayerRemoved
{
    NSLog(@"New Player Removed. Drop Dart");
    
    if (self.darts && self.darts.count) {
        UIView *dartView = [self.darts lastObject];
        
        UIImageView *dropDart = [[UIImageView alloc]initWithFrame:dartView.frame];
        //        [dropDart setBackgroundColor:[UIColor orangeColor]];
        [dropDart setImage:[UIImage imageNamed:@"dart.png"]];
        
        [self.darts removeLastObject];
        [dartView removeFromSuperview];
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
    UISnapBehavior *snapDart = [[UISnapBehavior alloc]initWithItem:view snapToPoint:point];
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
    UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
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
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_TopEdgeBarrier",(unsigned long)self.addNewPlayerViewControllers.count];
    CGPoint topRightEdge = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:view.frame.origin toPoint:topRightEdge];
}

- (void)addRightEdgeBarrierForView:(UIView *)view
{
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_RightEdgeBarrier",(unsigned long)self.addNewPlayerViewControllers.count];
    CGPoint topRightEdge = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
    CGPoint bottomRightEdge = CGPointMake(view.frame.size.width + view.frame.origin.x, view.frame.origin.y + view.frame.size.height);
    
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:topRightEdge toPoint:bottomRightEdge];
}

- (void)addLeftEdgeBarrierForView:(UIView *)view
{
    NSString *identifier = [NSString stringWithFormat:@"View_%lu_LeftEdgeBarrier",(unsigned long)self.addNewPlayerViewControllers.count];
    CGPoint topLeftEdge = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    CGPoint bottomLeftEdge = CGPointMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height);
    
    [self.collision addBoundaryWithIdentifier:identifier fromPoint:topLeftEdge toPoint:bottomLeftEdge];
}

#pragma mark - UIDynamic properties
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
    }
    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc]init];
        [_collision setTranslatesReferenceBoundsIntoBoundary:YES];
        _collision.collisionDelegate = (id)self;
    }
    return _collision;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.view setNeedsDisplay];
}

@end
