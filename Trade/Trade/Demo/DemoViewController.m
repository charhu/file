//
//  DemoViewController.m
//  Trade
//
//  Created by MacPro on 2020/8/20.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
{
    int age;
}
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSThread *thread ;

@end


@implementation DemoViewController

//@dynamic name;
@synthesize name;


+ (void)load{
//    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
//    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
            
//    NSArray *arr2 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSLog(@"arr2：%@", arr2);
//    NSString *filePath = [NSString stringWithFormat:@"%@/Preferences/www.trade.com.plist", arr2.lastObject];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSLog(@"存在");
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
//        for (NSString *key in dic) {
//            [dic setValue:@(20) forKey:key];
//        }
//        if ([dic writeToFile:filePath atomically:YES]) {
//            NSLog(@"写入ok");
//        }
//
//    }else{
//        NSLog(@"不存在");
//    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 100)];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    UITrackingRunLoopMode
//    NSRunLoopCommonModes
    
//    [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"test"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
 NSCachesDirectory
 "沙盒根目录/Library/Caches",


NSDocumentDirectory
 "沙盒根目录/Documents"


NSDocumentationDirectory
 "沙盒根目录/Library/Documentation"
 
 NSDownloadsDirectory
  "沙盒根目录/Downloads"
 
 NSMusicDirectory
 "沙盒根目录/Music"
 
 NSMoviesDirectory
  "沙盒根目录/Movies"
 
 NSPicturesDirectory
 "沙盒根目录/Pictures"
 */


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击事件：source0");
    
//    [self performSelector:@selector(test)];
    
    
    [self subThread];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"触摸事件：source0");
}

- (void)test{
    NSLog(@"performSelector 事件：source0");
}

- (void)subThread{
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(testThread) object:nil];
    [self.thread start];
}
- (void)testThread{
    // 方案 1
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0
                            target:self
                          selector:@selector(testTimer)
                          userInfo:nil
                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    // 方案 2
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                                      target:self
//                                                    selector:@selector(testTimer)
//                                                    userInfo:nil
//                                                     repeats:YES];
//    [[NSRunLoop currentRunLoop] run];
}
- (void)testTimer{
    NSLog(@"timer : %@", [NSThread currentThread]);
}
- (void)testLog:(NSString *)obj{
    NSLog(@"testLog : %@    obj：%@", [NSThread currentThread], obj);
}

- (void)click{
    [self performSelector:@selector(testLog:) onThread:self.thread withObject:@"hello" waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

@end
