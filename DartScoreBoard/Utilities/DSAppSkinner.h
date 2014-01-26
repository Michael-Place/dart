//
//  DSAppSkinner.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DSAppColor {
    DSAppColorScoreBoardTextColor,
    DSAppColorOddPlayerScoreBoardColor,
    DSAppColorEvenPlayerScoreBoardColor,
    DSAppColorScoreBoardClosedColor,
    DSAppColorScoreBoardWinningPlayerColor,
    DSAppColorScoreBoardDividerColor
    };

enum DSTheme {
    DSThemeNightMode,
    DSThemeDayMode
    };

@interface DSAppSkinner : NSObject
extern NSString *const ScoreBoardTextColorKey;
extern NSString *const OddPlayerScoreBoardColorKey;
extern NSString *const EvenPlayerScoreBoardColorKey;
extern NSString *const ScoreBoardClosedColorKey;
extern NSString *const ScoreBoardWinningPlayerColorKey;
extern NSString *const ScoreBoardDividerColorKey;

+ (void)initializeColorsIfNecessaryOverride:(BOOL)override;

// Theme value for the app
+ (enum DSTheme)appTheme;

// Color for the background of the app
+ (UIColor *)globalBackgroundColor;

// Color for the app text
+ (UIColor *)globalTextColor;

// Color for the player cell. (Alternates with the complimentary foreground color)
+ (UIColor *)oddPlayerScoreboardColor;

// Color for the player cell. (Alternates with the primary foreground color)
+ (UIColor *)evenPlayerScoreBoardColor;

// Color for the score dividers on the score board.
+ (UIColor *)scoreBoardDividerColor;

// Text color for the score board
+ (UIColor *)scoreBoardTextColor;

// Text color for the score board when a score has been closed
+ (UIColor *)scoreBoardClosedColor;

// Color for the winning player when the game ends
+ (UIColor *)scoreBoardWinningPlayerColor;

// Color Helpers
+ (UIColor *)colorForColorKey:(NSString *)colorKey;
+ (void)saveColor:(UIColor *)color forKey:(NSString *)colorKey;

+ (NSString *)keyForAppColor:(enum DSAppColor)appColor;

// Update the app theme value
+ (void)setAppTheme:(enum DSTheme)theme;

@end
