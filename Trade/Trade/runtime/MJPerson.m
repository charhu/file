//
//  MJPerson.m
//  Trade
//
//  Created by MacPro on 2020/9/7.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "MJPerson.h"
#include <objc/runtime.h>
#include <objc/message.h>

@implementation MJPerson

+ (void)load{
//    Method oldm = class_getInstanceMethod(self, @selector(isEqual:));
//    Method newm = class_getInstanceMethod(self, @selector(hahaEqual:));
//    method_exchangeImplementations(oldm, newm);
//}
//
//- (BOOL)hahaEqual:(id)object{
////    BOOL result = [self isEqual:object];  // 会引起死循环报错
//    BOOL result = [self hahaEqual:object];  // 不会引起
//    return result;
}
//// 交换后的等价效果
//- (BOOL)hahaEqual:(id)object{
////    BOOL result = [self hahaEqual:object];  // 会引起死循环报错
//    BOOL result = [self isEqual:object];      // 不会引起
//    return result;
//}

+ (void)test40{
    NSLog(@"---%s---", __func__);
}

- (void)test30{
    
    NSLog(@"class：%d", [self isKindOfClass:[MJPerson class]]);
    NSLog(@"self.class：%d", class_isMetaClass(self.class));
    
    Class cls = self.class;
    NSLog(@"self：%@，  %p", self, self);
    NSLog(@"cls：%@，  %p", cls, cls);
    
    NSLog(@"name；%@", self.name);
}
@end
//0x00007ffee1bccd00
//0x00007ffee1 bc cd 10

//16+1=17
