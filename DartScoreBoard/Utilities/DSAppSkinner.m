//
//  DSAppSkinner.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSAppSkinner.h"

@implementation DSAppSkinner

// Global

+ (UIColor *)globalBackgroundColor
{
    return [UIColor blackColor];
}

// New Game View

+ (UIColor *)newGameForegroundColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)newGameFontColor
{
    return [UIColor blackColor];
}

// Score Board View

+ (UIColor *)primaryScoreBoardForegroundColor
{
    return [UIColor colorForHex:@"EF4DB6"];
}

+ (UIColor *)complimentaryScoreBoardForegroundColor
{
    return [UIColor colorForHex:@"C643FC"];
}

+ (UIColor *)scoreBoardTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)scoreBoardClosedColor
{
    return [UIColor grayColor];
}

+ (UIColor *)scoreBoardWinningPlayerColor
{
    return [UIColor blueColor];
}

@end
