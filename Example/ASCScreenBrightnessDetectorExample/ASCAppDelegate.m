//
//  ASCAppDelegate.m
//  ASCScreenBrightnessDetectorExample
//
//  Created by André Schneider on 29.01.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "ASCAppDelegate.h"
#import "ASCSampleViewController.h"

@implementation ASCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ASCSampleViewController *sampleViewController = [ASCSampleViewController new];
    [self.window setRootViewController:sampleViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
