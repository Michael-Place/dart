//
//  DSGame.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

// Enumerates the scorable cricket values
enum CricketScoreValue {
    CricketScoreValueDoubleBullseye = 50,
    CricketScoreValueBullseye = 25,
    CricketScoreValueTwenty = 20,
    CricketScoreValueNineteen = 19,
    CricketScoreValueEighteen = 18,
    CricketScoreValueSeventeen = 17,
    CricketScoreValueSixteen = 16,
    CricketScoreValueFifteen = 15
};

@protocol UpdatingGameState;

@interface DSGame : NSObject
// String representations of the enumerated values
extern NSString *const CricketScoreStringDoubleBullseye;
extern NSString *const CricketScoreStringBullseye;
extern NSString *const CricketScoreStringTwenty;
extern NSString *const CricketScoreStringNineteen;
extern NSString *const CricketScoreStringEighteen;
extern NSString *const CricketScoreStringSeventeen;
extern NSString *const CricketScoreStringSixteen;
extern NSString *const CricketScoreStringFifteen;

// Array of players for the game
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, weak) id <UpdatingGameState> delegate;

// Shared instance
+ (DSGame *)sharedGame;

// Returns the key string associated with the score value and vice versa
+ (enum CricketScoreValue)scoreValueForIndex:(int)index;
+ (NSString *)keyStringForCricketScoreValue:(enum CricketScoreValue)scoreValue;
+ (enum CricketScoreValue)scoreValueForKeyString:(NSString *)keyString;

- (void)flushPlayerListWithScoreCards;
- (void)incrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName;
- (void)decrementScoreValue:(enum CricketScoreValue)value forPlayerNamed:(NSString *)playerName;

@end

@protocol UpdatingGameState <NSObject>

- (void)updateGameState;

@end

