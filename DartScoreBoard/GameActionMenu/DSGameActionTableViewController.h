//
//  DSGameActionTableViewController.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/5/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>

enum DSGameAction {
    DSGameActionResetGame = 0,
    DSGameActionStartNewGameWithSamePlayers = 1,
    DSGameActionNavigateBackToNewGameView = 2
    };

@protocol DSGameActionDelegate <NSObject>
- (void)didSelectGameAction:(enum DSGameAction)gameAction;

@end

@interface DSGameActionTableViewController : UITableViewController
@property (nonatomic, weak) id<DSGameActionDelegate> gameActionDelegate;
@end
