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

@interface DSAssetGenerator : NSObject

// Score Board View
+ (UIImage *)imageForOpenStrike:(enum DSStrike)strike InFrame:(CGRect)frame;
+ (UIImage *)imageForClosedStrike:(enum DSStrike)strike InFrame:(CGRect)frame;

// New Player View
+ (UIImage *)imageForNewPlayerDeletionButtonForFrame:(CGRect)frame;

@end
