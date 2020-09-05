//
//  NSObject+Execption.m
//  Trade
//
//  Created by MacPro on 2020/9/4.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NSObject+Execption.h"
#import <objc/runtime.h>

@implementation NSObject (Execption)


//
//+ (void)initialize{
//    [super initialize];
//    NSLog(@" --- %s ----", __func__);
//}

- (void)test{
    NSLog(@" %s  ", __func__);
}

+(void)load{
    NSLog(@" --- %s ----", __func__);
    
    [self exchangeMethod:@"methodSignatureForSelector:" withNewMethod:@"customMethodSignatureForSelector:" isClass: YES];
    [self exchangeMethod:@"forwardInvocation:" withNewMethod:@"customForwardInvocation:" isClass: YES];
    
    [self exchangeMethod:@"methodSignatureForSelector:" withNewMethod:@"customMethodSignatureForSelector:" isClass: NO];
    [self exchangeMethod:@"forwardInvocation:" withNewMethod:@"customForwardInvocation:" isClass: NO];
}

+ (void)exchangeMethod:(NSString *)old withNewMethod:(NSString *)new isClass:(BOOL)isClassMeth{
    SEL origSel = NSSelectorFromString(old);
    SEL newSel = NSSelectorFromString(new);
    if (isClassMeth) {
        [self exchangeClassMethod:origSel withNewMethod:newSel];
    }else{
        [self exchangeInstanceMethod:origSel withNewMethod:newSel];
    }
}

+ (void)exchangeInstanceMethod:(SEL)origSel withNewMethod:(SEL)newSel{
    Class class = [self class];
    Method origMethod = class_getInstanceMethod(class, origSel);
    if (!origMethod) {
        return;
    }
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!newMethod) {
        return;
    }
    method_exchangeImplementations(origMethod, newMethod);
}
+ (void)exchangeClassMethod:(SEL)origSel withNewMethod:(SEL)newSel {
    Class class = [self class];
    Method origMethod = class_getClassMethod(class, origSel);
    if (!origMethod) {
        return;
    }
    Method newMethod = class_getClassMethod(class, newSel);
    if (!newMethod) {
        return;
    }
    method_exchangeImplementations(origMethod, newMethod);
}



/* ------ Execption ------*/

// 消息转发，即消息重定向，forwardInvocation思路，简单讲，就是将本类找不到的实现，让其他类帮忙实现。
// 类方法重签
+ (NSMethodSignature *)customMethodSignatureForSelector:(SEL)aSelector {
    return [self instanceMethodSignatureForSelector:@selector(init)];  // 任意的方法
}
+ (void)customForwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
   NSLog(@"找不到类方法：[%@ %@]", self, NSStringFromSelector(aSelector));
}

// 实例方法重签
- (NSMethodSignature *)customMethodSignatureForSelector:(SEL)aSelector {
    return [self.class instanceMethodSignatureForSelector:@selector(init)]; // 任意的方法
}
- (void)customForwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
    NSLog(@"找不到实例方法：[%@ %@]", self, NSStringFromSelector(aSelector));
}
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

