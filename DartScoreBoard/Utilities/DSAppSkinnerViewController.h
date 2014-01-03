//
//  DSAppSkinnerViewController.h
//  DartScoreBoard
//
//  Created by Michael Place on 1/2/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSAppSkinnerDelegate <NSObject>

- (void)didFinishWithSettings;

@end

@interface DSAppSkinnerViewController : UIViewController
@property (nonatomic, weak) id <DSAppSkinnerDelegate> settingsDelegate;
@end
