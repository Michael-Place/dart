//
//  DSAppSkinner.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSAppSkinner.h"

@implementation DSAppSkinner
NSString *const GlobalBackgroundColorKey = @"GlobalBackgroundColorKey";
NSString *const NewGameForegroundColorKey = @"NewGameForegroundColorKey";
NSString *const NewGameFontColorKey = @"NewGameFontColorKey";
NSString *const ScoreBoardTextColorKey = @"ScoreBoardTextColorKey";
NSString *const PrimaryScoreBoardForegroundColorKey = @"PrimaryScoreBoardForegroundColorKey";
NSString *const ComplimentaryScoreBoardForegroundColorKey = @"ComplimentaryScoreBoardForegroundColorKey";
NSString *const ScoreBoardClosedColorKey = @"ScoreBoardClosedColorKey";
NSString *const ScoreBoardWinningPlayerColorKey = @"ScoreBoardWinningPlayerColorKey";

+ (void)initializeColorsIfNecessary
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GlobalBackgroundColorKey] == nil) {
        [self saveColor:[UIColor blackColor] forKey:GlobalBackgroundColorKey];
        [self saveColor:[UIColor whiteColor] forKey:NewGameForegroundColorKey];
        [self saveColor:[UIColor blackColor] forKey:NewGameFontColorKey];
        [self saveColor:[UIColor whiteColor] forKey:ScoreBoardTextColorKey];
        [self saveColor:[UIColor clearColor] forKey:PrimaryScoreBoardForegroundColorKey];
        [self saveColor:[UIColor clearColor] forKey:ComplimentaryScoreBoardForegroundColorKey];
        [self saveColor:[UIColor grayColor] forKey:ScoreBoardClosedColorKey];
        [self saveColor:[UIColor blueColor] forKey:ScoreBoardWinningPlayerColorKey];
    }
}

// Global

+ (UIColor *)globalBackgroundColor
{
    return [self colorForColorKey:GlobalBackgroundColorKey];
}

// New Game View

+ (UIColor *)newGameForegroundColor
{
    return [self colorForColorKey:NewGameForegroundColorKey];
}

+ (UIColor *)newGameFontColor
{
    return [self colorForColorKey:NewGameFontColorKey];
}

// Score Board View

+ (UIColor *)primaryScoreBoardForegroundColor
{
    return [self colorForColorKey:PrimaryScoreBoardForegroundColorKey];
}

+ (UIColor *)complimentaryScoreBoardForegroundColor
{
    return [self colorForColorKey:ComplimentaryScoreBoardForegroundColorKey];
}

+ (UIColor *)scoreBoardTextColor
{
    return [self colorForColorKey:ScoreBoardTextColorKey];
}

+ (UIColor *)scoreBoardClosedColor
{
    return [self colorForColorKey:ScoreBoardClosedColorKey];
}

+ (UIColor *)scoreBoardWinningPlayerColor
{
    return [self colorForColorKey:ScoreBoardWinningPlayerColorKey];
}

#pragma mark - User Default Handling
// Retrieves a color from NSUserDefualts given a key
+ (UIColor *)colorForColorKey:(NSString *)colorKey
{
    NSData *savedColorData = [[NSUserDefaults standardUserDefaults]
                                  dataForKey:colorKey];
    UIColor *savedColor = [NSKeyedUnarchiver unarchiveObjectWithData:savedColorData];
    
    return savedColor;
}

// Saves a color to NSUserDefualts given color and a key
+ (void)saveColor:(UIColor *)color forKey:(NSString *)colorKey
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];

    [[NSUserDefaults standardUserDefaults]
     setObject:colorData forKey:colorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)keyForAppColor:(enum DSAppColor)appColor
{
    NSString *appColorKey;
    
    switch (appColor) {
        case DSAppColorGlobalBackgroundColor:
            appColorKey = GlobalBackgroundColorKey;
            break;
        case DSAppColorNewGameForegroundColor:
            appColorKey = NewGameForegroundColorKey;
            break;
        case DSAppColorNewGameFontColor:
            appColorKey = NewGameFontColorKey;
            break;
        case DSAppColorScoreBoardTextColor:
            appColorKey = ScoreBoardTextColorKey;
            break;
        case DSAppColorPrimaryScoreBoardForegroundColor:
            appColorKey = PrimaryScoreBoardForegroundColorKey;
            break;
        case DSAppColorComplimentaryScoreBoardForegroundColor:
            appColorKey = ComplimentaryScoreBoardForegroundColorKey;
            break;
        case DSAppColorScoreBoardClosedColor:
            appColorKey = ScoreBoardClosedColorKey;
            break;
        case DSAppColorScoreBoardWinningPlayerColor:
            appColorKey = ScoreBoardWinningPlayerColorKey;
            break;
            
        default:
            break;
    }
    
    return appColorKey;
}

@end
