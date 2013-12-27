//
//  DSAssetGenerator.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSAssetGenerator.h"

enum DSStrikeState {
    DSStrikeStateOpen,
    DSStrikeStateClosed
};

@interface DSAssetGenerator ()
@property enum DSStrikeState strikeState;

@end

@implementation DSAssetGenerator

+ (DSAssetGenerator *)sharedAssetGenerator
{
    static DSAssetGenerator *sharedAssetGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAssetGenerator = [[self alloc] init];
    });
    return sharedAssetGenerator;
}

+ (UIImage *)imageForOpenStrike:(enum DSStrike)strike InFrame:(CGRect)frame
{
    [[DSAssetGenerator sharedAssetGenerator] setStrikeState:DSStrikeStateOpen];
    return [[DSAssetGenerator sharedAssetGenerator] imageForStrike:strike inFrame:frame];
}

+ (UIImage *)imageForClosedStrike:(enum DSStrike)strike InFrame:(CGRect)frame
{
    [[DSAssetGenerator sharedAssetGenerator] setStrikeState:DSStrikeStateClosed];
    return [[DSAssetGenerator sharedAssetGenerator] imageForStrike:strike inFrame:frame];

}

- (UIImage *)imageForStrike:(enum DSStrike)strike inFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    
    switch (strike) {
        case DSStrikeOne: {
            [self drawOneStrike];
            break;
        }
        case DSStrikeTwo: {
            [self drawTwoStrike];
            break;
        }
        case DSStrikeThree: {
            [self drawThreeStrike];
            break;
        }
        default:
            break;
    }
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageForNewPlayerDeletionButtonForFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    [[DSAssetGenerator sharedAssetGenerator] drawDeleteNewPlayer];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageForDartWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0f);
    [[DSAssetGenerator sharedAssetGenerator] drawDart];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark - Strike Draw
- (void)drawOneStrike
{
    //// Color Declarations
    UIColor* strokeColor;
    if (self.strikeState == DSStrikeStateOpen) {
        strokeColor = [DSAppSkinner scoreBoardTextColor];
    }
    else {
        strokeColor = [DSAppSkinner scoreBoardClosedColor];
    }
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
    [bezier10Path moveToPoint: CGPointMake(27.5, 26.5)];
    [bezier10Path addLineToPoint: CGPointMake(74, 73)];
    [strokeColor setStroke];
    bezier10Path.lineWidth = 10;
    [bezier10Path stroke];
    
}

- (void)drawTwoStrike
{
    //// Color Declarations
    UIColor* strokeColor;
    if (self.strikeState == DSStrikeStateOpen) {
        strokeColor = [DSAppSkinner scoreBoardTextColor];
    }
    else {
        strokeColor = [DSAppSkinner scoreBoardClosedColor];
    }
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
    [bezier10Path moveToPoint: CGPointMake(27, 26)];
    [bezier10Path addLineToPoint: CGPointMake(74, 73)];
    [strokeColor setStroke];
    bezier10Path.lineWidth = 10;
    [bezier10Path stroke];
    
    
    //// Bezier 11 Drawing
    UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
    [bezier11Path moveToPoint: CGPointMake(75, 25)];
    [bezier11Path addLineToPoint: CGPointMake(27, 73)];
    [strokeColor setStroke];
    bezier11Path.lineWidth = 10;
    [bezier11Path stroke];
}

- (void)drawThreeStrike
{
    //// Color Declarations
    
    UIColor* strokeColor;
    if (self.strikeState == DSStrikeStateOpen) {
        strokeColor = [DSAppSkinner scoreBoardTextColor];
    }
    else {
        strokeColor = [DSAppSkinner scoreBoardClosedColor];
    }
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(13, 12, 75, 75)];
    [strokeColor setStroke];
    ovalPath.lineWidth = 10;
    [ovalPath stroke];
    
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
    [bezier10Path moveToPoint: CGPointMake(27.5, 26.5)];
    [bezier10Path addLineToPoint: CGPointMake(74, 73)];
    [strokeColor setStroke];
    bezier10Path.lineWidth = 10;
    [bezier10Path stroke];
    
    
    //// Bezier 11 Drawing
    UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
    [bezier11Path moveToPoint: CGPointMake(75, 25)];
    [bezier11Path addLineToPoint: CGPointMake(27, 73)];
    [strokeColor setStroke];
    bezier11Path.lineWidth = 10;
    [bezier11Path stroke];
}

#pragma mark - New Player Deletion Draw
- (void)drawDeleteNewPlayer
{
    //// Color Declarations
    UIColor* strokeColor = [DSAppSkinner newGameForegroundColor];
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(4, 4)];
    [bezier2Path addCurveToPoint: CGPointMake(21, 21) controlPoint1: CGPointMake(20.06, 19.11) controlPoint2: CGPointMake(21, 21)];
    bezier2Path.lineCapStyle = kCGLineCapRound;
    
    [strokeColor setStroke];
    bezier2Path.lineWidth = 6;
    [bezier2Path stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(21, 4)];
    [bezierPath addCurveToPoint: CGPointMake(4, 21) controlPoint1: CGPointMake(4.94, 19.11) controlPoint2: CGPointMake(4, 21)];
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [strokeColor setStroke];
    bezierPath.lineWidth = 6;
    [bezierPath stroke];
}

