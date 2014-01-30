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
- (void)brightnessDidChange:(NSNotification *)notification;
- (void)addObserver;
- (void)removeObserver;
- (ASCScreenBrightnessStyle)currentSceenBrightnessStyle;

@end

@implementation ASCScreenBrightnessDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        _threshold = 0.5f;
        _screenBrightnessStyle = [self currentSceenBrightnessStyle];
        [self addObserver];
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
    if ([self.delegate respondsToSelector:@selector(screenBrightnessDidChange:)]) {
        [self.delegate screenBrightnessDidChange:self.screenBrightness];
    }
    
    if (self.screenBrightnessStyle == [self currentSceenBrightnessStyle]) {
        return;
    }
    
    self.screenBrightnessStyle = [self currentSceenBrightnessStyle];
    
    if ([self.delegate respondsToSelector:@selector(screenBrightnessStyleDidChange:)]) {
        [self.delegate screenBrightnessStyleDidChange:self.screenBrightnessStyle];
    }
}

- (ASCScreenBrightnessStyle)currentSceenBrightnessStyle
{
    if (self.screenBrightness > self.threshold) {
        return ASCScreenBrightnessStyleLight;
    }
    return ASCScreenBrightnessStyleDark;
}

- (void)addObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(brightnessDidChange:)
                   name:UIScreenBrightnessDidChangeNotification
                 object:[UIScreen mainScreen]];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Property Getter

-(CGFloat)screenBrightness {
    return [UIScreen mainScreen].brightness;
}

@end
