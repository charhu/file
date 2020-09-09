
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

@interface DisplayLinkViewController ()<HandderDelegate>
@property (strong, nonatomic) DisplayLink *link;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation DisplayLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Handder *handder = [[Handder alloc] init];
    handder.delegate = self;
    __weak typeof(self) weakSelf = self;
    handder.block = ^(id _Nonnull obj) {
        [weakSelf testDisplayLink];
    };
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
    [self.link invalidate];
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

@end
