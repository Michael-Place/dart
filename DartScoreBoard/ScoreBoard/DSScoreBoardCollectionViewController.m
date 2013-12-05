//
//  DSScoreBoardCollectionViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSScoreBoardCollectionViewController.h"
#import "DSScoreBoardCollectionViewCell.h"
#import "DSScoreCollectionView.h"
#import "DSNewGameViewController.h"
#import "DSGame.h"

@interface DSScoreBoardCollectionViewController () <StartingGameDelegate, UpdatingGameState, ScoreBoardCollectionViewCellDelegate>
@property BOOL gameIsInProgress;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreBoardCollectionView;

@end

@implementation DSScoreBoardCollectionViewController
static NSString *const ScoreBoardCollectionViewCellIdentifier = @"ScoreBoardCollectionViewCellIdentifier";
static NSString *const ScoreBoardHeaderIdentifier = @"ScoreBoardHeaderIdentifier";
static NSString *const ScoreBoardHeaderLandscapeIdentifier = @"ScoreBoardHeaderLandscapeIdentifier";

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreCollectionView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScoreBoardHeaderIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreCollectionViewLandscape" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScoreBoardHeaderLandscapeIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreBoardCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier];
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
//    [[DSGame sharedGame]flushPlayerListWithScoreCards];
}

#pragma mark - Update Game State Delegate
- (void)updateGameState
{
    [self.scoreBoardCollectionView reloadData];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int numberOfSections;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        numberOfSections = [[[DSGame sharedGame] players] count];
    }
    else {
        numberOfSections = [self numberOfSectionsBasedOnPlayerCount];
    }
    
    return numberOfSections;
}

const int DefaultPlayersPerSection = 2;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int playersPerSection = DefaultPlayersPerSection;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        playersPerSection = 1;
    }
    else if ([[[DSGame sharedGame] players] count] % 2 != 0) {
        if (section == [self numberOfSectionsBasedOnPlayerCount] - 1) {
            playersPerSection = [[[DSGame sharedGame] players] count] % 2;
        }
    }
    
    return playersPerSection;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSScoreBoardCollectionViewCell *scoreBoardCell = [collectionView dequeueReusableCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier forIndexPath:indexPath];
    DSPlayer *playerForCell = [self playerForIndexPath:indexPath];
    
    [scoreBoardCell setCellDelegate:self];
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

- (DSPlayer *)playerForIndexPath:(NSIndexPath *)indexPath
{
    int indexOfPlayer;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        indexOfPlayer = indexPath.section;
    }
    else {
        indexOfPlayer = indexPath.section * DefaultPlayersPerSection + indexPath.row;
    }
    
    return (DSPlayer *)[[[DSGame sharedGame] players] objectAtIndex:indexOfPlayer];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DSScoreCollectionView *supplementaryView;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScoreBoardHeaderIdentifier forIndexPath:indexPath];
    }
    else {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ScoreBoardHeaderLandscapeIdentifier forIndexPath:indexPath];
    }
    
    return supplementaryView;
}

#pragma mark - UICollectionViewFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

const int WidthOfHeaderView = 150;
const int MaxPlayersOnScreenForPortrait = 4;
const int MaxPlayersOnScreenForLandscape = 4;
const int DefaultHeadersOnScreenForPortrait = 1;
const int DefaultHeadersOnScreenForLandscape = 1;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        itemSize = [self sizeForPlayerCellsInLandscapeOrientation];
    }
    else {
        itemSize = [self sizeForPlayerCellsInPortraitOrientation];
    }
    
    return itemSize;
}

- (CGSize)sizeForPlayerCellsInLandscapeOrientation
{
    CGSize itemSize = [self loadScoreBoardCollectionViewCellFromNib].frame.size;
    itemSize.height = [[UIScreen mainScreen] bounds].size.width;

    // Calculate number of section headers on screen based on number of players
    int numberOfSectionHeaders;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        numberOfSectionHeaders = [[[DSGame sharedGame] players] count] - 1;
    }
    else {
        numberOfSectionHeaders = DefaultHeadersOnScreenForLandscape;
    }
    
    // Caclulate the width of the cell based on number of players and number of section headers
    if ([[[DSGame sharedGame] players] count] > MaxPlayersOnScreenForLandscape) {
        itemSize.width = (self.collectionView.frame.size.width - (WidthOfHeaderView * numberOfSectionHeaders)) / MaxPlayersOnScreenForLandscape;
    }
    else {
        itemSize.width = (self.collectionView.frame.size.width - (WidthOfHeaderView * numberOfSectionHeaders)) / [[[DSGame sharedGame] players] count];
    }
    
    return itemSize;
    
}

- (CGSize)sizeForPlayerCellsInPortraitOrientation
{
    CGSize itemSize = [self loadScoreBoardCollectionViewCellFromNib].frame.size;
    itemSize.height = [[UIScreen mainScreen] bounds].size.height;
    
    // Calculate number of section headers on screen based on number of players
    int numberOfSectionHeaders;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        numberOfSectionHeaders = [[[DSGame sharedGame] players] count] - 1;
    }
    else {
        numberOfSectionHeaders = DefaultHeadersOnScreenForPortrait;
    }
    
    if ([[[DSGame sharedGame] players] count] > MaxPlayersOnScreenForPortrait) {
        itemSize.width = (self.collectionView.frame.size.width - (WidthOfHeaderView * numberOfSectionHeaders)) / MaxPlayersOnScreenForPortrait;
    }
    else {
        itemSize.width = (self.collectionView.frame.size.width - (WidthOfHeaderView * numberOfSectionHeaders)) / [[[DSGame sharedGame] players] count];
    }
    
    return itemSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize;
    if (section == 0) {
        itemSize = CGSizeZero;
    }
    else {
        itemSize = [self loadScoreBoardHeaderFromNib].frame.size;
        itemSize.height =   (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ?  [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height;
    }
    
    return itemSize;
}

// Unfortunately I had to hardcode these values in
// If you make changes to the height of the table view in the nib
// Make sure to come back here and update these values
const int landscapeHeightForTableView = 520;
const int portraitHeightForTableView = 776;
#pragma mark - ScoreBoardCollectionViewDelegate
- (CGFloat)parentHeight
{
    CGFloat height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        height = landscapeHeightForTableView;
    }
    else {
        height = portraitHeightForTableView;
    }
    
    return height;
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

- (DSScoreCollectionView *)loadScoreBoardHeaderFromNib
{
    NSArray *scoreBoardHeaderNib = [[NSBundle mainBundle] loadNibNamed:@"DSScoreCollectionView" owner:self options:nil];
    DSScoreCollectionView *scoreBoardHeader = [scoreBoardHeaderNib objectAtIndex:0];
    return scoreBoardHeader;
}

- (int)numberOfSectionsBasedOnPlayerCount
{
    int numberOfSections = [[[DSGame sharedGame] players] count] / 2;
    
    // handle if player count does not divide evenly
    if ([[[DSGame sharedGame] players] count] % 2 != 0) {
        numberOfSections++;
    }
    
    return numberOfSections;
}

#pragma mark - Test Code
- (void)testGameSetup
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
//    [[DSGame sharedGame] flushPlayerListWithScoreCards];

}

@end
