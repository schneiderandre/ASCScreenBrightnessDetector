# ASCScreenBrightnessDetector

[![Build Status](http://img.shields.io/travis/schneiderandre/ASCScreenBrightnessDetector.svg?style=flat)](https://travis-ci.org/schneiderandre/ASCScreenBrightnessDetector)
[![Version](http://img.shields.io/cocoapods/v/ASCScreenBrightnessDetector.svg?style=flat)](http://cocoadocs.org/docsets/ASCScreenBrightnessDetector)
[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](http://cocoadocs.org/docsets/ASCScreenBrightnessDetector)

ASCScreenBrightnessDetector lets you easily detect screen brightness changes and provides some useful delegate methods.

For Example it's very easy to switch between a day and night theme optimized for different lighting conditions:

![ASCScreenBrightnessDetector Demo][1]

## Usage

This repository contains an example project that uses the methods provided by ASCScreenBrightnessDetector - just build and run to see it in action.

**Please note:** The screen brightness detection will only work on a real device, the Xcode Simulators screen brightness is always 0.5.

Wherever you want to use ASCScreenBrightnessDetector, import the header file as follows:

``` objective-c
#import "ASCScreenBrightnessDetector.h"
```
or when using CocoaPods:
``` objective-c
#import <ASCScreenBrightnessDetector/ASCScreenBrightnessDetector.h>
```

To detect the current screen brightness or style you can easily use:
```objective-c
ASCScreenBrightnessDetector *brightnessDetector = [ASCScreenBrightnessDetector new];

NSLog(@"Screen brightness: %f", brightnessDetector.screenBrightness);

ASCScreenBrightnessStyle style = brightnessDetector.screenBrightnessStyle;
switch (style) {
    case ASCScreenBrightnessStyleDark:
        // Do something, e.g. set a dark theme.
        break;
    case ASCScreenBrightnessStyleLight:
        // Do something else, e.g set a light theme.
        break;
}
```

To continuously detect screen brightness changes implement ASCScreenBrightnessDetector as an instance variable, set the delegate and use the following delegate methods:

```objective-c
- (void)screenBrightnessDidChange:(CGFloat)brightness
{
    NSLog(@"The new brightness is: %f", brightness);
}

- (void)screenBrightnessStyleDidChange:(ASCScreenBrightnessStyle)style
{
    NSLog(@"The new style is: %u", style);
}
```

## Properties

The object that acts as the delegate.
```objective-c
id<ASCScreenBrightnessDetectorDelegate> delegate;
```

The brightness level of the screen between 0.0 and 1.0, inclusive. (read-only)
```objective-c
CGFloat screenBrightness;
```

The style indicates if the screen brightness is dark or light and depends on the defined threshold. (read-only)
```objective-c
ASCScreenBrightnessStyle screenBrightnessStyle;
```

The threshold determines whether the brightness style is light or dark. It must have a value between 0.0 and 1.0, inclusive. The default value is 0.5.
```objective-c
 CGFloat threshold;
```
##   Delegate Methods

 Tells the delegate when the screens brightness changed and returns a `float` value between 0.0 and 1.0, inclusive.
```objective-c
- (void)screenBrightnessDidChange:(CGFloat)brightness;
```

 Tells the delegate when the screens brightness style changed and returns an `ASCScreenBrightnessStyle` enumeration.
```objective-c
- (void)screenBrightnessStyleDidChange:(ASCScreenBrightnessStyle)style;
```

## Installation

### From CocoaPods

ASCScreenBrightnessDetector is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```ruby
pod "ASCScreenBrightnessDetector"
```

### Manually

Drag the `ASCScreenBrightnessDetector.h` and `ASCScreenBrightnessDetector.m` source files to your project and you are done.

## Author

André Schneider, [@_schneiderandre](http://twitter.com/_schneiderandre)

## License

ASCScreenBrightnessDetector is available under the MIT license. See the LICENSE file for more info.


  [1]: https://dl.dropboxusercontent.com/u/19150300/Github/ASCScreenBrightnessDetector/ASCScreenBrightnessDetector.gif