- (void)drawDart
{
    //// Color Declarations
    UIColor* strokeColor = [UIColor whiteColor];
    
    UIColor *dartGripColor = [DSAppSkinner newGameForegroundColor];
    UIColor *dartFlightColor = [DSAppSkinner primaryScoreBoardForegroundColor];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(144.5, 29.5)];
    [bezierPath addCurveToPoint: CGPointMake(114.5, 29.5) controlPoint1: CGPointMake(119.79, 29.5) controlPoint2: CGPointMake(114.5, 29.5)];
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [strokeColor setStroke];
    bezierPath.lineWidth = 1.5;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(113.5, 29.5)];
    [bezier2Path addCurveToPoint: CGPointMake(79.5, 29.5) controlPoint1: CGPointMake(74.5, 29.5) controlPoint2: CGPointMake(79.5, 29.5)];
    [dartGripColor setStroke];
    bezier2Path.lineWidth = 4.5;
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(79.5, 29.5)];
    [bezier3Path addCurveToPoint: CGPointMake(49.5, 29.5) controlPoint1: CGPointMake(54.79, 29.5) controlPoint2: CGPointMake(49.5, 29.5)];
    bezier3Path.lineCapStyle = kCGLineCapRound;
    
    [strokeColor setStroke];
    bezier3Path.lineWidth = 2;
    [bezier3Path stroke];
    
    
    //// Bezier 4 Drawing
    UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint: CGPointMake(49.5, 29.5)];
    [bezier4Path addCurveToPoint: CGPointMake(5.5, 29.5) controlPoint1: CGPointMake(5.5, 29.5) controlPoint2: CGPointMake(5.5, 29.5)];
    [strokeColor setStroke];
    bezier4Path.lineWidth = 1;
    [bezier4Path stroke];
    
    
    //// Bezier 5 Drawing
    UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
    [strokeColor setStroke];
    bezier5Path.lineWidth = 1;
    [bezier5Path stroke];
    
    
    //// Bezier 6 Drawing
    UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
    [bezier6Path moveToPoint: CGPointMake(49.5, 29.5)];
    [bezier6Path addLineToPoint: CGPointMake(34.5, 14.5)];
    [bezier6Path addLineToPoint: CGPointMake(10.5, 14.5)];
    [bezier6Path addLineToPoint: CGPointMake(1.5, 29.5)];
    [bezier6Path addLineToPoint: CGPointMake(49.5, 29.5)];
    [bezier6Path closePath];
    [dartFlightColor setFill];
    [bezier6Path fill];
    [strokeColor setStroke];
    bezier6Path.lineWidth = 1;
    [bezier6Path stroke];
    
    
    //// Bezier 7 Drawing
    UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
    [bezier7Path moveToPoint: CGPointMake(49.5, 30.5)];
    [bezier7Path addLineToPoint: CGPointMake(38.5, 37.5)];
    [bezier7Path addLineToPoint: CGPointMake(8.5, 37.5)];
    [bezier7Path addLineToPoint: CGPointMake(1.5, 30.5)];
    [bezier7Path addLineToPoint: CGPointMake(49.5, 30.5)];
    [bezier7Path closePath];
    [dartFlightColor setFill];
    [bezier7Path fill];
    [strokeColor setStroke];
    bezier7Path.lineWidth = 1;
    [bezier7Path stroke];
    
    
    //// Bezier 8 Drawing
    UIBezierPath* bezier8Path = [UIBezierPath bezierPath];
    [bezier8Path moveToPoint: CGPointMake(48.5, 30.5)];
    [bezier8Path addLineToPoint: CGPointMake(44.5, 45.5)];
    [bezier8Path addLineToPoint: CGPointMake(16.5, 45.5)];
    [bezier8Path addLineToPoint: CGPointMake(11.5, 37.5)];
    [bezier8Path addLineToPoint: CGPointMake(38.5, 37.5)];
    [bezier8Path addLineToPoint: CGPointMake(48.5, 30.5)];
    [bezier8Path closePath];
    [dartFlightColor setFill];
    [bezier8Path fill];
    [strokeColor setStroke];
    bezier8Path.lineWidth = 1;
    [bezier8Path stroke];
    
    
    //// Bezier 9 Drawing
    UIBezierPath* bezier9Path = [UIBezierPath bezierPath];
    [strokeColor setStroke];
    bezier9Path.lineWidth = 1;
    [bezier9Path stroke];
    
    
    //// Bezier 10 Drawing
    UIBezierPath* bezier10Path = [UIBezierPath bezierPath];
    [bezier10Path moveToPoint: CGPointMake(48.5, 29.5)];
    [bezier10Path addLineToPoint: CGPointMake(48.5, 19.5)];
    [bezier10Path addLineToPoint: CGPointMake(39.5, 19.5)];
    [bezier10Path addLineToPoint: CGPointMake(48.5, 29.5)];
    [bezier10Path closePath];
    [dartFlightColor setFill];
    [bezier10Path fill];
    [strokeColor setStroke];
    bezier10Path.lineWidth = 1;
    [bezier10Path stroke];
    
    
    //// Bezier 11 Drawing
    UIBezierPath* bezier11Path = [UIBezierPath bezierPath];
    [bezier11Path moveToPoint: CGPointMake(144.5, 29.5)];
    [bezier11Path addCurveToPoint: CGPointMake(147.5, 29.5) controlPoint1: CGPointMake(148.5, 29.5) controlPoint2: CGPointMake(147.5, 29.5)];
    [strokeColor setStroke];
    bezier11Path.lineWidth = 1;
    [bezier11Path stroke];
}

@end
