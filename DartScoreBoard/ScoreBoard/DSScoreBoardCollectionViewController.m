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
#import "DSGameActionItemViewController.h"
#import "DSGame.h"
#import "DSHelper.h"

@interface DSScoreBoardCollectionViewController () <StartingGameDelegate, UpdatingGameState, ScoreBoardCollectionViewCellDelegate, DSGameActionDelegate>
@property BOOL gameIsInProgress;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreBoardCollectionView;
@property (nonatomic, strong) DSGameActionItemViewController *gameActionItemViewController;
@property (nonatomic, strong) DSNewGameViewController *newGameViewController;
@property (nonatomic, strong) NSMutableArray *headerViews;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *gameTimerLabel;

@end

@implementation DSScoreBoardCollectionViewController
static NSString *const ScoreBoardCollectionViewCellIdentifier = @"ScoreBoardCollectionViewCellIdentifier";
static NSString *const ScoreBoardHeaderIdentifier = @"ScoreBoardHeaderIdentifier";
static NSString *const ScoreBoardHeaderLandscapeIdentifier = @"ScoreBoardHeaderLandscapeIdentifier";
const int kAppRatingAlertViewTag = 100;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.headerViews = [NSMutableArray array];
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
    [self.view addSubview:self.gameActionItemViewController.view];
    [self.view addSubview:self.gameTimerLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.collectionView setBackgroundColor:[DSAppSkinner globalBackgroundColor]];
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
    [self presentViewController:self.newGameViewController animated:YES completion:nil];
}

- (void)startGame
{
    self.gameIsInProgress = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateGameTimeLabel) userInfo:[NSDate date] repeats:YES];

}

#pragma mark - Update Game State Delegate
- (void)updateGameState
{
    [self.scoreBoardCollectionView reloadData];
    [self reloadSectionHeaders];
    
    if ([DSGame sharedGame].winner && [DSGame sharedGame].winner.length > 0) {
        [self.timer invalidate];
        if ([DSHelper shouldRequestRating]) {
            [self showRateUsAlertView];
        }
    }
}

- (void)reloadSectionHeaders
{
    for (DSScoreCollectionView *header in self.headerViews) {
        [header.scoreTableView reloadData];
    }
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    int numberOfSections;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        numberOfSections = (int)[[[DSGame sharedGame] players] count];
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
    [self setColorForCell:scoreBoardCell atIndexPath:indexPath];
    
    [scoreBoardCell.playerNameLabel setText:playerForCell.playerName];
    [scoreBoardCell.totalScoreLabel setText:[NSString stringWithFormat:@"%d", playerForCell.totalPointsEarned]];
    [scoreBoardCell.playerScoreTableView reloadData];

    
    if ([DSGame sharedGame].winner && [[DSGame sharedGame].winner isEqualToString:playerForCell.playerName]) {
        [scoreBoardCell setBackgroundColor:[DSAppSkinner scoreBoardWinningPlayerColor]];
    } else {
        [scoreBoardCell setBackgroundColor:[UIColor clearColor]];
    }
    
    return scoreBoardCell;

}

- (void)setColorForCell:(DSScoreBoardCollectionViewCell *)scoreBoardCell atIndexPath:(NSIndexPath *)indexPath
{
    if ([[[DSGame sharedGame] players] count] <= 3) {
        if (indexPath.section % 2 == 0) {
            [scoreBoardCell.colorView setBackgroundColor:[DSAppSkinner primaryScoreBoardForegroundColor]];
        }
        else {
            [scoreBoardCell.colorView setBackgroundColor:[DSAppSkinner complimentaryScoreBoardForegroundColor]];
        }
    }
    else {
        if ((indexPath.row % 2 == 0)) {
            [scoreBoardCell.colorView setBackgroundColor:[DSAppSkinner primaryScoreBoardForegroundColor]];
        }
        else {
            [scoreBoardCell.colorView setBackgroundColor:[DSAppSkinner complimentaryScoreBoardForegroundColor]];
        }
    }
}

