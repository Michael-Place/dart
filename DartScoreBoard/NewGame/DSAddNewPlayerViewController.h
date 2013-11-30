//
//  DSAddNewPlayerViewController.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPlayerAdded <NSObject>

- (void)newPlayerAddedWithName:(NSString *)playerName;
- (void)newPlayerRemoved;

@end

@interface DSAddNewPlayerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) id <NewPlayerAdded> delegate;
@end
