//
//  Forward.m
//  Trade
//
//  Created by MacPro on 2020/9/3.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Forward.h"
#import "NSObject+Execption.h"

@implementation Forward

- (void)demo1{
    NSString *func = [NSString stringWithFormat:@"%s", __func__];
    NSLog(@"--- %@ --- ", func);
}
+ (void)demo2{
    NSString *func = [NSString stringWithFormat:@"%s", __func__];
    NSLog(@"--- %@ --- ", func);
}

//
/* ------ 消息转发处理方案 2 ------*/
//
// 消息转发，即消息重定向，forwardInvocation思路，简单讲，就是将本类找不到的实现，让其他类帮忙实现。
// 类方法重签
//+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [self.class instanceMethodSignatureForSelector:aSelector];
//    }
//    return [self customMethodSignatureForSelector:aSelector];
//}
//+ (void)forwardInvocation:(NSInvocation *)invocation {
//    [super forwardInvocation:invocation];
//
//    SEL aSelector = [invocation selector];
//    NSLog(@"forwardInvocation： %@", NSStringFromSelector(aSelector));
//}

// 实例方法重签
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [self.class instanceMethodSignatureForSelector:aSelector];
//    }
//    return [self customMethodSignatureForSelector:aSelector];
//}
//- (void)forwardInvocation:(NSInvocation *)invocation {
//    [super forwardInvocation:invocation];
//
//    SEL aSelector = [invocation selector];
//    NSLog(@"forwardInvocation： %@", NSStringFromSelector(aSelector));
//}

@end
