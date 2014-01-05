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
        [self saveColor:[UIColor blueColor] forKey:GlobalBackgroundColorKey];
        [self saveColor:[UIColor greenColor] forKey:NewGameForegroundColorKey];
        [self saveColor:[UIColor purpleColor] forKey:NewGameFontColorKey];
        [self saveColor:[UIColor blueColor] forKey:ScoreBoardTextColorKey];
        [self saveColor:[UIColor yellowColor] forKey:PrimaryScoreBoardForegroundColorKey];
        [self saveColor:[UIColor redColor] forKey:ComplimentaryScoreBoardForegroundColorKey];
        [self saveColor:[UIColor orangeColor] forKey:ScoreBoardClosedColorKey];
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
    NSString *savedColorString = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:colorKey];
    UIColor *savedColor = [self colorForColorString:savedColorString];
    
    return savedColor;
}

// Saves a color to NSUserDefualts given color and a key
+ (void)saveColor:(UIColor *)color forKey:(NSString *)colorKey
{
    NSString *colorToSave = [self colorStringForColor:color];
    [[NSUserDefaults standardUserDefaults]
     setObject:colorToSave forKey:colorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers
// Returns a UIColor based on the its NSString representation
+ (UIColor *)colorForColorString:(NSString *)colorString
{
    NSArray *components = [colorString componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    
    // Prevent invisible UI elements
    if (a == 0) {
        a = 1;
    }
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    return color;
}

// Returns an NSString representation for a given UIColor
+ (NSString *)colorStringForColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    return colorAsString;
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
