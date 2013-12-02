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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Cricket Player: %@, Statistics: %@>",
            [self playerName], self.playerStatistics];
}

- (void)incrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    NSNumber *updatedScore = [NSNumber numberWithInt:numberOfStrikesForScoreValue.intValue + 1];
    
    [self.playerStatistics setObject:updatedScore forKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
}

- (void)decrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue
{
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    
    NSNumber *updatedScore = [NSNumber numberWithInt:numberOfStrikesForScoreValue.intValue - 1];
    
    if (updatedScore.integerValue >= 0) {
        [self.playerStatistics setObject:updatedScore forKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    }
}

- (int)pointsEarnedForCricketScoreValue:(enum CricketScoreValue)scoreValue
{
    int pointsEarned;
    NSNumber *numberOfStrikesForScoreValue = [self.playerStatistics objectForKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
    pointsEarned = numberOfStrikesForScoreValue.integerValue;
    
//    if (pointsEarned < 0) {
//        NSLog(@"this is why we initiate");
//        [self.playerStatistics setObject:[NSNumber numberWithInt:0] forKey:[DSGame keyStringForCricketScoreValue:scoreValue]];
//        pointsEarned = 0;
//    }
    
    if (pointsEarned > NumberOfStrikesNecessaryBeforeScoringPoints) {
        int numberOfPointScoringStrikes = numberOfStrikesForScoreValue.intValue - NumberOfStrikesNecessaryBeforeScoringPoints;
        pointsEarned = numberOfPointScoringStrikes * scoreValue;
    }
    
    return pointsEarned;
}

- (int)totalPointsEarned
{
    NSArray *scoreValueKeys = [self.playerStatistics allKeys];
    int pointsEarned = 0;
    
    for (NSString *key in scoreValueKeys) {
        int scoreForKey = [self pointsEarnedForCricketScoreValue:[DSGame scoreValueForKeyString:key]];
        if (scoreForKey > 3) {
            pointsEarned += scoreForKey;
        }
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
