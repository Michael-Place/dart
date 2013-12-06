//
//  DSNewPlayerCollectionViewCell.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/1/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSNewPlayerCollectionViewCell.h"

@implementation DSNewPlayerCollectionViewCell

- (void)awakeFromNib
{
    [self.playerNameTextField setDelegate:self];
}

- (IBAction)deletePlayerButtonTapped:(id)sender
{
    [self.cellDelegate deletedPlayerForCell:self];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.cellDelegate didFinishEditingForCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

@end
