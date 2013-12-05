//
//  DSScoreBoardCollectionViewCell.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPlayer.h"

@protocol ScoreBoardCollectionViewCellDelegate <NSObject>

- (CGFloat)parentHeight;
- (CGFloat)parentWidth;

@end

@interface DSScoreBoardCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id <ScoreBoardCollectionViewCellDelegate> cellDelegate;
@property (weak, nonatomic) IBOutlet UITableView *playerScoreTableView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (strong, nonatomic) DSPlayer *player;

@end
