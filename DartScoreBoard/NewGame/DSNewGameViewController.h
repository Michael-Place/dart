//
//  DSNewGameViewController.h
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPlayer.h"

@protocol StartingGameDelegate <NSObject>
- (void)startGame;

@end

@interface DSNewGameViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property id <StartingGameDelegate> delegate;

- (void)setInitialPlayers:(NSArray *)players;

@end

