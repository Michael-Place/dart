//
//  DSAppSkinnerViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 1/2/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import "DSAppSkinnerViewController.h"
#import "NEOColorPickerViewController.h"

@interface DSAppSkinnerViewController () <NEOColorPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *settingsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorSettingsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *backgroundColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *textColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *foregroundColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *foregroundColorTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreOpenColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreClosureColorLabel;

@property (weak, nonatomic) IBOutlet UIButton *backgroundColorButton;
@property (weak, nonatomic) IBOutlet UIButton *textColorButton;
@property (weak, nonatomic) IBOutlet UIButton *foregroundColorButton;
@property (weak, nonatomic) IBOutlet UIButton *foregroundColorTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreOpenColorButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreClosedColorButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIView *colorPickerView;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;

@property (strong, nonatomic) UINavigationController *colorPickerNavigationController;
@property (strong, nonatomic) NEOColorPickerViewController *colorPickerViewController;
@property (weak, nonatomic) UIButton *currentlySelectedColorButton;

- (IBAction)backgroundColorButtonTapped:(id)sender;
- (IBAction)textColorButtonTapped:(id)sender;
- (IBAction)foregroundColorButtonTapped:(id)sender;
- (IBAction)foregroundColorTwoButtonTapped:(id)sender;
- (IBAction)scoreOpenColorButtonTapped:(id)sender;
- (IBAction)scoreClosedColorButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;

@end

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
    
    [self.view setBackgroundColor:[DSAppSkinner globalBackgroundColor]];
    [self.settingsTitleLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.selectedColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.colorSettingsTitleLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.backgroundColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.textColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.foregroundColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.foregroundColorTwoLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.scoreOpenColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    [self.scoreClosureColorLabel setTextColor:[DSAppSkinner newGameForegroundColor]];
    
    [self.doneButton setTitleColor:[DSAppSkinner newGameForegroundColor] forState:UIControlStateNormal];
    //    [self.doneButton setBackgroundColor:[DSAppSkinner newGameForegroundColor]];
    
    [self.backgroundColorButton setBackgroundColor:[DSAppSkinner colorForColorKey:GlobalBackgroundColorKey]];
    [self.textColorButton setBackgroundColor:[DSAppSkinner colorForColorKey:NewGameFontColorKey]];
    [self.foregroundColorButton setBackgroundColor:[DSAppSkinner colorForColorKey:PrimaryScoreBoardForegroundColorKey]];
    [self.foregroundColorTwoButton setBackgroundColor:[DSAppSkinner colorForColorKey:ComplimentaryScoreBoardForegroundColorKey]];
    [self.scoreOpenColorButton setBackgroundColor:[DSAppSkinner scoreBoardTextColor]];
    [self.scoreClosedColorButton setBackgroundColor:[DSAppSkinner scoreBoardClosedColor]];
    
    // Set the initial selected color
    [self.selectedColorLabel setText:self.textColorLabel.text];
    [self setCurrentlySelectedColorButton:self.textColorButton];
    [self setupColorPicker];
}

- (void)setColorButtonTags
{
    [self.backgroundColorButton setTag:DSAppColorGlobalBackgroundColor];
    [self.textColorButton setTag:DSAppColorNewGameFontColor];
    [self.foregroundColorButton setTag:DSAppColorPrimaryScoreBoardForegroundColor];
    [self.foregroundColorTwoButton setTag:DSAppColorComplimentaryScoreBoardForegroundColor];
    [self.scoreOpenColorButton setTag:DSAppColorScoreBoardTextColor];
    [self.scoreClosedColorButton setTag:DSAppColorScoreBoardClosedColor];
}

- (void)setupColorPicker
{
    [self.colorPickerView addSubview:self.colorPickerNavigationController.view];
    [self.colorPickerViewController setSelectedColor:self.textColorButton.backgroundColor];
}

- (IBAction)backgroundColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.backgroundColorLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)textColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.textColorLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)foregroundColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.foregroundColorLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)foregroundColorTwoButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.foregroundColorTwoLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)scoreOpenColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreOpenColorLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)scoreClosedColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreClosureColorLabel.text];
    [self updateCurrentlySelectedColorButtonTo:sender];
}

- (IBAction)doneButtonTapped:(id)sender
{
    // Save the color of the currently selected color button
    [DSAppSkinner saveColor:self.currentlySelectedColorButton.backgroundColor  forKey:[DSAppSkinner keyForAppColor:self.currentlySelectedColorButton.tag]];
    
    if (self.settingsDelegate && [self.settingsDelegate respondsToSelector:@selector(didFinishWithSettings)]) {
        [self.settingsDelegate didFinishWithSettings];
    }
}

- (void)updateCurrentlySelectedColorButtonTo:(UIButton *)newlySelectedButton
{
    // Save the color of the previously selected button
    [DSAppSkinner saveColor:self.currentlySelectedColorButton.backgroundColor  forKey:[DSAppSkinner keyForAppColor:self.currentlySelectedColorButton.tag]];
    
    // Set the newly selected button
    [self setCurrentlySelectedColorButton:newlySelectedButton];
}

#pragma mark - NEOColorPicker Delegate
- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didChangeColor:(UIColor *)color
{
    [self.currentlySelectedColorButton setBackgroundColor:color];
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
