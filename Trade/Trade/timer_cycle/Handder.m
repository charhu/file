//
//  Handder.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Handder.h"

@implementation Handder

// 实例方法重签
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        return [self.class instanceMethodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
    // 判断 其他实例对象 是否有实现该方法
    if ([self.forwardObj respondsToSelector:aSelector]){
        [invocation invokeWithTarget:self.forwardObj];
    }else{
        [super forwardInvocation:invocation];
    }
}

// instance 实例方法  ：留给子类去实现
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.forwardObj;
}


//- (void)test{
//
////    if (self.delegate) {
////        [self.delegate testHandder];
////    }
//
//    if (self.block) {
//        self.block(self);
//    }
//}


- (void)dealloc{
    NSLog(@"---%s----", __func__);
}

@end
