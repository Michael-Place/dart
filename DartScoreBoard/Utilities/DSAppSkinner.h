//
//  DSAppSkinner.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DSAppColor {
    DSAppColorGlobalBackgroundColor,
    DSAppColorNewGameForegroundColor,
    DSAppColorNewGameFontColor,
    DSAppColorScoreBoardTextColor,
    DSAppColorPrimaryScoreBoardForegroundColor,
    DSAppColorComplimentaryScoreBoardForegroundColor,
    DSAppColorScoreBoardClosedColor,
    DSAppColorScoreBoardWinningPlayerColor
    };

@interface DSAppSkinner : NSObject
extern NSString *const GlobalBackgroundColorKey;
extern NSString *const NewGameForegroundColorKey;
extern NSString *const NewGameFontColorKey;
extern NSString *const ScoreBoardTextColorKey;
extern NSString *const PrimaryScoreBoardForegroundColorKey;
extern NSString *const ComplimentaryScoreBoardForegroundColorKey;
extern NSString *const ScoreBoardClosedColorKey;
extern NSString *const ScoreBoardWinningPlayerColorKey;

+ (void)initializeColorsIfNecessary;

// Color for the background of the app
+ (UIColor *)globalBackgroundColor;


// Color for the foreground elements on the new game view
+ (UIColor *)newGameForegroundColor;

// Text color for the new game view
+ (UIColor *)newGameFontColor;


// Text color for the score board
+ (UIColor *)scoreBoardTextColor;

// Color for the player cell. (Alternates with the complimentary foreground color)
+ (UIColor *)primaryScoreBoardForegroundColor;

// Color for the player cell. (Alternates with the primary foreground color)
+ (UIColor *)complimentaryScoreBoardForegroundColor;

// Text color for the score board when a score has been closed
+ (UIColor *)scoreBoardClosedColor;

// Color for the winning player when the game ends
+ (UIColor *)scoreBoardWinningPlayerColor;

// Color Helpers
+ (UIColor *)colorForColorKey:(NSString *)colorKey;
+ (void)saveColor:(UIColor *)color forKey:(NSString *)colorKey;
+ (UIColor *)colorForColorString:(NSString *)colorString;
+ (NSString *)colorStringForColor:(UIColor *)color;

+ (NSString *)keyForAppColor:(enum DSAppColor)appColor;
@end
