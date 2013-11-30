//
//  DSScoreBoardCollectionViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSScoreBoardCollectionViewController.h"
#import "DSScoreBoardCollectionViewCell.h"
#import "DSNewGameViewController.h"
#import "DSGame.h"

@interface DSScoreBoardCollectionViewController () <StartingGameDelegate, UpdatingGameState>
@property BOOL gameIsInProgress;
@property (strong, nonatomic) IBOutlet UICollectionView *scoreBoardCollectionView;

@end

@implementation DSScoreBoardCollectionViewController
static NSString *const ScoreBoardCollectionViewCellIdentifier = @"ScoreBoardCollectionViewCellIdentifier";

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"DSScoreBoardCollectionViewCell"
                                                    bundle:[NSBundle mainBundle]]
                                forCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier];
    [DSGame sharedGame].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self testGameSetup];
    
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
    // One cell per player
    return [[[DSGame sharedGame] players] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSScoreBoardCollectionViewCell *scoreBoardCell = [collectionView dequeueReusableCellWithReuseIdentifier:ScoreBoardCollectionViewCellIdentifier forIndexPath:indexPath];
    DSPlayer *playerForCell = [[[DSGame sharedGame] players] objectAtIndex:indexPath.row];
    [scoreBoardCell setPlayer:playerForCell];
    [scoreBoardCell.playerNameLabel setText:playerForCell.playerName];
    [scoreBoardCell.playerScoreTableView reloadData];

    return scoreBoardCell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

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
    [DSGame sharedGame].players = @[player1, player2];
    self.gameIsInProgress = YES;
}

@end
