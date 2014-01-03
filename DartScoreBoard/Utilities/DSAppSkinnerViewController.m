//
//  DSAppSkinnerViewController.m
//  DartScoreBoard
//
//  Created by Michael Place on 1/2/14.
//  Copyright (c) 2014 Zheike. All rights reserved.
//

#import "DSAppSkinnerViewController.h"

@interface DSAppSkinnerViewController ()
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

- (IBAction)backgroundColorButtonTapped:(id)sender;
- (IBAction)textColorButtonTapped:(id)sender;
- (IBAction)foregroundColorButtonTapped:(id)sender;
- (IBAction)foregroundColorTwoButtonTapped:(id)sender;
- (IBAction)scoreOpenColorButtonTapped:(id)sender;
- (IBAction)scoreClosedColorButtonTapped:(id)sender;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundColorButtonTapped:(id)sender {
}

- (IBAction)textColorButtonTapped:(id)sender {
}

- (IBAction)foregroundColorButtonTapped:(id)sender {
}

- (IBAction)foregroundColorTwoButtonTapped:(id)sender {
}

- (IBAction)scoreOpenColorButtonTapped:(id)sender {
}

- (IBAction)scoreClosedColorButtonTapped:(id)sender {
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

@end
