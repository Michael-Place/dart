//
//  DSGame.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSGame.h"
#import "DSPlayer.h"

@interface DSGame ()
@property (nonatomic, strong) NSDictionary *scoreValueDictionary;
@property (nonatomic, strong) NSMutableArray *cricketScoreList;


@end

@implementation DSGame
NSString *const CricketScoreStringDoubleBullseye = @"DoubleBullseye";
NSString *const CricketScoreStringBullseye = @"Bull";
NSString *const CricketScoreStringTwenty = @"Twenty";
NSString *const CricketScoreStringNineteen = @"Nineteen";
NSString *const CricketScoreStringEighteen = @"Eighteen";
NSString *const CricketScoreStringSeventeen = @"Seventeen";
NSString *const CricketScoreStringSixteen = @"Sixteen";
NSString *const CricketScoreStringFifteen = @"Fifteen";

+ (DSGame *)sharedGame
{
    static DSGame *sharedGame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGame = [[self alloc] init];
        sharedGame.players = [NSMutableArray array];
    });
    return sharedGame;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Game with players: %@>",
            [self players]];
}

#pragma mark - Getters
- (NSDictionary *)scoreValueDictionary
{
    if (!_scoreValueDictionary) {
        _scoreValueDictionary = @{CricketScoreStringDoubleBullseye : [NSNumber numberWithInt:CricketScoreValueDoubleBullseye],
                                  CricketScoreStringBullseye : [NSNumber numberWithInt:CricketScoreValueBullseye],
                                  CricketScoreStringTwenty : [NSNumber numberWithInt:CricketScoreValueTwenty],
                                  CricketScoreStringNineteen : [NSNumber numberWithInt:CricketScoreValueNineteen],
                                  CricketScoreStringEighteen : [NSNumber numberWithInt:CricketScoreValueEighteen],
                                  CricketScoreStringSeventeen : [NSNumber numberWithInt:CricketScoreValueSeventeen],
                                  CricketScoreStringSixteen : [NSNumber numberWithInt:CricketScoreValueSixteen],
                                  CricketScoreStringFifteen : [NSNumber numberWithInt:CricketScoreValueFifteen]
                                  };
    }
    return _scoreValueDictionary;
}

- (NSArray *)cricketScoreList
{
    if (!_cricketScoreList) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CricketScoreValueList" ofType:@"plist"]];
        _cricketScoreList = [dictionary objectForKey:@"CricketScoreValueStringList"];
    }
    return _cricketScoreList;
}

#pragma mark - Game Actions
- (void)resetGame
{
    self.winner = nil;
    self.gameStatusPointValueDictionary = nil;
    
    for (DSPlayer *player in self.players) {
        [player setPlayerStatistics:nil];
    }
}

#pragma mark - Game state updater
- (void)incrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName
{
    DSPlayer *player = [self playerWithName:playerName];
    
    [player incrementStrikeCountForScoreValue:value];
    [self willUpdateDisplay];
}

- (void)decrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName
{
    DSPlayer *player = [self playerWithName:playerName];
    
    [player decrementStrikeCountForScoreValue:value];
    [self willUpdateDisplay];
}

- (void)willUpdateDisplay
{
    [[DSGame sharedGame] updateScoreValuesToBeClosed];
    [[DSGame sharedGame] updateGameForPossibleWinner];
    [self.delegate updateGameState];
}


#pragma mark - Helpers
- (DSPlayer *)playerWithName:(NSString *)name
{
    int playerIndex = 0;
    DSPlayer *playerToReturn;
    
    while (playerIndex < self.players.count) {
        DSPlayer *player = (DSPlayer *)self.players[playerIndex];
        if ([player.playerName isEqualToString:name]) {
            playerToReturn = player;
        }
        playerIndex++;
    }
    
    return playerToReturn;
}

- (void)updateGameForPossibleWinner
{
    int playerCounter = 0;
    int currentMaxScore = 0;
    DSPlayer *possibleWinner;
    while (playerCounter < self.players.count) {
        DSPlayer *player = self.players[playerCounter];
        if ([player totalPointsEarned] > currentMaxScore) {
            possibleWinner = player;
            currentMaxScore = [possibleWinner totalPointsEarned];
        }
        playerCounter++;
    }
    
    if ([possibleWinner hasClosedAllScoreValues] && [possibleWinner totalPointsEarned] > 0) {
        self.winner = possibleWinner.playerName;
    } else {
        self.winner = [NSString string];
    }
}

- (void)updateScoreValuesToBeClosed
{
    self.gameStatusPointValueDictionary = [NSMutableDictionary dictionary];
    
    int scoreIndex = 0;
    
    while (scoreIndex < self.cricketScoreList.count) {
        int cricketScoreValue = [DSGame scoreValueForIndex:scoreIndex];
        NSString *scoreValueString = [DSGame keyStringForCricketScoreValue:cricketScoreValue];
        NSNumber *shouldCloseScore = [NSNumber numberWithBool:[self shouldCloseScoreValue:cricketScoreValue]];
        [self.gameStatusPointValueDictionary setObject:shouldCloseScore forKey:scoreValueString];
        scoreIndex++;
    }
    NSLog(@"here");
}

- (BOOL)shouldCloseScoreValue:(enum CricketScoreValue)value
{
    BOOL shouldCloseScoreValue = NO;
    int isClosedForPlayerCount = 0;
    int playerCounter = 0;
    int playerCount = 0;
    while (playerCounter < self.players.count) {
        DSPlayer *player = self.players[playerCounter];
        playerCount++;
        if ([player pointsEarnedForCricketScoreValue:value] > 2) {
            isClosedForPlayerCount++;
        }
        playerCounter++;
    }
    if (isClosedForPlayerCount == playerCount) {
        shouldCloseScoreValue = YES;
    }
    return shouldCloseScoreValue;
}

+ (enum CricketScoreValue)scoreValueForIndex:(int)index
{
    NSString *cricketValueString = [DSGame sharedGame].cricketScoreList[index];
    int scoreValue = [self scoreValueForKeyString:cricketValueString];
    if ([cricketValueString isEqualToString:CricketScoreStringBullseye]) {
        scoreValue = 25;
    }
    return scoreValue;
}

+ (NSString *)keyStringForCricketScoreValue:(enum CricketScoreValue)scoreValue
{
    NSString *keyForScoreValue = [[[[DSGame sharedGame] scoreValueDictionary] allKeysForObject:[NSNumber numberWithInt:scoreValue]] lastObject];
    
    return keyForScoreValue;
}

+ (enum CricketScoreValue)scoreValueForKeyString:(NSString *)keyString
{
    enum CricketScoreValue scoreValue = (int)[[[[DSGame sharedGame] scoreValueDictionary] objectForKey:keyString] integerValue];
    
    return scoreValue;
}



@end
