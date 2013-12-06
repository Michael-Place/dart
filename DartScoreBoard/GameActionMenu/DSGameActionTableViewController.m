//
//  DSGameActionTableViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/5/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSGameActionTableViewController.h"

@interface DSGameActionTableViewController ()
@property (nonatomic, strong) NSDictionary *gameActionOptions;
@end

@implementation DSGameActionTableViewController
static NSString *const ResetGameActionString = @"Reset Game";
static NSString *const NewGameWithSamePlayersActionString = @"Start New Game";
static NSString *const NavigateBackToNewGameViewActionString = @"Back to Menu";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)preferredContentSize {
    // Currently no way to obtain the width dynamically before viewWillAppear.
    CGFloat width = 200.0;
    CGRect rect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
    CGFloat height = CGRectGetMaxY(rect);
    return (CGSize){width, height};
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gameActionOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    // Retrieve values
    NSArray *keys = [self.gameActionOptions allKeys];
    NSString *titleForCell = [keys objectAtIndex:indexPath.row];
    
    // Set up cell
    [cell setTag:[[self.gameActionOptions objectForKey:titleForCell] integerValue]];
    [cell.textLabel setText:titleForCell];
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    enum DSGameAction selectedAction = indexPath.row;
    
    if ([self.gameActionDelegate respondsToSelector:@selector(didSelectGameAction:)]) {
        [self.gameActionDelegate didSelectGameAction:selectedAction];
    }
}

#pragma mark - Getters
- (NSDictionary *)gameActionOptions
{
    if (!_gameActionOptions) {
        // Order here dictates order in the user interface
        _gameActionOptions = @{ResetGameActionString : [NSNumber numberWithInt:DSGameActionResetGame],
                               NewGameWithSamePlayersActionString : [NSNumber numberWithInt:DSGameActionResetGame],
                               NavigateBackToNewGameViewActionString : [NSNumber numberWithInt:DSGameActionResetGame]};
    }
    
    return _gameActionOptions;
}

@end
