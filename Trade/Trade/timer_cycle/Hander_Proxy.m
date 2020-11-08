//
//  Hander_Proxy.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Hander_Proxy.h"

@implementation Hander_Proxy

// 实例方法重签
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.forwardObj methodSignatureForSelector:aSelector];
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

@end
