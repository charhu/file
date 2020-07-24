//
//  AppDelegate.m
//  Trade
//
//  Created by MacPro on 2020/7/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.hidden = false;
    
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:NSBundle.mainBundle];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    
    
    UIView *a = nil;
    [self.window addSubview:a];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
