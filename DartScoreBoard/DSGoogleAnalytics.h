//
//  DSGoogleAnalytics.h
//  DartScoreBoard
//
//  Created by Zhe Jia on 8/30/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSGoogleAnalytics : NSObject

/* 
 * Used for tracking Screens
 * param pageName       Name of the screen being tracked
 * param dictionary     Dictionary of possible custom dimensions
 */
+ (void)trackPage:(NSString *)pageName withDictionary:(NSDictionary *)dictionary;


@end
