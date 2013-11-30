//
//  DSAddNewPlayerViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 11/29/13.
//  Copyright (c) 2013 Zheike. All rights reserved.
//

#import "DSAddNewPlayerViewController.h"

@interface DSAddNewPlayerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addNewPlayerNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addNewPlayerButton;


- (IBAction)addNewPlayerPressed:(id)sender;
@end

@implementation DSAddNewPlayerViewController

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
	// Do any additional setup after loading the view.
    [self.addNewPlayerNameTextField setHidden:YES];
    self.addNewPlayerNameTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addNewPlayerPressed:(id)sender
{
    [self.addNewPlayerNameTextField setHidden:NO];
    [self.addNewPlayerNameTextField becomeFirstResponder];
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.addNewPlayerButton.titleLabel.text = [NSString string];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length) {
        self.playerNameLabel.text = textField.text;
        self.addNewPlayerButton.backgroundColor = [UIColor greenColor];
        self.addNewPlayerButton.titleLabel.text = [NSString string];
        
        [self.delegate newPlayerAddedWithName:textField.text];
    } else {
        [self.delegate newPlayerRemoved];
        self.addNewPlayerButton.backgroundColor = [UIColor blueColor];
        self.playerNameLabel.text = [NSString string];
    }
    
    
    [self.addNewPlayerNameTextField setHidden:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
