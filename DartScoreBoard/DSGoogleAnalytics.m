//
//  DSGoogleAnalytics.m
//  DartScoreBoard
//
//  Created by Zhe Jia on 8/30/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import "DSGoogleAnalytics.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAITracker.h"
#import "GAIFields.h"
#import "DSGAConstants.h"


@implementation DSGoogleAnalytics

+ (void)initializeGoogleAnalytics
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54320515-1"];
}

+ (id<GAITracker>) GAITracker
{
    static id<GAITracker> GAITracker = nil;
    
    if (GAITracker == nil)
    {
        [DSGoogleAnalytics initializeGoogleAnalytics];
        GAITracker = [GAI sharedInstance].defaultTracker;
    }
    return GAITracker;
}

+ (void)trackPage:(NSString *)pageName withDictionary:(NSDictionary *)dictionary
{
    if (pageName) {
        [[self GAITracker] set:kGAIScreenName value:pageName];
        [[self GAITracker] send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

+ (void)trackEventWithCategory:(NSString *)eventCategory label:(NSString *)eventLabel action:(NSString *)eventAction value:(NSNumber *)eventValue dicitonary:(NSDictionary *)dictionary
{
    
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:eventCategory?eventCategory:kDSGAEventNilCategory
                                                                           action:eventAction?eventAction:kDSGAEventLabelNil
                                                                            label:eventLabel
                                                                            value:eventValue];
    [[self GAITracker] send:[builder build]];
}

@end
