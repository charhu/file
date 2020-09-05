//
//  Apple.m
//  Trade
//
//  Created by MacPro on 2020/9/1.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Apple.h"

@implementation Apple

//- (void)test{
//
//    __weak typeof(self) weakSelf = self;
//    self.block = ^{
////        NSLog(@"_age : %d", _age);        // 写法1
////        NSLog(@"_age : %d", self->_age);  // 写法2
//
//
//        NSLog(@"_age : %d", weakSelf->_age);  // 写法2
//    };
//}

- (void)test1{

    __weak typeof(self) weakSelf = self;
    self.block = ^{
//        NSLog(@"_age : %d", _age);        // 写法1
//        NSLog(@"_age : %d", self->_age);  // 写法2

//        NSLog(@"_age : %ld", (long)weakSelf->_age);  // 写法2
        NSLog(@"_age : %ld", (long)weakSelf.number);  // 写法2
        NSLog(@"name : %@", weakSelf.name);  // 写法2
    };
    
    self.block();
}

- (void)test{
//    {
//            Apple *apple = [[Apple alloc] init];
//
//            __weak typeof(apple) weakSelf = apple;
//            apple.block = ^{
////                __strong typeof(weakSelf) strongSelf = weakSelf;
////                NSLog(@"_age : %d", strongSelf->_age);  // 写法1
//
////                NSLog(@"_age : %ld", (long)aa->_age);  // 写法2
//                [weakSelf click1];
//                [weakSelf click2];
//            };
//
//        apple.block();
//    }
    
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"weakSelf 10: %@", weakSelf);
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"weakSelf 1: %@", weakSelf);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"weakSelf 2: %@", strongSelf);
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"weakSelf 3: %@", strongSelf);
                });
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"weakSelf 4: %@", strongSelf);
                });
            });
        });
    };
    self.block();
}

- (void)test3{
//    {
//            Apple *apple = [[Apple alloc] init];
//
//            __weak typeof(apple) weakSelf = apple;
//            apple.block = ^{
////                __strong typeof(weakSelf) strongSelf = weakSelf;
////                NSLog(@"_age : %d", strongSelf->_age);  // 写法1
//
////                NSLog(@"_age : %ld", (long)aa->_age);  // 写法2
//                [weakSelf click1];
//                [weakSelf click2];
//            };
//
//        apple.block();
//    }
    
    __weak typeof(self) weakSelf = self;
    self.block = ^{
//        __strong typeof(weakSelf)
       typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"weakSelf 10: %@", weakSelf);
        weakSelf.demoBlock = ^{
            NSLog(@"weakSelf 9: %@", weakSelf);
            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"weakSelf 5: %@", weakSelf);
                dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"weakSelf 6: %@", weakSelf);
                    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
                        NSLog(@"weakSelf 7: %@", weakSelf);
                    });
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSLog(@"weakSelf 8: %@", weakSelf);
                    });
                });
            });
        };
        weakSelf.demoBlock();
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"weakSelf 1: %@", weakSelf);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"weakSelf 2: %@", strongSelf);
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"weakSelf 3: %@", strongSelf);
                });
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"weakSelf 4: %@", strongSelf);
                });
            });
        });
        
    };
//“3.如果在block内部存在多线程环境访问self，则需要使用strongSelf”，最后一条需要补充一下，严格来讲是异步线程，同步线程不需要使用strongSelf
    self.block();
    
}


- (void)click1{
    NSLog(@"%s", __func__);
}

- (void)click2{
    NSLog(@"%s", __func__);
}

- (void)click3{
    NSLog(@"%s", __func__);
}

+ (void)click4{
    NSLog(@"%s", __func__);
}

- (void)test2{
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        
//        NSLog(@"_age : %ld", (long)weakSelf->_age);  // 写法1
                        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"_age : %ld", (long)strongSelf->_age);  // 写法2
        
        NSLog(@"_age : %ld", (long)weakSelf.number);
        NSLog(@"name : %@", weakSelf.name);
    };
    
    self.block();
}

- (void)dealloc{
    NSLog(@"%s -----", __func__);
}
@end
