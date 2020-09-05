//
//  AppDelegate.m
//  Trade
//
//  Created by MacPro on 2020/7/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RecordViewController.h"
#import "LifeViewController.h"
#import "DemoViewController.h"
#import "RuntimeViewController.h"

#import "Demo.h"

#include <objc/runtime.h>

#import "Work.h"

#include <malloc/malloc.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
//    NSLog(@">>>> 1 %s",__func__);
    return YES;
    
    NSObject *obj = [[NSObject alloc] init];
    
    Demo *dem = [[Demo alloc] init];
    [dem setNumber:20];
    [dem setName:@"tom"];
    
    Class o1 = [dem class];
    NSLog(@"o1：instance： %@    %p", o1, o1);
    
    Class o2 = [Demo class];
    NSLog(@"o2：Class： %@    %p", o2, o2);
    
    Class o3 = object_getClass([Demo class]);
    NSLog(@"o3：metaClass： %@    %p", o3, o3);
    
    Class o4 = objc_getMetaClass("Demo");
    NSLog(@"o4：metaClass： %@    %p", o4, o4);
    
    Class o5 = objc_getClass("Demo");
    NSLog(@"o5：Class： %@    %p", o5, o5);
    
    Class o6 = dem.superclass;
    NSLog(@"o6：dem.superclass : %d    %@    %p", class_isMetaClass(o6), o6, o6);
    
    Class o7 = Demo.superclass;
    NSLog(@"o7：Demo.superclass : %d    %@    %p", class_isMetaClass(o7), o7, o7);

    Class o8 = o4.superclass;
    NSLog(@"o8：metaClass.superclass : %d    %@    %p", class_isMetaClass(o8), o8, o8);
    
    
//    NSLog(@"%zu", class_getInstanceSize(o8));
//    NSLog(@"%zu", malloc_size((const void *)(0x00007fff89d0fcd8)));
    
    

    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSLog(@">>>> 2 %s",__func__);
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.hidden = false;
    
//    RecordViewController *vc = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:NSBundle.mainBundle];
//    LifeViewController *vc = [[LifeViewController alloc] initWithNibName:@"LifeViewController" bundle:NSBundle.mainBundle];
    
//    DemoViewController *vc = [[DemoViewController alloc] init];
    RuntimeViewController *vc = [[RuntimeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    
    [vc testRun];
    [RuntimeViewController testClassRun];
    UIView *a = nil;
    [self.window addSubview:a];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


//- (void)applicationDidBecomeActive:(UIApplication *)application{
//    NSLog(@">>>> 3 %s",__func__);
//}
//- (void)applicationWillResignActive:(UIApplication *)application{
//    NSLog(@">>>> 4 %s",__func__);
//}
//
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
//    NSLog(@">>>> 5 %s",__func__);
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application{
//    NSLog(@">>>> 6 %s",__func__);
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application{
//    NSLog(@">>>> 7 %s",__func__);
//}
//- (void)applicationWillEnterForeground:(UIApplication *)application{
//    NSLog(@">>>> 8 %s",__func__);
//}

@end
