//
//  DSPlayerScoreValueTableViewCell.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSPlayerScoreValueTableViewCell.h"

@interface DSPlayerScoreValueTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *decrementScoreValueButton;
@property (weak, nonatomic) IBOutlet UIButton *incrementScoreValueButton;

- (IBAction)decrementScoreValueButtonTapped:(id)sender;
- (IBAction)incrementScoreValueButtonTapped:(id)sender;

@end

@implementation DSPlayerScoreValueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)decrementScoreValueButtonTapped:(id)sender
{
    NSLog(@"Decrementing value");
}

- (IBAction)incrementScoreValueButtonTapped:(id)sender
{
    NSLog(@"Incrementing value");
}
@end
