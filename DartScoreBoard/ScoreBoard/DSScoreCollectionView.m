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

@property (nonatomic, weak)IBOutlet UITableView *scoreTableView;
@property (nonatomic, strong)NSArray *scoreList;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"staticCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:60]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.scoreList[indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSNumber *shouldCloseObject = [[DSGame sharedGame].gameStatusPointValueDictionary objectForKey:[DSGame keyStringForCricketScoreValue:[DSGame scoreValueForIndex:indexPath.row]]];
    BOOL shouldClose = shouldCloseObject.boolValue;
    
    if (shouldClose) {
        cell.textLabel.textColor = [UIColor grayColor];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scoreList count];
}

@end
