//
//  ViewController.m
//  Runloop
//
//  Created by MacPro on 2020/9/12.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>

//CF_EXPORT void _wrapRunLoopWithAutoreleasePoolHandler(void);

@interface ViewController ()
{
    CFRunLoopObserverRef _observer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        NSArray *arr = [[[NSArray alloc] init] autorelease];
        
        _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(),kCFRunLoopAllActivities,YES,0,^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//            _wrapRunLoopWithAutoreleasePoolHandler();
            NSLog(@"RunLoop状态  %@", caseLog(activity));
        });
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    }
}

NSString* caseLog(CFRunLoopActivity activity){
    switch (activity) {
        case kCFRunLoopEntry:return @"即将进入Runloop";break;
        case kCFRunLoopBeforeTimers:return @"即将处理NSTimer";break;
        case kCFRunLoopBeforeSources:return @"即将处理Sources";break;
        case kCFRunLoopBeforeWaiting:return @"即将进入休眠";break;
        case kCFRunLoopAfterWaiting:return @"刚从休眠中唤醒";break;
        case kCFRunLoopExit:return @"即将退出runloop";break;
        default:break;
    }
    return @"";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSArray *arr = [NSArray array];
//    NSLog(@"%@", [NSRunLoop currentRunLoop]);
}

@end
