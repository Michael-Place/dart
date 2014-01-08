//
//  DSPlayerScoreValueTableViewCell.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSPlayerScoreValueTableViewCell.h"
#import "DSAssetGenerator.h"

@interface DSPlayerScoreValueTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *decrementScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *incrementScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *decrementScoreValueButton;
@property (weak, nonatomic) IBOutlet UIButton *incrementScoreValueButton;

@property (weak, nonatomic) IBOutlet UIImageView *strikeImageView;

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
        
        [self.strikeImageView setImage:nil];
    }
    else if (self.score < 4) {
        
        switch (self.score) {
            case 0: {
                [self.strikeImageView setImage:nil];
                break;
            }
            case 1: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForOpenStrike:DSStrikeOne InFrame:self.strikeImageView.frame]];
                break;
            }
            case 2: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForOpenStrike:DSStrikeTwo InFrame:self.strikeImageView.frame]];
                break;
            }
            case 3: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForOpenStrike:DSStrikeThree InFrame:self.strikeImageView.frame]];
                break;
            }
            default:
                // This catches the case where the 3 strikes have been exceeded
                [self.strikeImageView setImage:[DSAssetGenerator imageForOpenStrike:DSStrikeThree InFrame:self.strikeImageView.frame]];
                break;
        }
        self.decrementScoreLabel.text = @"-";
    }
    else {
        [self.strikeImageView setImage:[DSAssetGenerator imageForOpenStrike:DSStrikeThree InFrame:self.strikeImageView.frame]];
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
        self.incrementScoreLabel.textColor = [DSAppSkinner scoreBoardClosedColor];
        self.decrementScoreLabel.textColor = [DSAppSkinner scoreBoardClosedColor];
        
        switch (self.score) {
            case 0: {
                [self.strikeImageView setImage:nil];
                break;
            }
            case 1: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForClosedStrike:DSStrikeOne InFrame:self.strikeImageView.frame]];
                break;
            }
            case 2: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForClosedStrike:DSStrikeTwo InFrame:self.strikeImageView.frame]];
                break;
            }
            case 3: {
                [self.strikeImageView setImage:[DSAssetGenerator imageForClosedStrike:DSStrikeThree InFrame:self.strikeImageView.frame]];
                break;
            }
            default:
                // This catches the case where the 3 strikes have been exceeded
                [self.strikeImageView setImage:[DSAssetGenerator imageForClosedStrike:DSStrikeThree InFrame:self.strikeImageView.frame]];
                break;
        }
        
        
    } else {
        [self.incrementScoreValueButton setUserInteractionEnabled:YES];
        self.incrementScoreLabel.textColor = [DSAppSkinner scoreBoardTextColor];
        self.decrementScoreLabel.textColor = [DSAppSkinner scoreBoardTextColor];
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
