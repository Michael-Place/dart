//
//  DSAppSkinner.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSAppSkinner.h"

@implementation DSAppSkinner
NSString *const AppThemeKey = @"AppThemeKey";
NSString *const OddPlayerScoreBoardColorKey = @"OddPlayerScoreBoardColorKey";
NSString *const EvenPlayerScoreBoardColorKey = @"EvenPlayerScoreBoardColorKey";
NSString *const ScoreBoardDividerColorKey = @"ScoreBoardDividerColorKey";
NSString *const ScoreBoardClosedColorKey = @"ScoreBoardClosedColorKey";
NSString *const ScoreBoardTextColorKey = @"ScoreBoardTextColorKey";
NSString *const ScoreBoardWinningPlayerColorKey = @"ScoreBoardWinningPlayerColorKey";

+ (void)initializeColorsIfNecessaryOverride:(BOOL)override
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:OddPlayerScoreBoardColorKey] == nil || override) {
        [self setAppTheme:DSThemeNightMode];
        
        [self saveColor:[UIColor blackColor] forKey:ScoreBoardDividerColorKey];
        [self saveColor:[UIColor whiteColor] forKey:ScoreBoardTextColorKey];
        [self saveColor:[UIColor blackColor] forKey:OddPlayerScoreBoardColorKey];
        [self saveColor:[UIColor blackColor] forKey:EvenPlayerScoreBoardColorKey];
        [self saveColor:[UIColor grayColor] forKey:ScoreBoardClosedColorKey];
        [self saveColor:[UIColor blueColor] forKey:ScoreBoardWinningPlayerColorKey];
    }
}

// Global

+ (UIColor *)globalBackgroundColor
{
    UIColor *backgroundColor;
    switch ([self appTheme]) {
        case DSThemeNightMode: {
            backgroundColor = [UIColor blackColor];
        }
            break;
        case DSThemeDayMode: {
            backgroundColor = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
    return backgroundColor;
}

+ (UIColor *)globalTextColor
{
    UIColor *globalTextColor;
    switch ([self appTheme]) {
        case DSThemeNightMode: {
            globalTextColor = [UIColor whiteColor];
        }
            break;
        case DSThemeDayMode: {
            globalTextColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    return globalTextColor;
}

// Score Board View

+ (UIColor *)oddPlayerScoreboardColor
{
    return [self colorForColorKey:OddPlayerScoreBoardColorKey];
}

+ (UIColor *)evenPlayerScoreBoardColor
{
    return [self colorForColorKey:EvenPlayerScoreBoardColorKey];
}

+ (UIColor *)scoreBoardDividerColor
{
    return [self colorForColorKey:ScoreBoardDividerColorKey];
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
// Retrieves the app theme from user defaults
+ (enum DSTheme)appTheme
{
    enum DSTheme appTheme = [[NSUserDefaults standardUserDefaults] integerForKey:AppThemeKey];
    return appTheme;
}

// Updates the app theme value in user defaults
+ (void)setAppTheme:(enum DSTheme)theme
{
    [[NSUserDefaults standardUserDefaults] setInteger:theme forKey:AppThemeKey];
    [self resolveColorConflictsIfNecessary];
}

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
        case DSAppColorScoreBoardTextColor:
            appColorKey = ScoreBoardTextColorKey;
            break;
        case DSAppColorOddPlayerScoreBoardColor:
            appColorKey = OddPlayerScoreBoardColorKey;
            break;
        case DSAppColorEvenPlayerScoreBoardColor:
            appColorKey = EvenPlayerScoreBoardColorKey;
            break;
        case DSAppColorScoreBoardClosedColor:
            appColorKey = ScoreBoardClosedColorKey;
            break;
        case DSAppColorScoreBoardWinningPlayerColor:
            appColorKey = ScoreBoardWinningPlayerColorKey;
            break;
        case DSAppColorScoreBoardDividerColor:
            appColorKey = ScoreBoardDividerColorKey;
            break;
        default:
            break;
    }
    
    return appColorKey;
}

+ (void)resolveColorConflictsIfNecessary
{
    enum DSTheme appTheme = [self appTheme];
    switch (appTheme) {
        case DSThemeNightMode: {
            // If the theme is changed to night theme and the score board player colors are white then the scores will be invisible. Need to set the player colors to black so that the white text shows up.
            if ([[self colorForColorKey:OddPlayerScoreBoardColorKey] isEqual:[UIColor whiteColor]]) {
                [self saveColor:[UIColor blackColor] forKey:OddPlayerScoreBoardColorKey];
            }
            if ([[self colorForColorKey:EvenPlayerScoreBoardColorKey] isEqual:[UIColor whiteColor]]) {
                [self saveColor:[UIColor blackColor] forKey:EvenPlayerScoreBoardColorKey];
            }
            if ([[self colorForColorKey:ScoreBoardDividerColorKey] isEqual:[UIColor whiteColor]]) {
                [self saveColor:[UIColor blackColor] forKey:ScoreBoardDividerColorKey];
            }
        }
            break;
        case DSThemeDayMode: {
            // If the theme is changed to day theme and the score board player colors are black then the scores will be invisible. Need to set the player colors to white so that the black text shows up.
            if ([[self colorForColorKey:OddPlayerScoreBoardColorKey] isEqual:[UIColor blackColor]]) {
                [self saveColor:[UIColor whiteColor] forKey:OddPlayerScoreBoardColorKey];
            }
            if ([[self colorForColorKey:EvenPlayerScoreBoardColorKey] isEqual:[UIColor blackColor]]) {
                [self saveColor:[UIColor whiteColor] forKey:EvenPlayerScoreBoardColorKey];
            }
            if ([[self colorForColorKey:ScoreBoardDividerColorKey] isEqual:[UIColor blackColor]]) {
                [self saveColor:[UIColor whiteColor] forKey:ScoreBoardDividerColorKey];
            }
        }
            break;
        default:
            break;
    }
}

@end
