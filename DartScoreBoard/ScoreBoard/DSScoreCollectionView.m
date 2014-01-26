//
//  DSScoreCollectionView.m
//  DartScoreBoard
//
//  Created by Zhe Jia on 12/1/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSScoreCollectionView.h"
#import "DSScoreBoardCollectionViewController.h"
#import "DSGame.h"

@interface DSScoreCollectionView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *scoreList;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorView;

@end

@implementation DSScoreCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpScoreValue];
}

- (void)setUpScoreValue
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CricketScoreValueList" ofType:@"plist"]];
    self.scoreList = [NSArray arrayWithArray:[dictionary objectForKey:@"CricketDisplayScoreValueStringList"]];
    
    [self.scoreTableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"staticCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self.backgroundColorView setBackgroundColor:[DSAppSkinner scoreBoardDividerColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:60]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.scoreList[indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSNumber *shouldCloseObject = [[DSGame sharedGame].gameStatusPointValueDictionary objectForKey:[DSGame keyStringForCricketScoreValue:[DSGame scoreValueForIndex:(int)indexPath.row]]];
    BOOL shouldClose = shouldCloseObject.boolValue;
    
    if (shouldClose || [[DSGame sharedGame] winner].length) {
        [cell.textLabel setTextColor:[DSAppSkinner scoreBoardClosedColor]];
    } else {
        [cell.textLabel setTextColor:[DSAppSkinner globalTextColor]];
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scoreList count];
}

@end
