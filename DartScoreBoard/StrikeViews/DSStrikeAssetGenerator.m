//
//  DSStrikeAssetGenerator.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSStrikeAssetGenerator.h"

enum DSStrikeState {
    DSStrikeStateOpen,
    DSStrikeStateClosed
};

@interface DSStrikeAssetGenerator ()
@property enum DSStrikeState strikeState;

@end

@implementation DSStrikeAssetGenerator

+ (DSStrikeAssetGenerator *)sharedAssetGenerator
{
    static DSStrikeAssetGenerator *sharedAssetGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAssetGenerator = [[self alloc] init];
    });
    return sharedAssetGenerator;
}

+ (UIImage *)imageForOpenStrike:(enum DSStrike)strike InFrame:(CGRect)frame
{
    [[DSStrikeAssetGenerator sharedAssetGenerator] setStrikeState:DSStrikeStateOpen];
    return [[DSStrikeAssetGenerator sharedAssetGenerator] imageForStrike:strike inFrame:frame];
}

+ (UIImage *)imageForClosedStrike:(enum DSStrike)strike InFrame:(CGRect)frame
{
    [[DSStrikeAssetGenerator sharedAssetGenerator] setStrikeState:DSStrikeStateClosed];
    return [[DSStrikeAssetGenerator sharedAssetGenerator] imageForStrike:strike inFrame:frame];

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

#pragma mark - Strike Draw Methods
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

@end
