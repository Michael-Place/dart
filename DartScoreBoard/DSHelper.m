//
//  DSHelper.m
//  DartScoreBoard
//
//  Created by Zhe Jia on 1/1/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import "DSHelper.h"


NSString *kSavedAppVersionKey = @"savedAppVersionKey";
NSString *kDidRequestRatingForVersionKey = @"didRequestRatingForVersionKey";
NSString *kFirstGameForVersionDateKey = @"versionInstallDateKey";
const int kTimeIntervalForRequestRating = 10;//2592000; //60*60*24*30 30 Days


@interface DSHelper() <UIAlertViewDelegate>

@end


@implementation DSHelper


+ (BOOL)shouldRequestRating
{
    BOOL shouldRequetRating = NO;
    NSString *savedAppVersion = [[NSUserDefaults standardUserDefaults]objectForKey:kSavedAppVersionKey];
    NSString *bundleAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (!savedAppVersion || [savedAppVersion compare:bundleAppVersion options:NSNumericSearch] == NSOrderedAscending) {
        //Just updated
        [[NSUserDefaults standardUserDefaults] setObject:bundleAppVersion forKey:kSavedAppVersionKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kDidRequestRatingForVersionKey];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kFirstGameForVersionDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([savedAppVersion compare:bundleAppVersion options:NSNumericSearch] == NSOrderedSame) {
        BOOL didRequestRatingForVersion = [[NSUserDefaults standardUserDefaults]boolForKey:kDidRequestRatingForVersionKey];
        if (!didRequestRatingForVersion && [DSHelper isTimeToRequestRating]) {
            shouldRequetRating = YES;
        }
    }
    
    return shouldRequetRating;
}

+ (BOOL)isTimeToRequestRating
{
    BOOL isTimeToRequestRating = NO;
    NSDate *now = [NSDate date];
    NSDate *versionInstallDate = [[NSUserDefaults standardUserDefaults]objectForKey:kFirstGameForVersionDateKey];
    if (!versionInstallDate) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kFirstGameForVersionDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        if ([now timeIntervalSinceDate:versionInstallDate] > kTimeIntervalForRequestRating) {
            isTimeToRequestRating = YES;
        }
    }
    
    return isTimeToRequestRating;
}

@end
