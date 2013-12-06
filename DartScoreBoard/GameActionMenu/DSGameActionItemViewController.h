//
//  DSGameActionItemViewController.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/5/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGameActionTableViewController.h"

@interface DSGameActionItemViewController : UIViewController
@property (nonatomic, weak) id <DSGameActionDelegate> gameActionDelegate;
@end
