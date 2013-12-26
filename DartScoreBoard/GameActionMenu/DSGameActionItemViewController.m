//
//  DSGameActionItemViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 12/5/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSGameActionItemViewController.h"

@interface DSGameActionItemViewController () <DSGameActionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) UIPopoverController *menuPopover;
@property (strong, nonatomic) DSGameActionTableViewController *menuPopoverContentController;

- (IBAction)menuButtonTapped:(id)sender;

@end

@implementation DSGameActionItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set interface colors
    [self.menuButton setTitleColor:[DSAppSkinner scoreBoardTextColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuButtonTapped:(id)sender
{
    if (!self.menuPopover.popoverVisible) {
        [self.menuPopover presentPopoverFromRect:self.menuButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else {
        [self.menuPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - DSGameActionDelegate
- (void)didSelectGameAction:(enum DSGameAction)gameAction
{
    [self.menuPopover dismissPopoverAnimated:YES];
    
    if ([self.gameActionDelegate respondsToSelector:@selector(didSelectGameAction:)]) {
        [self.gameActionDelegate didSelectGameAction:gameAction];
    }
}

#pragma mark - Getters
- (UIPopoverController *)menuPopover
{
    if (!_menuPopover) {
        _menuPopover = [[UIPopoverController alloc] initWithContentViewController:self.menuPopoverContentController];
    }
    return _menuPopover;
}

- (DSGameActionTableViewController *)menuPopoverContentController
{
    if (!_menuPopoverContentController) {
        _menuPopoverContentController = [[DSGameActionTableViewController alloc] initWithNibName:@"DSGameActionTableViewController" bundle:nil];
        [_menuPopoverContentController setGameActionDelegate:self];
    }
    return _menuPopoverContentController;
}

@end
