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
@property (weak, nonatomic) IBOutlet UIView *contentView;


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

- (void)updateScoreValue
{
    self.backgroundColor = [UIColor clearColor];
//    NSLog(@"updating score value");
    if (self.score == 0) {
        self.incrementScoreValueButton.titleLabel.text = @"+";
        self.decrementScoreValueButton.titleLabel.text = @"-";
        NSLog(@"%@ : %i",self.playerName, self.scoreValue);
    } else if (self.score < 4) {
        self.incrementScoreValueButton.titleLabel.text = [NSString stringWithFormat:@"%i", self.score];
        self.decrementScoreValueButton.titleLabel.text = @"-";
    } else {
        self.incrementScoreValueButton.titleLabel.text = [NSString stringWithFormat:@"%i", 3];
        self.decrementScoreValueButton.titleLabel.text = [NSString stringWithFormat:@"%i",self.score];
    }
    [self setNeedsDisplay];
}

- (IBAction)decrementScoreValueButtonTapped:(id)sender
{
    NSLog(@"Decrementing value");
    [[DSGame sharedGame] decrementScoreValue:self.scoreValue forPlayerNamed:self.playerName];
}

- (IBAction)incrementScoreValueButtonTapped:(id)sender
{
    NSLog(@"Incrementing value");
    [[DSGame sharedGame] incrementScoreValue:self.scoreValue forPlayerNamed:self.playerName];
}
@end
