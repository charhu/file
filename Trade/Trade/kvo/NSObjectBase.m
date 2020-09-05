//
//  NSObjectBase.m
//  Trade
//
//  Created by MacPro on 2020/9/4.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NSObjectBase.h"
#include <objc/runtime.h>

@implementation NSObjectBase

/* ------ Execption ------*/

// 消息转发，即消息重定向，forwardInvocation思路，简单讲，就是将本类找不到的实现，让其他类帮忙实现。
// 类方法重签
//+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [super methodSignatureForSelector:aSelector];
//    }
//    return [self instanceMethodSignatureForSelector:@selector(init)];  // 任意的方法
//}
//+ (void)forwardInvocation:(NSInvocation *)invocation {
//    SEL aSelector = [invocation selector];
//   NSLog(@"找不到类方法：[%@ %@]", self, NSStringFromSelector(aSelector));
//}
//
//// 实例方法重签
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [super methodSignatureForSelector:aSelector];
//    }
//    return [self.class instanceMethodSignatureForSelector:@selector(init)]; // 任意的方法
//}
//- (void)forwardInvocation:(NSInvocation *)invocation {
//    SEL aSelector = [invocation selector];
//    NSLog(@"找不到实例方法：[%@ %@]", self, NSStringFromSelector(aSelector));
//}
/* 官方推荐的安全写法，如果有转发的类，子类 可以按这个模板进行，类实现，实例实现
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL aSelector = [invocation selector];
    if ([friend respondsToSelector:aSelector]){
        [invocation invokeWithTarget:friend];
    }else{
        [super forwardInvocation:invocation];
    }
}
*/



//// Class 类方法  ：留给子类去实现
//+ (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"找不到类方法：%@", NSStringFromSelector(aSelector));
//    return nil;
//}
//// instance 实例方法  ：留给子类去实现
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"找不到实例方法：%@", NSStringFromSelector(aSelector));
//    return nil;
//}

@end
