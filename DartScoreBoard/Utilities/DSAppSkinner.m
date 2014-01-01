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
    return [UIColor colorForHex:@"F36C25"];
}

+ (UIColor *)newGameFontColor
{
    return [UIColor colorForHex:@"E42427"];
}

// Score Board View

+ (UIColor *)primaryScoreBoardForegroundColor
{
    return [UIColor colorForHex:@"E42427"];
}

+ (UIColor *)complimentaryScoreBoardForegroundColor
{
    return [UIColor colorForHex:@"F36C25"];
}

+ (UIColor *)scoreBoardTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)scoreBoardClosedColor
{
    return [UIColor colorForHex:@"8AD4E8"];
}

+ (UIColor *)scoreBoardWinningPlayerColor
{
    return [UIColor blueColor];
}

@end
