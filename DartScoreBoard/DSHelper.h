//
//  DSHelper.h
//  DartScoreBoard
//
//  Created by Zhe Jia on 1/1/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kDidRequestRatingForVersionKey;

@interface DSHelper : NSObject

+ (BOOL)shouldRequestRating;

@end

