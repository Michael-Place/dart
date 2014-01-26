//
//  DSAppSkinnerViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 1/2/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import "DSAppSkinnerViewController.h"
#import "NEOColorPickerViewController.h"

@interface DSAppSkinnerViewController () <NEOColorPickerViewControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settingsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorSettingsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oddPlayerColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *evenPlayerColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreOpenColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreClosureColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *appThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreDividerColorLabel;

@property (weak, nonatomic) IBOutlet UISwitch *appThemeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *oddPlayerColorButton;
@property (weak, nonatomic) IBOutlet UIButton *evenPlayerColorButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreOpenColorButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreClosedColorButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreDividerColorButton;

@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;

@property (strong, nonatomic) UINavigationController *colorPickerNavigationController;
@property (strong, nonatomic) NEOColorPickerViewController *colorPickerViewController;
@property (weak, nonatomic) UIButton *currentlySelectedColorButton;

- (IBAction)oddPlayerColorButtonTapped:(id)sender;
- (IBAction)evenPlayerColorButtonTapped:(id)sender;
- (IBAction)scoreOpenColorButtonTapped:(id)sender;
- (IBAction)scoreClosedColorButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)appThemeSwitchValueChanged:(id)sender;
- (IBAction)resetColorDefaultsButtonTapped:(id)sender;
- (IBAction)scoreDividerColorButtonTapped:(id)sender;

@end

enum AlertTag {
    AlertTagRevertToDefaultColors = 100,
    };

@implementation DSAppSkinnerViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setColorButtonTags];
    
    [self initializeInterfaceColors];
    
    // Set the initial selected color
    [self setCurrentlySelectedColorButton:self.oddPlayerColorButton];
    [self.selectedColorLabel setText:self.oddPlayerColorLabel.text];
    [self setupColorPicker];
}

- (void)initializeInterfaceColors
{
    [self.view setBackgroundColor:[DSAppSkinner globalBackgroundColor]];
    [self.settingsTitleLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.selectedColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.colorSettingsTitleLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.oddPlayerColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.evenPlayerColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.scoreOpenColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.scoreClosureColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.scoreDividerColorLabel setTextColor:[DSAppSkinner globalTextColor]];
    [self.appThemeLabel setTextColor:[DSAppSkinner globalTextColor]];
    
    [self.doneButton setTitleColor:[DSAppSkinner globalTextColor] forState:UIControlStateNormal];
    [self.appThemeSwitch setOn:([DSAppSkinner appTheme] == DSThemeNightMode) ? YES : NO];
    
    [self.oddPlayerColorButton setBackgroundColor:[DSAppSkinner colorForColorKey:OddPlayerScoreBoardColorKey]];
    [self.evenPlayerColorButton setBackgroundColor:[DSAppSkinner colorForColorKey:EvenPlayerScoreBoardColorKey]];
    [self.scoreOpenColorButton setBackgroundColor:[DSAppSkinner scoreBoardTextColor]];
    [self.scoreClosedColorButton setBackgroundColor:[DSAppSkinner scoreBoardClosedColor]];
    [self.scoreDividerColorButton setBackgroundColor:[DSAppSkinner scoreBoardDividerColor]];

}

- (void)setColorButtonTags
{
    [self.oddPlayerColorButton setTag:DSAppColorOddPlayerScoreBoardColor];
    [self.evenPlayerColorButton setTag:DSAppColorEvenPlayerScoreBoardColor];
    [self.scoreOpenColorButton setTag:DSAppColorScoreBoardTextColor];
    [self.scoreClosedColorButton setTag:DSAppColorScoreBoardClosedColor];
    [self.scoreDividerColorButton setTag:DSAppColorScoreBoardDividerColor];
}

- (void)setupColorPicker
{
    [self.colorPickerView addSubview:self.colorPickerNavigationController.view];
    [self.colorPickerViewController setSelectedColor:self.oddPlayerColorButton.backgroundColor];
}

- (IBAction)oddPlayerColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.oddPlayerColorLabel.text];
    [self.colorPickerViewController setSelectedColor:self.oddPlayerColorButton.backgroundColor];
    [self.colorPickerViewController updateSelectedColor];
    [self setCurrentlySelectedColorButton:sender];
}

- (IBAction)evenPlayerColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.evenPlayerColorLabel.text];
    [self.colorPickerViewController setSelectedColor:self.evenPlayerColorButton.backgroundColor];
    [self.colorPickerViewController updateSelectedColor];
    [self setCurrentlySelectedColorButton:sender];
}

- (IBAction)scoreDividerColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreDividerColorLabel.text];
    [self.colorPickerViewController setSelectedColor:self.scoreDividerColorButton.backgroundColor];
    [self.colorPickerViewController updateSelectedColor];
    [self setCurrentlySelectedColorButton:sender];
}

- (IBAction)scoreOpenColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreOpenColorLabel.text];
    [self.colorPickerViewController setSelectedColor:self.scoreOpenColorButton.backgroundColor];
    [self.colorPickerViewController updateSelectedColor];
    [self setCurrentlySelectedColorButton:sender];
}

- (IBAction)scoreClosedColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreClosureColorLabel.text];
    [self.colorPickerViewController setSelectedColor:self.scoreClosedColorButton.backgroundColor];
    [self.colorPickerViewController updateSelectedColor];
    [self setCurrentlySelectedColorButton:sender];
}

