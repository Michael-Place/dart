//
//  DSScoreBoardCollectionViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSScoreBoardCollectionViewController.h"
#import "DSScoreBoardCollectionViewCell.h"
#import "DSScoreCollectionViewCell.h"
#import "DSNewGameViewController.h"
#import "DSGame.h"

@interface DSScoreBoardCollectionViewController () <StartingGameDelegate, UpdatingGameState>
@property BOOL gameIsInProgress;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreBoardCollectionView;

@end

@implementation DSScoreBoardCollectionViewController
static NSString *const ScoreBoardCollectionViewCellIdentifier = @"ScoreBoardCollectionViewCellIdentifier";
static NSString *const ScoreBoardScoreCellIdentifier = @"ScoreBoardScoreCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreBoardCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreBoardScoreCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ScoreBoardScoreCellIdentifier];
    [DSGame sharedGame].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self testGameSetup];
    
    if (!self.gameIsInProgress) {
        [self displayNewGameModal];
    }
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Starting Game Delegate
- (void)displayNewGameModal
{
    DSNewGameViewController *newGameVC = [[DSNewGameViewController alloc] initWithNibName:@"DSNewGameViewController" bundle:nil];
    [newGameVC setDelegate:self];
    [self presentViewController:newGameVC animated:YES completion:nil];
}

- (void)startGame
{
    self.gameIsInProgress = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    [[DSGame sharedGame]flushPlayerListWithScoreCards];
}

#pragma mark - Update Game State Delegate
- (void)updateGameState
{
    [self.scoreBoardCollectionView reloadData];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int playerCount = [[[DSGame sharedGame] players] count];
    return playerCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if ([[DSGame sharedGame].players[indexPath.row] isKindOfClass:[NSString class]]) {
        cell = [self scoreBoardScoreCellForCollectionView:collectionView forIndexPath:indexPath];
    } else {
        cell = [self scoreBoardCellForCollectionView:collectionView forIndexPath:indexPath];
    }
    

    return cell;
}

- (UICollectionViewCell *)scoreBoardCellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    DSScoreBoardCollectionViewCell *scoreBoardCell = [collectionView dequeueReusableCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier forIndexPath:indexPath];
    DSPlayer *playerForCell = [[[DSGame sharedGame] players] objectAtIndex:indexPath.row];
    [scoreBoardCell setPlayer:playerForCell];
//    UIColor *scoreBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalk_pallet.png"]];
    [scoreBoardCell.playerNameLabel setTextColor:[UIColor whiteColor]];
    [scoreBoardCell.playerNameLabel setText:playerForCell.playerName];
    [scoreBoardCell.playerScoreTableView reloadData];
    [scoreBoardCell.totalScoreLabel setTextColor:[UIColor whiteColor]];
    scoreBoardCell.totalScoreLabel.text = [NSString stringWithFormat:@"%d", playerForCell.totalPointsEarned];
    if ([DSGame sharedGame].winner && [[DSGame sharedGame].winner isEqualToString:playerForCell.playerName]) {
        scoreBoardCell.backgroundColor = [UIColor blueColor];
    } else {
        scoreBoardCell.backgroundColor = [UIColor clearColor];
    }
    
    return scoreBoardCell;
}

- (UICollectionViewCell *)scoreBoardScoreCellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    DSScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScoreBoardScoreCellIdentifier forIndexPath:indexPath];
    
    [cell setUpScoreValue];
    return cell;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UICollectionViewFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = [self loadScoreBoardCollectionViewCellFromNib].frame.size;
    itemSize.height = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ?  [[UIScreen mainScreen] bounds].size.width :  [[UIScreen mainScreen] bounds].size.height;
    return itemSize;
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
}

#pragma mark - Helpers
- (DSScoreBoardCollectionViewCell *)loadScoreBoardCollectionViewCellFromNib
{
    NSArray *scoreBoardCellNib = [[NSBundle mainBundle] loadNibNamed:@"DSScoreBoardCollectionViewCell" owner:self options:nil];
    DSScoreBoardCollectionViewCell *scoreBoardCell = [scoreBoardCellNib objectAtIndex:0];
    return scoreBoardCell;
}

#pragma mark - Test Code
- (void) testGameSetup
{
    DSPlayer *player1 = [[DSPlayer alloc]initWithPlayerName:@"George"];
    DSPlayer *player2 = [[DSPlayer alloc]initWithPlayerName:@"Michael"];
//    DSPlayer *player3 = [[DSPlayer alloc]initWithPlayerName:@"test1"];
//    DSPlayer *player4 = [[DSPlayer alloc]initWithPlayerName:@"test2"];
//    DSPlayer *player5 = [[DSPlayer alloc]initWithPlayerName:@"George"];
//    DSPlayer *player6 = [[DSPlayer alloc]initWithPlayerName:@"Michael"];
//    DSPlayer *player7 = [[DSPlayer alloc]initWithPlayerName:@"test1"];
//    DSPlayer *player8 = [[DSPlayer alloc]initWithPlayerName:@"test2"];

//    [DSGame sharedGame].players = @[player1, player2, player3, player4, player5, player6, player7, player8];
    [DSGame sharedGame].players = @[player1, player2];
    self.gameIsInProgress = YES;
    [[DSGame sharedGame] flushPlayerListWithScoreCards];

}

@end
