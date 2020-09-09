//
//  TimerViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/8.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (strong, nonatomic) NSThread *thread;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addThread];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self testLock];
}

- (void)testLock{
    NSLog(@"thread0：%@", [NSThread currentThread]);
// 同步主队列，发生死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"thread1：%@", [NSThread currentThread]);
//    });
// 同步全局队列，不会发生死锁
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"thread2：%@", [NSThread currentThread]);
    });
}

- (void)addThread{
    self.thread = [[NSThread alloc] initWithTarget:self
                                          selector:@selector(testThread)
                                            object:nil];
    [self.thread start];
}

- (void)testThread{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(testTimer)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}
- (void)testTimer{
    NSLog(@"self.thread %@", self.thread);
}


- (void)dealloc{
    NSLog(@"---%s---", __func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // waitUntilDone 指的是，是否等线程执行完毕后，才执行后面的语句
    [self performSelector:@selector(dismissThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)dismissThread{
//    CFRunLoopRef loop = [[NSRunLoop currentRunLoop] getCFRunLoop];
//    CFRunLoopStop(loop);
    
    _timer = nil;
    _thread = nil;
}

@end
