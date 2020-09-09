


//
//  RuntimeViewController.m
//  Trade
//
//  Created by MacPro on 2020/8/25.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "RuntimeViewController.h"
#import "Student.h"

#import "KvoMessage.h"

typedef void(^myBlock)(void);

@interface RuntimeViewController ()
@property (strong, nonatomic) KvoMessage *msg;
@end

@implementation RuntimeViewController

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
    
//    [Student new];
}

//static NSMutableArray *arr = nil;
NSMutableArray *arr = nil;
//
//static Student *stu = nil;
//
//static NSMutableString *str = nil;
//static NSString *string = @"ttt";


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    myBlock block = ^{
        
    };
}



int index1 = 30;
- (void)test2{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        __strong typeof(stu) strongStudent = weakStudent;
//
//        NSLog(@"stu1 : %@", strongStudent);
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"stu2 : %@", strongStudent);
//        });
//    });
        myBlock block;
        {
            arr = [NSMutableArray array];
            [arr addObject:@"1"];
            
            Student *stu = [[Student alloc] init];
            stu.age = 24;
            stu.name = @"jim";
            
            NSMutableString *str = [NSMutableString string];
            [str appendString:@"123"];
            
           static NSString *string = @"ttt";
            
            int count1 = 43;
            
            block = ^{
                [arr addObject:@"2"];
                [arr removeObject:@"1"];
                arr = nil;
                NSLog(@"arr1 : %@", arr);
                
                stu.age = 34;
                stu.name = @"tom";
//                stu = nil;
                
                [str appendString:@"123"];
//                str = @"555";
//                str = nil;
                
                string = @"qqq";
                
                
                NSLog(@"index1 : %d", index1);
                
//                count1 = 20;
                
                NSLog(@"count1 : %d", count1);
            };
//            arr = nil;
            [arr addObject:@"3"];
            NSLog(@"arr3 : %@", arr);
            
            str = nil;
            
            stu = nil;
            
            index1 = 43;
            
            count1 = 25;
            
            block();
            
//            [arr addObject:@"4"];
//            NSLog(@"arr4 : %@", arr);
                
        }
    
       NSLog(@"---");
}

- (void)testInit{
    [Student new];
    [KvoMessage new];
    [KvoMessage new];
    [[NSObject alloc] init];
    [[NSString alloc] init];
    [NSArray array];
    [[KvoMessage alloc] init];
    [Student new];
    [Student new];
    [Student new];
}

- (void)testKvo{
    KvoMessage *msg = [[KvoMessage alloc] init];
//    self.msg = msg;
//    [msg addObserver:self
//           forKeyPath:@"msg"
//              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//              context:nil];
    [msg addObserver:msg
              forKeyPath:@"number"
                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:nil];
    
    msg->_name = @"123";        // 直接修改成员变量方式：不触发KVO
        
    msg.number = @"20";     // set方法：触发KVO
    [msg setNumber:@"20"];  // set方法：触发KVO
    [msg setValue:@"20" forKeyPath:@"number"];  // KVC方式：触发KVO
    /*
     [msg willChangeValueForKey:@"number"];
     msg->number = @"20";
     [msg didChangeValueForKey:@"number"];
     */
        
    [msg setValue:@(2) forKey:@"count"];
    
    
    [KvoMessage test];
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/student", file];
    NSLog(@"path：%@", path);
    
    Student *stu = [[Student alloc] init];
    [stu setName:@"jim"];
    [stu setAge:123];
    
    if (@available(iOS 11.0, *)) {
       NSError *error = nil;
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stu
                                            requiringSecureCoding:NO
                                                            error:&error];
        NSAssert(!error, @" 发生归档错误 ");
        
       [data writeToFile:path atomically:YES];
    } else {
        [NSKeyedArchiver archiveRootObject:stu toFile:path];
    }
    
    id obj = nil;
    if (@available(iOS 11.0, *)) {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:path];
        obj = [NSKeyedUnarchiver unarchivedObjectOfClass:Student.class
                                                fromData:data
                                                   error:&error];
        NSLog(@"error : %@", error);
        NSAssert(!error, @" 发生解归档错误 ");
    }else{
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    if (obj) {
        Student *ss = (Student *)obj;
        NSLog(@"ss.age：%d, ss.name：%@", ss.age, ss.name);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"change：%@", change);
}

- (void)dealloc{
//    [self removeObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#>];
}


@end
