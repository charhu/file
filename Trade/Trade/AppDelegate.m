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
#import "RunloopViewController.h"
#import "Demo.h"
#include <objc/runtime.h>
#import "Work.h"
#include <malloc/malloc.h>
#import "TaggedPoint.h"
#import "CopyStr.h"




#import "AppDelegate+Test1.h"
#import "AppDelegate+Test2.h"
#import "AppDelegate+Test3.h"

@interface AppDelegate (demo2)
@property (nonatomic, copy) NSString *aaa;
- (void)clickTest11;
@end

@interface AppDelegate (demo1)
@property (nonatomic, copy) NSString *bbb;
- (void)clickTest11;
@end

@interface AppDelegate (demo3)
@property (nonatomic, copy) NSString *aaa;
@end

@implementation AppDelegate

- (void)clickTest11{
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
    
    self.aaa = @"111";
    self.bbb = @"222";
    
    NSUUID *idfv = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"idfv : %@  length：%lu", idfv.UUIDString, (unsigned long)idfv.UUIDString.length);
    //初始安装 1、B4728EFD-0A7F-4393-B482-C2A45E21A7AB
    //覆盖安装 2、B4728EFD-0A7F-4393-B482-C2A45E21A7AB   --
    //覆盖安装 3、B4728EFD-0A7F-4393-B482-C2A45E21A7AB   --
    // .....
    //卸载重装 4、ECA8B465-B137-4F19-9700-B88609F8CA4A   变了
    //覆盖安装 5、ECA8B465-B137-4F19-9700-B88609F8CA4A   --
    //覆盖安装 6、ECA8B465-B137-4F19-9700-B88609F8CA4A   --
    
    NSString *uuid2 = [NSUUID UUID].UUIDString;
    NSLog(@"uuid2 : %@  length：%lu", uuid2, (unsigned long)uuid2.length);
    //初始安装 1、44805AD8-3E50-4C76-86E2-83F3A8B81B3B
    //覆盖安装 2、3FEFCFDE-A2EC-486E-B58A-DCB104C9957C   变了
    //覆盖安装 3、85C3DD7D-38A9-4121-B447-ABCEBCB3D200   变了
    // .....                                           变了
    //卸载重装 4、338000E4-C4E3-4CB5-82D3-21B91869F6F8   变了
    //覆盖安装 5、3F524B50-AC9F-43E4-8FEE-60A7CEEA1021   变了
    //覆盖安装 6、520E6394-6312-4814-8B9C-10044E117758   变了
    
    return YES;
}

- (void)testlog{
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
//    RuntimeViewController *vc = [[RuntimeViewController alloc] init];
    
    RunloopViewController *vc = [[RunloopViewController alloc] initWithNibName:@"RunloopViewController" bundle:NSBundle.mainBundle];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
    
    [RuntimeViewController testClassRun];
        
    [TaggedPoint testTaggedPoint];
    
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

+ (void)load{
//    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
//    [super initialize];
    NSLog(@" --- %s ----", __func__);
}


@end
