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

@property (weak, nonatomic) IBOutlet UILabel *decrementScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *incrementScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *incrementScoreImageView;

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
    if (self.score == 0) {
        self.incrementScoreLabel.text = @"+";
        self.decrementScoreLabel.text = @"-";
        [self.incrementScoreImageView setImage:nil]; ;
    } else if (self.score < 4) {
        UIImage *strikeImage;
        switch (self.score) {
            case 1: {
                strikeImage = [UIImage imageNamed:@"one-strike"];
                break;
            }
            case 2: {
                strikeImage = [UIImage imageNamed:@"two-strike"];
                break;
            }
            case 3: {
                strikeImage = [UIImage imageNamed:@"three-strike"];
                break;
            }
            default:
                break;
        }
        [self.incrementScoreImageView setImage:strikeImage]; ;
        self.decrementScoreLabel.text = @"-";
    } else {
        UIImage *strikeImage = [UIImage imageNamed:@"three-strike"];
        [self.incrementScoreImageView setImage:strikeImage];
        self.decrementScoreLabel.text = [NSString stringWithFormat:@"%i",self.score];
    }
    
    [self shouldCloseScoreOrEndGame];
    [self setNeedsDisplay];
}

- (void)shouldCloseScoreOrEndGame
{
    NSNumber *shouldCloseObject = [[DSGame sharedGame].gameStatusPointValueDictionary objectForKey:[DSGame keyStringForCricketScoreValue:self.scoreValue]];
    BOOL shouldClose = shouldCloseObject.boolValue;
    
    if (shouldClose || ([[DSGame sharedGame] winner] && [[DSGame sharedGame] winner].length)) {
        [self.incrementScoreValueButton setUserInteractionEnabled:NO];
        UIColor *colorForText = [UIColor grayColor];
        self.incrementScoreLabel.textColor = colorForText;
        self.decrementScoreLabel.textColor = colorForText;
        
        
        UIImage *strikeImage;
        switch (self.score) {
            case 0: {
                strikeImage = [UIImage imageNamed:@""];
                break;
            }
            case 1: {
                strikeImage = [UIImage imageNamed:@"one-strike-closed"];
                break;
            }
            case 2: {
                strikeImage = [UIImage imageNamed:@"two-strike-closed"];
                break;
            }
            case 3: {
                strikeImage = [UIImage imageNamed:@"three-strike-closed"];
                break;
            }
            default:
                // This catches the case where the 3 strikes have been exceeded
                strikeImage = [UIImage imageNamed:@"three-strike-closed"];
                break;
        }
        
        [self.incrementScoreImageView setImage:strikeImage];
    } else {
        [self.incrementScoreValueButton setUserInteractionEnabled:YES];
        UIColor *scoreBackgroundColor = [UIColor whiteColor];
        self.incrementScoreLabel.textColor = scoreBackgroundColor;
        self.decrementScoreLabel.textColor = scoreBackgroundColor;
    }
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
