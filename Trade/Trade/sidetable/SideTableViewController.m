//
//  SideTableViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/10.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "SideTableViewController.h"
#import "Room.h"

extern void _objc_autoreleasePoolPrint(void);

@interface SideTableViewController ()
{
    CFRunLoopObserverRef _observer;
    NSTimer *_timer;
    dispatch_source_t timer;
}
@end

@implementation SideTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testNormal];
//    [self testStrong];
//    [self testWeak];
//    [self testUnsafe];
    
    //创建一个Observer，观察RunLoop的所有状态
    Room *obj2 = [[Room alloc] init];
    Room *obj1 = [[Room alloc] init];
    
    /*
    kCFRunLoopEntry = (1UL << 0), //即将进入Runloop 2^0 = 1
    kCFRunLoopBeforeTimers = (1UL << 1), //即将处理NSTimer 2^1 = 2
    kCFRunLoopBeforeSources = (1UL << 2), //即将处理Sources 2^2 = 4
    kCFRunLoopBeforeWaiting = (1UL << 5), //即将进入休眠  2^5 = 32
    kCFRunLoopAfterWaiting = (1UL << 6), //刚从休眠中唤醒  2^6 = 64
    kCFRunLoopExit = (1UL << 7), //即将退出runloop 2^7 = 128
     */
    
    [self testRunloopObserver];
}

- (void)testRunloopObserver{
    _observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(),kCFRunLoopAllActivities,YES,0,^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"RunLoop状态  %@", caseLog(activity));        
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    
//   _timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//       NSLog(@"--");
//    }];
    [self gcdTimer];
}

- (void)gcdTimer{
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
            NSLog(@"--GCD--");
    });
    dispatch_resume(timer);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    
    timer = nil;
    
    if (_observer) {  // 不使用时，一定要做好移除观察者，以及，释放对象，否则会有内存泄漏的问题
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopDefaultMode);   // kCFRunLoopCommonModes
        CFRelease(_observer);   // 不释放，会导致当前类无法dealloc
        _observer = nil;
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
/*
 即将进入休眠
 2020-09-11 22:37:10.281134+0800 Trade[51588:5185203] RunLoop状态  刚从休眠中唤醒
 2020-09-11 22:37:10.281633+0800 Trade[51588:5185203] RunLoop状态  即将处理NSTimer
 2020-09-11 22:37:10.281796+0800 Trade[51588:5185203] RunLoop状态  即将处理Sources
 2020-09-11 22:37:10.281950+0800 Trade[51588:5185203] RunLoop状态  即将进入休眠
 2020-09-11 22:37:12.730157+0800 Trade[51588:5185203] RunLoop状态  刚从休眠中唤醒
 */



- (void)testNormal{
    @autoreleasepool {
        _objc_autoreleasePoolPrint();
        NSObject *obj1 = nil;
        {
            NSObject *obj = [[NSObject alloc] init];
            obj1 = obj;
        }
        NSLog(@"noraml obj1：%@", obj1);
    }
    NSLog(@"noraml 1");
}
- (void)testStrong{
    @autoreleasepool {
        __strong NSObject *obj2 = nil;
        {
            NSObject *obj = [[NSObject alloc] init];
            obj2 = obj;
        }
        NSLog(@"strong obj2：%@", obj2);
    }
    NSLog(@"strong 2");
}
- (void)testWeak{
    @autoreleasepool {
        __weak NSObject *obj3 = nil;
        {
            NSObject *obj = [[NSObject alloc] init];
            obj3 = obj;
        }
        NSLog(@"weak obj3：%@", obj3);
    }
    NSLog(@"weak 3");
}
- (void)testUnsafe{
    @autoreleasepool {
        __unsafe_unretained NSObject *obj4 = nil;
        {
            NSObject *obj = [[NSObject alloc] init];
            obj4 = obj;
        }
//        NSLog(@"unsafe obj4：%@", obj4);
// Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
    }
    NSLog(@"unsafe 4");
}

- (void)dealloc{
    NSLog(@"---%s---", __func__);
}

@end