- (DSPlayer *)playerForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexOfPlayer;
    if ([[[DSGame sharedGame] players] count] <= 3) {
        indexOfPlayer = (int)indexPath.section;
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

    [self.headerViews addObject:supplementaryView];
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
        numberOfSectionHeaders = (int)[[[DSGame sharedGame] players] count] - 1;
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
        numberOfSectionHeaders = (int)[[[DSGame sharedGame] players] count] - 1;
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Game Timer functions
- (void)updateGameTimeLabel
{
    // Get the start date, and the time that has passed since
    NSDate *startDate = [DSGame sharedGame].gameStartTime;
    NSTimeInterval timePassed = [[NSDate date] timeIntervalSinceDate:startDate];
    
    // Convert interval in seconds to hours, minutes and seconds
    int hours = timePassed / (60 * 60);
    int minutes = ((int)timePassed % (60 * 60)) / 60;
    int seconds = (((int)timePassed % (60 * 60)) % 60);
    NSString *time = [NSString stringWithFormat:@"%i:%i:%i", hours, minutes, seconds];
    
    self.gameTimerLabel.text = time;
    
}

#pragma mark - Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.gameTimerLabel.frame = CGRectMake(self.collectionView.frame.size.width - kTimeLabelWidth, 20, kTimeLabelWidth, 20);
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
    int numberOfSections = (int)[[[DSGame sharedGame] players] count] / 2;
    
    // handle if player count does not divide evenly
    if ([[[DSGame sharedGame] players] count] % 2 != 0) {
        numberOfSections++;
    }
    
    return numberOfSections;
}

#pragma mark - DSGameActionDelegate
- (void)didSelectGameAction:(enum DSGameAction)gameAction
{
    switch (gameAction) {
        case DSGameActionResetGame:
            [self resetGame];
            break;
        case DSGameActionStartNewGameWithSamePlayers:
            [self startNewGameWithSamePlayers];
            break;
        case DSGameActionNavigateBackToNewGameView:
            [self navigateBackToNewGameView];
            break;
        default:
            break;
    }
}

- (void)resetGame
{
    // Reset shared game object and reload collection view
    [[DSGame sharedGame] resetGame];
    
    [self reloadSectionHeaders];
    [self.collectionView reloadData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateGameTimeLabel) userInfo:[NSDate date] repeats:YES];

}

- (void)startNewGameWithSamePlayers
{
    // Clear game data
    [self clearGameData];
    
    // Set up new game view controller with current players
    [self.newGameViewController setInitialPlayers:[[DSGame sharedGame] players]];
    [self displayNewGameModal];
}

- (void)navigateBackToNewGameView
{
    [self clearGameData];
    [self displayNewGameModal];
}

- (void)clearGameData
{
    self.newGameViewController = nil;
    [[DSGame sharedGame] resetGame];
    
    [self reloadSectionHeaders];
    [self.collectionView reloadData];
}

#pragma mark - Rate Us functions
- (void)showRateUsAlertView
{
    UIAlertView *ratingRequestAlertView = [[UIAlertView alloc]initWithTitle:[NSString string] message:@"Please help us by rating our app.  Thank you!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate Now", nil];
    ratingRequestAlertView.tag = kAppRatingAlertViewTag;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidRequestRatingForVersionKey];
    
    [ratingRequestAlertView show];
}

- (void)rateGame
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=409954448"]];
}

#pragma mark - AlerView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAppRatingAlertViewTag) {
        if (buttonIndex == 1) {
            [self rateGame];
        }
    }
}

#pragma mark - Getters
- (DSNewGameViewController *)newGameViewController
{
    if (!_newGameViewController) {
        _newGameViewController = [[DSNewGameViewController alloc] initWithNibName:@"DSNewGameViewController" bundle:nil];
        [_newGameViewController setDelegate:self];
    }
    return _newGameViewController;
}

const int GameActionButtonPadding = 0;
- (DSGameActionItemViewController *)gameActionItemViewController
{
    if (!_gameActionItemViewController) {
        _gameActionItemViewController = [[DSGameActionItemViewController alloc] initWithNibName:@"DSGameActionItemViewController" bundle:nil];
        [_gameActionItemViewController.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - _gameActionItemViewController.view.frame.size.height - GameActionButtonPadding)];
        [_gameActionItemViewController setGameActionDelegate:self];
    }
    return _gameActionItemViewController;
}

const int kTimeLabelWidth = 60;
- (UILabel *)gameTimerLabel
{
    if (!_gameTimerLabel) {
        _gameTimerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - kTimeLabelWidth, 20, kTimeLabelWidth, 20)];
        [_gameTimerLabel setCenter:_gameTimerLabel.center];
        [_gameTimerLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    }
    return _gameTimerLabel;
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
}

@end
