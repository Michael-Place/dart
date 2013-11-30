//
//  DSPlayer.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSPlayer.h"

@interface DSPlayer ()
@property int score;

@end

@implementation DSPlayer
static int const NumberOfStrikesNecessaryBeforeScoringPoints = 3;

- (id)initWithPlayerName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.playerName = name;
        self.score = 0;
    }
    return self;
}

- (void)incrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    NSNumber *updatedScore = [NSNumber numberWithInt:numberOfStrikesForScoreValue.intValue + 1];
    
    [self.playerStatistics setObject:updatedScore forKey:[NSNumber numberWithInt:scoreValue]];
}

- (void)decrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    NSNumber *updatedScore = [NSNumber numberWithInt:numberOfStrikesForScoreValue.intValue - 1];
    
    [self.playerStatistics setObject:updatedScore forKey:[NSNumber numberWithInt:scoreValue]];
}

- (int)pointsEarnedForCricketScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    int numberOfPointScoringStrikes = numberOfStrikesForScoreValue.intValue - NumberOfStrikesNecessaryBeforeScoringPoints;
    int pointsEarned = numberOfPointScoringStrikes * scoreValue;
    
    return pointsEarned;
}

- (int)totalPointsEarned
{
    NSArray *scoreValueKeys = [self.playerStatistics allKeys];
    int pointsEarned = 0;
    
    for (NSString *key in scoreValueKeys) {
        pointsEarned += [self pointsEarnedForCricketScoreValue:[DSGame scoreValueForKeyString:key]];
    }
    
    return pointsEarned;
}

- (BOOL)isClosedForScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    BOOL isClosed = (numberOfStrikesForScoreValue.intValue >= 3);
    
    return isClosed;
}

- (NSMutableDictionary *)playerStatistics
{
    if (!_playerStatistics) {
        _playerStatistics = [NSMutableDictionary dictionaryWithDictionary:@{CricketScoreStringBullseye : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringTwenty : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringNineteen : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringEighteen : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringSeventeen : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringSixteen : [NSNumber numberWithInt:0],
                                                                            CricketScoreStringFifteen : [NSNumber numberWithInt:0]}];
    }
    
    return _playerStatistics;
}
@end
