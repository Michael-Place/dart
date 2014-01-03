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
    
    [self.view setBackgroundColor:[DSAppSkinner globalBackgroundColor]];
    [self.settingsTitleLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.selectedColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.colorSettingsTitleLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.backgroundColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.textColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.foregroundColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.foregroundColorTwoLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.scoreOpenColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    [self.scoreClosureColorLabel setTextColor:[DSAppSkinner newGameFontColor]];
    
    [self.doneButton setTitleColor:[DSAppSkinner newGameFontColor] forState:UIControlStateNormal];
//    [self.doneButton setBackgroundColor:[DSAppSkinner newGameForegroundColor]];
    
    // Set the initial selected color
    [self.selectedColorLabel setText:self.textColorLabel.text];
    [self setCurrentlySelectedColorButton:self.textColorButton];
    [self setupColorPicker];
}

- (void)setupColorPicker
{
    [self.colorPickerView addSubview:self.colorPickerNavigationController.view];
}

- (IBAction)backgroundColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.backgroundColorLabel.text];
    [self setCurrentlySelectedColorButton:self.backgroundColorButton];
}

- (IBAction)textColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.textColorLabel.text];
    [self setCurrentlySelectedColorButton:self.textColorButton];
}

- (IBAction)foregroundColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.foregroundColorLabel.text];
    [self setCurrentlySelectedColorButton:self.foregroundColorButton];
}

- (IBAction)foregroundColorTwoButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.foregroundColorTwoLabel.text];
    [self setCurrentlySelectedColorButton:self.foregroundColorTwoButton];
}

- (IBAction)scoreOpenColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreOpenColorLabel.text];
    [self setCurrentlySelectedColorButton:self.scoreOpenColorButton];
}

- (IBAction)scoreClosedColorButtonTapped:(id)sender
{
    [self.selectedColorLabel setText:self.scoreClosureColorLabel.text];
    [self setCurrentlySelectedColorButton:self.scoreClosedColorButton];
}

- (IBAction)doneButtonTapped:(id)sender
{
    if (self.settingsDelegate && [self.settingsDelegate respondsToSelector:@selector(didFinishWithSettings)]) {
        [self.settingsDelegate didFinishWithSettings];
    }
}

#pragma mark - User Default Handling
// Retrieves a color from NSUserDefualts given a key
- (UIColor *)colorForColorKey:(NSString *)colorKey
{
    NSString *savedColorString = [[NSUserDefaults standardUserDefaults]
                            stringForKey:colorKey];
    UIColor *savedColor = [self colorForColorString:savedColorString];
    
    return savedColor;
}

// Saves a color to NSUserDefualts given color and a key
- (void)saveColor:(UIColor *)color forKey:(NSString *)colorKey
{
    NSString *colorToSave = [self colorStringForColor:color];
    [[NSUserDefaults standardUserDefaults]
     setObject:colorToSave forKey:colorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers
// Returns a UIColor based on the its NSString representation
- (UIColor *)colorForColorString:(NSString *)colorString
{
    NSArray *components = [colorString componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    return color;
}

// Returns an NSString representation for a given UIColor
- (NSString *)colorStringForColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    return colorAsString;
}

#pragma mark - NEOColorPicker Delegate
- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didChangeColor:(UIColor *)color
{
    [self.currentlySelectedColorButton setBackgroundColor:color];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color
{
    
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller
{
    
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
