//
//  ASCScreenBrightnessDetector.m
//  ASCScreenBrightnessDetector
//
//  Created by André Schneider on 23.01.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "ASCScreenBrightnessDetector.h"

@interface ASCScreenBrightnessDetector()
@property (nonatomic, readwrite) ASCScreenBrightnessStyle screenBrightnessStyle;
@property (nonatomic, readwrite) CGFloat screenBrightness;
@property (nonatomic) UIScreen *screen;
- (void)brightnessDidChange:(NSNotification *)notification;
- (void)addObserverForScreen:(UIScreen *)screen;
- (void)removeObserver;
- (ASCScreenBrightnessStyle)screenBrightnessStyleForBrightness:(CGFloat)brightness;

@end

@implementation ASCScreenBrightnessDetector

- (instancetype)init
{
    return [self initWithScreen:[UIScreen mainScreen]];
}

- (instancetype)initWithScreen:(UIScreen *)screen {
    self = [super init];
    if (self) {
        _threshold = 0.5f;
        _screenBrightnessStyle = [self screenBrightnessStyleForBrightness:screen.brightness];
        _screen = screen;
        [self addObserverForScreen:screen];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Class extension methods

- (void)brightnessDidChange:(NSNotification *)notification
{
    UIScreen *screen = notification.object;
    CGFloat brightness = screen.brightness;
    ASCScreenBrightnessStyle brightnessStyle;
    brightnessStyle = [self screenBrightnessStyleForBrightness:brightness];

    if ([self.delegate respondsToSelector:@selector(screenBrightnessDidChange:)]) {
        [self.delegate screenBrightnessDidChange:brightness];
    }
    
    if (self.screenBrightnessStyle == brightnessStyle) {
        return;
    }
    
    self.screenBrightnessStyle = brightnessStyle;
    
    if ([self.delegate respondsToSelector:@selector(screenBrightnessStyleDidChange:)]) {
        [self.delegate screenBrightnessStyleDidChange:self.screenBrightnessStyle];
    }
}

- (ASCScreenBrightnessStyle)screenBrightnessStyleForBrightness:(CGFloat)brightness
{
    if (brightness > self.threshold) {
        return ASCScreenBrightnessStyleLight;
    }
    return ASCScreenBrightnessStyleDark;
}

- (void)addObserverForScreen:(UIScreen *)screen
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(brightnessDidChange:)
                   name:UIScreenBrightnessDidChangeNotification
                 object:screen];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Property Getter

-(CGFloat)screenBrightness {
    return self.screen.brightness;
}

@end
