//
//  ASCScreenBrightnessDetector.h
//  ASCScreenBrightnessDetector
//
//  Created by André Schneider on 23.01.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ASCScreenBrightnessStyle) {
    ASCScreenBrightnessStyleLight,
    ASCScreenBrightnessStyleDark
};

@protocol ASCScreenBrightnessDetectorDelegate;

@interface ASCScreenBrightnessDetector : NSObject

/**
 Initializes and returns a newly allocated ASCScreenBrightnessDetector
 object with the specified screen.

 @param screen A screen that gets observed for screen brightness changes.

 @return An initialized object.
 
 @warning In most cases you want to observe the brightness changes of the
          mainscreen, this is the default value if you use the designated
          initializer "[Class new]" or "[[Class alloc] init]". This method has
          been added mainly for testing purposes.
 */
- (instancetype)initWithScreen:(UIScreen *)screen;

/**
 The object that acts as the delegate.
 */
@property (nonatomic, weak) id<ASCScreenBrightnessDetectorDelegate> delegate;

/**
 The Screen that gets observed for screen brightness changes. Per default it
 returns the application mainscreen.
 */
@property (nonatomic, readonly) UIScreen *screen;

/**
 The brightness level of the screen between 0.0 and 1.0, inclusive.
 */
@property (nonatomic, readonly) CGFloat screenBrightness;

/**
 The style indicates if the screen brightness is dark or light and depends on
    the defined threshold.
 */
@property (nonatomic, readonly) ASCScreenBrightnessStyle screenBrightnessStyle;

/**
 The threshold determines whether the brightness style is light or dark.
    It must have a value between 0.0 and 1.0, inclusive.
 
 The default value is 0.5.
 */
@property (nonatomic) CGFloat threshold;

@end

@protocol ASCScreenBrightnessDetectorDelegate <NSObject>
@optional

/**
 Tells the delegate when the screens brightness changed.
 
 @param brightness A float value between 0.0 and 1.0, inclusive.
 */
- (void)screenBrightnessDidChange:(CGFloat)brightness;

/**
 Tells the delegate when the screen brightness style changed.
 
 @param status An ASCScreenBrightnessStyle enumeration.
 */
- (void)screenBrightnessStyleDidChange:(ASCScreenBrightnessStyle)style;

@end
