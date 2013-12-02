//
//  DSPlayer.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSGame.h"

@interface DSPlayer : NSObject
@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, strong) NSMutableDictionary *playerStatistics;
@property BOOL playerNameHasBeenEdited;
@property BOOL isEditMode;

//Init
- (id)initWithPlayerName:(NSString *)name;

// Add or subtract strikes for a particular score value
- (void)incrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue;
- (void)decrementStrikeCountForScoreValue:(enum CricketScoreValue)scoreValue;

// Returns the number of points scored for a particular score value
- (int)pointsEarnedForCricketScoreValue:(enum CricketScoreValue)scoreValue;

// Returns the total number of points earned by the player
- (int)totalPointsEarned;

// Returns true if the score value has been closed (aka been struck three times)
- (BOOL)isClosedForScoreValue:(enum CricketScoreValue)scoreValue;

@end
