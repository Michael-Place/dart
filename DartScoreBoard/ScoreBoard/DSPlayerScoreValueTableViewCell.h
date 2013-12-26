//
//  DSPlayerScoreValueTableViewCell.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGame.h"

@interface DSPlayerScoreValueTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, assign) enum CricketScoreValue scoreValue;
@property (nonatomic, assign) int score;

- (void)updateScoreValue;

@end
