//
//  NoticeViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/13.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()
{
//    NSTimer *timer;
}
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer1：%@", timer);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//
//    [NSTimer scheduledTimerWithTimeInterval:1
//                                    repeats:YES
//                                      block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer2：%@", timer);
//    }];
    
    [self addBtn];
}

- (void)addBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self addNotice];
}
- (void)click:(UIButton *)sender{
//    [NSNotificationCenter.defaultCenter removeObserver:self name:nil object:@"456"];
//    [self addNOticeQueue];
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer1：%@", timer);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    
    NSLog(@"loop1");
    // 同步并行,同步串行，
    
    // 异步串行，异步并行
    dispatch_async(dispatch_queue_create("ss1", DISPATCH_QUEUE_SERIAL), ^{
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timer1：%@", timer);
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];   // 1
//        [[NSRunLoop currentRunLoop] run]; // 2
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];  // 3
        [[NSRunLoop mainRunLoop] run];  // 4
    });
    
    // 同步串行，同步并行，异步主队列；异步不行，同步主队列不行
    dispatch_async(dispatch_queue_create("ss2", DISPATCH_QUEUE_CONCURRENT), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         repeats:YES
                                                           block:^(NSTimer * _Nonnull timer) {
            NSLog(@"timer2：%@", timer);
        }];
        [[NSRunLoop currentRunLoop] run]; // 5
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];  // 6
//        [[NSRunLoop mainRunLoop] run];  // 7
    });
    
    NSLog(@"loop2");
}


- (void)testThread{
    //    dispatch_queue_t sq1 = dispatch_queue_create("st01", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t sq1 = dispatch_queue_create("st01", DISPATCH_QUEUE_SERIAL);
    dispatch_async(sq1, ^{  // block0
        NSLog(@"log：1");
        dispatch_sync(dispatch_get_main_queue(), ^{   // block1
            NSLog(@"log：2");
            dispatch_sync(sq1, ^{   // block2
                NSLog(@"log：3");
            });
            NSLog(@"log：4");
        });
        NSLog(@"log：5");
    });
    NSLog(@"\n\n");
    // 1,2,3,4,5
    /*
    a: 1 t 5 ==> 2,4,3 | 2,3,4 ==> 1 2,4,3 5 | 1 2,3,4 5
    b: 1 5 t ==> 2,4,3 | 2,3,4 ==> 1 5 2,4,3 | 1 5 2,3,4
    */
    
    
    /*
     a：block0, block1, block2, ==> 1,5,2,4,3
     b: block0, block2, block1, ==> 1,5,3,2,4
     */
}

- (void)addNOticeQueue{
//    NSNotification *notification = [NSNotification notificationWithName:@"haha" object:nil];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSNotificationQueue.defaultQueue enqueueNotification:notification
//                                                 postingStyle:NSPostWhenIdle
//                                                 coalesceMask:NSNotificationNoCoalescing
//                                                     forModes:@[NSDefaultRunLoopMode]];
//
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:15]];
//    });
    
//    dispatch_async(dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT), ^{
//        [self performSelector:@selector(testPerform)];
////        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
////        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:15]];
//        [[NSRunLoop currentRunLoop] run];
//    });
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [self performSelector:@selector(testPerform) withObject:nil afterDelay:1];
//            [self performSelector:@selector(testPerform)];
            
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
                  [[NSRunLoop currentRunLoop] run];
//                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:15]];
//            });
    });
}

- (void)testPerform{
    NSLog(@"testPerform-1：%@", [NSThread currentThread]);
}

- (void)addNotice{
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice1:) name:nil object:@"456"];      // observer 方案1
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice2:) name:@"haha" object:@"456"];  // observer 方案2
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice3:) name:@"haha" object:nil];     // observer 方案3
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice4:) name:nil object:nil];         // observer 方案4
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice5:) name:@"haha" object:@"789"];  // observer 方案5
//    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(notice6:) name:@"aaaa" object:@"456"];  // observer 方案6
    
    // 这个方法本质相当于：addObserver + queue, 同时observer的selector用block代替，这样写，纯粹为了代码高聚合
    // queue 传 nil, 则代表不是用队列，就是普通的 addObserver 同步执行；传了，什么时候执行，由队列说了算，主队列就是主线程。
    id observer = [NSNotificationCenter.defaultCenter addObserverForName:@"name"
                                                                  object:nil
                                                                   queue:[NSOperationQueue mainQueue]
                                                              usingBlock:^(NSNotification * _Nonnull note) {
        // 执行要干的事
    }];
    // 注意在适当的地方移除通知，比如dealloc
    [NSNotificationCenter.defaultCenter removeObserver:observer];
}

- (void)notice1:(NSNotification*)info{
    NSLog(@"NSNotification-1：%@", info.name);
}
- (void)notice2:(NSNotification*)info{
    NSLog(@"NSNotification-2：%@", info.name);
}
- (void)notice3:(NSNotification*)info{
    NSLog(@"NSNotification-3：%@", info.name);
}
- (void)notice4:(NSNotification*)info{
    NSLog(@"NSNotification-4：%@", info.name);
}
- (void)notice5:(NSNotification*)info{
    NSLog(@"NSNotification-5：%@", info.name);
}
- (void)notice6:(NSNotification*)info{
    NSLog(@"NSNotification-6：%@", info.name);
}



- (void)postNotice{
    dispatch_async(dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL), ^{
         NSLog(@"发送：%@", [NSThread currentThread]);
        [NSNotificationCenter.defaultCenter postNotificationName:@"aaaa" object:@"456" userInfo:nil];             // post 方案5
    });
}
- (void)notice:(NSNotification*)info{
    NSLog(@"接收：%@", [NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{    // 如果是更新UI，则需要切换到主线程
        NSLog(@"处理：%@", [NSThread currentThread]);
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [NSNotificationCenter.defaultCenter postNotificationName:@"haha" object:nil userInfo:nil];            // post 方案1：[]
// [NSNotificationCenter.defaultCenter postNotificationName:@"haha" object:nil userInfo:@{@"kk":@"vv"}]; // post 方案2
 [NSNotificationCenter.defaultCenter postNotificationName:@"haha" object:@"456" userInfo:nil];             // post 方案3
// [NSNotificationCenter.defaultCenter postNotificationName:@"haha" object:@"456" userInfo:@{@"kk":@"vv"}];  // post 方案4
    
    [NSNotificationCenter.defaultCenter postNotificationName:@"aaaa" object:@"456" userInfo:nil];             // post 方案6
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
}

@end
