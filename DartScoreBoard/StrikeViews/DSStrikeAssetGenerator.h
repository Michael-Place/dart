//
//  DSStrikeAssetGenerator.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/26/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DSStrike {
    DSStrikeOne,
    DSStrikeTwo,
    DSStrikeThree
    };

@interface DSStrikeAssetGenerator : NSObject
+ (UIImage *)imageForOpenStrike:(enum DSStrike)strike InFrame:(CGRect)frame;
+ (UIImage *)imageForClosedStrike:(enum DSStrike)strike InFrame:(CGRect)frame;

@end
