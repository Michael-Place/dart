//
//  DSScoreCollectionViewCell.m
//  DartScoreBoard
//
//  Created by Zhe Jia on 12/1/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSScoreCollectionViewCell.h"
#import "DSGame.h"

@interface DSScoreCollectionViewCell() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *scoreTableView;
@property (nonatomic, strong)NSArray *scoreList;

@end

@implementation DSScoreCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpScoreValue
{
    NSLog(@"setting up table?");
    self.scoreTableView.delegate = self;
    self.scoreTableView.dataSource = self;
    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.scoreList[indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoreList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
