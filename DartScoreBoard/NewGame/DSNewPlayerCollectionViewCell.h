//
//  DSNewPlayerCollectionViewCell.h
//  DartScoreBoard
//
//  Created by Michael Place on 12/1/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSNewPlayerCollectionViewCell;

@protocol NewPlayerCellDelegate <NSObject>

- (void)deletedPlayerForCell:(DSNewPlayerCollectionViewCell *)cell;
- (void)didFinishEditingForCell:(DSNewPlayerCollectionViewCell *)cell;

@end

@interface DSNewPlayerCollectionViewCell : UICollectionViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *playerNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deletePlayerButton;

- (IBAction)deletePlayerButtonTapped:(id)sender;

@property (nonatomic, weak) id <NewPlayerCellDelegate> cellDelegate;

@end
