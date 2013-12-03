//
//  DSPlayerScoreValueTableViewCell.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSPlayerScoreValueTableViewCell.h"

const NSString *kStrikeOneSymbol = @"\u29F5";
const NSString *kStrikeTwoSymbol = @"\u2613";
const NSString *kStrikeThreeSymbol = @"\u2297";

@interface DSPlayerScoreValueTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *decrementScoreValueButton;
@property (weak, nonatomic) IBOutlet UIButton *incrementScoreValueButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *decrementScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *incrementScoreLabel;

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
        self.incrementScoreLabel.text = @"+";
        self.decrementScoreLabel.text = @"-";
        NSLog(@"%@ : %i",self.playerName, self.scoreValue);
    } else if (self.score < 4) {
        NSString *myString;
        switch (self.score) {
            case 1: {
                myString = [NSString stringWithFormat:@"%@",kStrikeOneSymbol];
                break;
            }
            case 2: {
                myString = [NSString stringWithFormat:@"%@", kStrikeTwoSymbol];
                break;
            }
            case 3: {
                myString = [NSString stringWithFormat:@"%@", kStrikeThreeSymbol];
                break;
            }
            default:
                break;
        }
        self.incrementScoreLabel.text = myString;
        self.decrementScoreLabel.text = @"-";
    } else {
        NSString *myString = [NSString stringWithFormat:@"%@", kStrikeThreeSymbol];
        self.incrementScoreLabel.text = myString;
        self.decrementScoreLabel.text = [NSString stringWithFormat:@"%i",self.score];
    }
    
    [self shouldCloseScoreOrEndGame];
    [self setNeedsDisplay];
}

- (void)shouldCloseScoreOrEndGame
{
    NSNumber *shouldCloseObject = [[DSGame sharedGame].gameStatusPointValueDictionary objectForKey:[DSGame keyStringForCricketScoreValue:self.scoreValue]];
    BOOL shouldClose = shouldCloseObject.boolValue;
    
    if (shouldClose || ([DSGame sharedGame].winner && [DSGame sharedGame].winner.length)) {
        [self.incrementScoreValueButton setUserInteractionEnabled:NO];
        UIColor *colorForText = [UIColor grayColor];
        if (([DSGame sharedGame].winner && [DSGame sharedGame].winner.length)) {
            colorForText = [UIColor yellowColor];
        }
        self.incrementScoreLabel.textColor = colorForText;
        self.decrementScoreLabel.textColor = colorForText;
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
