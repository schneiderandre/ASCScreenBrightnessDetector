//
//  ASCSampleViewController.m
//  ASCScreenBrightnessDetectorExample
//
//  Created by André Schneider on 29.01.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "ASCSampleViewController.h"
#import <ASCScreenBrightnessDetector/ASCScreenBrightnessDetector.h>

@interface ASCSampleViewController () <ASCScreenBrightnessDetectorDelegate>
- (void)configureBrightnessLabel;
- (void)configureTitleLabel;
- (void)configureImageView;
- (void)setThemeForBrightnessStyle:(ASCScreenBrightnessStyle)style;
- (NSString *)stringWithBrightness:(CGFloat)brightness;

@property(nonatomic) ASCScreenBrightnessDetector *brightnessDetector;
@property(nonatomic) UILabel *brightnessLabel;
@property(nonatomic) UILabel *titleLabel;
@property(nonatomic) UIImageView *imageView;

@end

@implementation ASCSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.brightnessDetector = [ASCScreenBrightnessDetector new];
    self.brightnessDetector.delegate = self;
    
    [self configureBrightnessLabel];
    [self configureTitleLabel];
    [self configureImageView];
    [self setThemeForBrightnessStyle:self.brightnessDetector.screenBrightnessStyle];
}

#pragma mark - ASCBrightnessDetectorDelegate

- (void)screenBrightnessDidChange:(CGFloat)brightness
{
    self.brightnessLabel.text = [self stringWithBrightness:brightness];
}

- (void)screenBrightnessStyleDidChange:(ASCScreenBrightnessStyle)style
{
    [self setThemeForBrightnessStyle:style];
}

#pragma mark - Class extension methods

- (void)setThemeForBrightnessStyle:(ASCScreenBrightnessStyle)style
{
    UIColor *tintColor = [UIColor whiteColor];
    UIColor *backgroundColor = [UIColor colorWithRed:52/255.f
                                               green:73/255.f
                                                blue:94/255.f
                                               alpha:1.000];
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
    NSString *imageName = @"moon";
    
    if (style == ASCScreenBrightnessStyleLight) {
        tintColor = backgroundColor;
        backgroundColor = [UIColor whiteColor];
        statusBarStyle = UIStatusBarStyleDefault;
        imageName = @"sun";
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
    self.imageView.tintColor = tintColor;
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView.image = image;
    self.titleLabel.textColor = tintColor;
    self.brightnessLabel.textColor = tintColor;
    self.view.backgroundColor = backgroundColor;
}

- (NSString *)stringWithBrightness:(CGFloat)brightness
{
    return [NSString stringWithFormat:@"%f",brightness];
}

- (void)configureBrightnessLabel
{
    self.brightnessLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.brightnessLabel.textAlignment = NSTextAlignmentCenter;
    self.brightnessLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight"
                                                size:50.f];
    self.brightnessLabel.text = [self stringWithBrightness:self.brightnessDetector.screenBrightness];
    [self.brightnessLabel sizeToFit];
    
    CGPoint center = self.view.center;
    center.y += CGRectGetHeight(self.brightnessLabel.frame);
    self.brightnessLabel.center = center;
    
    [self.view addSubview:self.brightnessLabel];
}

- (void)configureTitleLabel
{
    CGFloat height = 20.f;
    CGRect frame = CGRectMake(CGRectGetMinX(self.brightnessLabel.frame),
                             CGRectGetMinY(self.brightnessLabel.frame)-height,
                             CGRectGetWidth(self.brightnessLabel.frame),
                             height);
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.text = @"Brightness";
    [self.view addSubview:self.titleLabel];
}

- (void)configureImageView
{
    CGFloat originX = 90.f;
    CGFloat width = CGRectGetWidth(self.view.frame) - originX * 2;
    CGFloat height = width;
    CGFloat insetBottom = 40.f;
    CGFloat originY = CGRectGetMinY(self.titleLabel.frame) - height - insetBottom;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX,
                                                                   originY,
                                                                   width,
                                                                   height)];
    [self.view addSubview:self.imageView];
}

@end