- (IBAction)doneButtonTapped:(id)sender
{
    if (self.settingsDelegate && [self.settingsDelegate respondsToSelector:@selector(didFinishWithSettings)]) {
        [self.settingsDelegate didFinishWithSettings];
    }
}

- (IBAction)appThemeSwitchValueChanged:(UISwitch *)sender
{
    if (sender.on) {
        [DSAppSkinner setAppTheme:DSThemeNightMode];
    }
    else {
        [DSAppSkinner setAppTheme:DSThemeDayMode];
    }
    [self initializeInterfaceColors];
}

- (IBAction)resetColorDefaultsButtonTapped:(id)sender
{
    UIAlertView *resetColorDefaultsAlert = [[UIAlertView alloc] initWithTitle:@"Revert to Default Colors"
                                                                      message:@"Are you sure you want to revert to the default color scheme?"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                            otherButtonTitles:@"Revert", nil];
    resetColorDefaultsAlert.tag = AlertTagRevertToDefaultColors;
    [resetColorDefaultsAlert show];
}

- (BOOL)checkForColorConflictsForColor:(UIColor *)proposedColor
{
    BOOL safeToUpdateColor = YES;
    UIAlertView *colorConflictAlert = [[UIAlertView alloc] initWithTitle:@"Color Conflict"
                                                                 message:@"The color you have chosen would cause the app's text to be unreadable. Please select another color."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
    
    // If we aren't talking about the score open color, then make sure that the proposed
    // color is not equal to the global text color.
    if (self.currentlySelectedColorButton != self.scoreOpenColorButton) {
        if ([[DSAppSkinner globalTextColor] isEqual:proposedColor]) {
            safeToUpdateColor = NO;
            [colorConflictAlert show];
        }
    }
    
    // If we are trying to set the score open color, make sure that its not equal to the player colors
    if ((self.currentlySelectedColorButton == self.scoreOpenColorButton)) {
        if (([[DSAppSkinner oddPlayerScoreboardColor] isEqual:proposedColor]) || ([[DSAppSkinner evenPlayerScoreBoardColor] isEqual:proposedColor])) {
            safeToUpdateColor = NO;
            [colorConflictAlert show];
        }
    }
    
    // If we are trying to set the score closed color, make sure that its not equal to the player colors
    if ((self.currentlySelectedColorButton == self.scoreClosedColorButton)) {
        if (([[DSAppSkinner oddPlayerScoreboardColor] isEqual:proposedColor]) || ([[DSAppSkinner evenPlayerScoreBoardColor] isEqual:proposedColor])) {
            safeToUpdateColor = NO;
            [colorConflictAlert show];
        }
    }
    
    // If we are trying to set the player colors make sure that its not equal to the score text color
    if ((self.currentlySelectedColorButton == self.oddPlayerColorButton) || (self.currentlySelectedColorButton == self.evenPlayerColorButton)) {
        if ([proposedColor isEqual:[DSAppSkinner scoreBoardTextColor]]) {
            safeToUpdateColor = NO;
            [colorConflictAlert show];
        }
    }
    
    // If we are trying to set the player colors make sure that its not equal to the score closed text color
    if ((self.currentlySelectedColorButton == self.oddPlayerColorButton) || (self.currentlySelectedColorButton == self.evenPlayerColorButton)) {
        if ([proposedColor isEqual:[DSAppSkinner scoreBoardClosedColor]]) {
            safeToUpdateColor = NO;
            [colorConflictAlert show];
        }
    }
    
    return safeToUpdateColor;
}

#pragma mark - NEOColorPicker Delegate
- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didChangeColor:(UIColor *)color
{
    if ([self checkForColorConflictsForColor:color]) {
        [self.currentlySelectedColorButton setBackgroundColor:color];
        
        // Save the color to user defaults
        [DSAppSkinner saveColor:self.currentlySelectedColorButton.backgroundColor  forKey:[DSAppSkinner keyForAppColor:self.currentlySelectedColorButton.tag]];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case AlertTagRevertToDefaultColors: {
            if (buttonIndex != 0) {
                // We are reinitializing the defaults
                [DSAppSkinner initializeColorsIfNecessaryOverride:YES];
                
                // Reinitialize interface colors and settings
                [self initializeInterfaceColors];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Getters
- (UINavigationController *)colorPickerNavigationController
{
    if (!_colorPickerNavigationController) {
        _colorPickerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.colorPickerViewController];
        
        CGRect colorPickerNavFrame = _colorPickerNavigationController.view.frame;
        colorPickerNavFrame.origin.x = 0;
        colorPickerNavFrame.origin.y = 0;
        colorPickerNavFrame.size.width = self.colorPickerView.frame.size.width;
        colorPickerNavFrame.size.height = self.colorPickerView.frame.size.height;

        [self.colorPickerNavigationController.view setFrame:colorPickerNavFrame];
    }
    return _colorPickerNavigationController;
}

 - (NEOColorPickerViewController *)colorPickerViewController
{
    if (!_colorPickerViewController) {
        _colorPickerViewController = [[NEOColorPickerViewController alloc] init];
        [_colorPickerViewController setDelegate:self];
    }
    return _colorPickerViewController;
}

@end
