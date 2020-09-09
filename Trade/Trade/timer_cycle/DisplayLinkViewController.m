
//
//  DisplayLinkViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "DisplayLinkViewController.h"
#import "DisplayLink.h"

#import "Handder.h"
#import "Hander_Proxy.h"

@interface DisplayLinkViewController ()<HandderDelegate>
{
    dispatch_source_t _gcdTimer;
}
@property (strong, nonatomic) DisplayLink *link;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation DisplayLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testGcdTimer];
}


- (void)testHander{
//    Handder *handder = [[Handder alloc] init];
//    handder.forwardObj = self;
//    handder.delegate = self;
//    __weak typeof(self) weakSelf = self;
//    handder.block = ^(id _Nonnull obj) {
//        [weakSelf testDisplayLink];
//    };
    
    // 不需要 init, NSProxy 代理类，通常用来做中间件，消息转发效率更快更高。它跟NSObject 一样都是基类。
    Hander_Proxy *handder = [Hander_Proxy alloc];
    handder.forwardObj = self;
    
    self.link = (DisplayLink *)[DisplayLink displayLinkWithTarget:handder selector:@selector(testDisplayLink)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)testHandder{
    [self testDisplayLink];
}

- (void)testDisplayLink{
    NSLog(@"---%s----", __func__);
}

- (void)dealloc{
    NSLog(@"\n\n ---%s----", __func__);
    [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_link invalidate];
    _link = nil;
}


- (void)testTimer{
        if (@available(iOS 10.0, *)) {
            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                    repeats:YES
                                                                      block:^(NSTimer * _Nonnull timer) {
                // 方案1
    //            __weak typeof(weakSelf) strongSelf = weakSelf;
    //            [strongSelf test];
                // 方案2
    //            [weakSelf test];
            }];
        } else {
            // Fallback on earlier versions
        }
}

- (void)testGcdTimer{
    // 创建队列
//    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建定时器
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设定时间
    dispatch_source_set_timer(_gcdTimer,
                              DISPATCH_TIME_NOW, // 起始时间
                              1 * NSEC_PER_SEC,  // 间隔时间
                              0 * NSEC_PER_SEC);
    // 执行事件
    dispatch_source_set_event_handler(_gcdTimer, ^{
        NSLog(@"GCD   %@", [NSThread currentThread]);
    });
    // 启动
    dispatch_resume(_gcdTimer);
}

@end
