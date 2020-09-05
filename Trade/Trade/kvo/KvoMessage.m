//
//  KvoMessage.m
//  Trade
//
//  Created by MacPro on 2020/8/28.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "KvoMessage.h"

#include <objc/runtime.h>
#import "Forward.h"

@interface KvoMessage ()
@property (strong, nonatomic) Forward *forwardObj;
@end

@implementation KvoMessage

- (Forward *)forwardObj{
    if (!_forwardObj) {
        _forwardObj = [[Forward alloc] init];
    }
    return _forwardObj;
}

+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"change：%@", change);
}

- (void)dealloc{
//    [self removeObserver:self forKeyPath:@"number"];
}

//+ (void)test{
//    NSLog(@" --- %s --- ", __func__);
//}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    return NO;
    if ([key isEqualToString:@"_name"]) {
        return YES;
    }else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

/*

1、print、p、po： 打印
2、memory read/[数量-可选][进制-可选][字节数-可选] 内存地址 或 对象
3、memory write 内存地址 值
 如：memory write 0x00000001 10
4、x/[数量-可选][进制-可选][字节数-可选] 内存地址 或 对象
 如：x/3xw object
 字母意思：x 16进制，f 浮点，d 10 进制；b 1字节，h 2字节，w 4字节，g 8字节
*/

// 假设没有实现 resolveThisMethodDynamically
//- (void)resolveThisMethodDynamically{
//    NSLog(@"1111");
//}
+ (BOOL) resolveInstanceMethod:(SEL)aSel{
    
    if (aSel == @selector(resolveThisMethodDynamically)){
        // 因为是新增实例方法，所以给 Class 添加方法：Class = self
        Method method = class_getInstanceMethod(self, sel_registerName("dynamicMethodIMP"));
        const char *types = method_getTypeEncoding(method);
        IMP imp = method_getImplementation(method);
        
        class_addMethod([self class], aSel, imp, types);
        
        return YES;
    }else{
        return [super resolveInstanceMethod:aSel];
    }
}
- (void)dynamicMethodIMP{
    NSLog(@"222");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"222   %@", [NSThread currentThread]);
             [self performSelector:@selector(testThread) withObject:nil afterDelay:2];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    });
}


- (void)testThread{
    NSLog(@"hhhhhh   %@", [NSThread currentThread]);
}

// 假设没有实现 resolveThisClassMethodDynamically
//- (void)resolveThisClassMethodDynamically{
//    NSLog(@"1111");
//}
+ (BOOL) resolveClassMethod:(SEL)aSel{
    
    if (aSel == @selector(resolveThisClassMethodDynamically)){
        // 因为是新增类方法，所以给 MetaClass 添加方法：MetaClass = object_getClass(self)
        Method method = class_getClassMethod(object_getClass(self), sel_registerName("dynamicClassMethodIMP"));
        const char *types = method_getTypeEncoding(method);
        IMP imp = method_getImplementation(method);
        
        class_addMethod(object_getClass(self), aSel, imp, types);
        
        return YES;
    }else{
        return [super resolveClassMethod:aSel];
    }
}
+ (void)dynamicClassMethodIMP{
    NSLog(@"333");
}

//
///* ------ 消息转发处理方案 2 ------*/
//
//// 消息转发，即消息重定向，forwardInvocation思路，简单讲，就是将本类找不到的实现，让其他类帮忙实现。
//// 类方法重签
//+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [super methodSignatureForSelector:aSelector];
//    }
//    return [NSMethodSignature methodSignatureForSelector:aSelector];
//}
+ (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
    // 判断 其他类对象 是否有实现该方法
    if ([Forward.class respondsToSelector:aSelector]){
        [invocation invokeWithTarget: Forward.class];
    }else{
        [super forwardInvocation:invocation];
    }
}
//
//// 实例方法重签
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if ([self respondsToSelector:aSelector]) {
//        return [super methodSignatureForSelector:aSelector];
//    }
//    return [NSMethodSignature methodSignatureForSelector:aSelector];
//}
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL aSelector = [invocation selector];
    // 判断 其他实例对象 是否有实现该方法
    if ([self.forwardObj respondsToSelector:aSelector]){
        [invocation invokeWithTarget:self.forwardObj];
    }else{
        [super forwardInvocation:invocation];
    }
}




/* ------ 消息转发处理方案 1 ------*/
/*
 1、如果一个对象实现(或继承)这个方法，并返回一个非nil和非self结果，那么返回的对象将用作新的接收者对象，消息分派将继续到这个新对象。
 2、注意：如果从这个方法返回self，代码很明显将陷入无限死循环
 3、如果你在一个非根类中实现这个方法，如果你的类对于给定的选择器没有返回任何东西，那么你应该返回调用super的实现的结果。
 */
// Class 类方法
//+ (id)forwardingTargetForSelector:(SEL)sel {
//    // 判断 其他类对象 是否有实现该方法
//    if ([Forward.class respondsToSelector:sel]){
//        return Forward.class; // 类对象
//    }else{
//        return [super forwardingTargetForSelector:sel];
//    }
//}
//// instance 实例方法
//- (id)forwardingTargetForSelector:(SEL)sel {
//    // 判断 其他实例对象 是否有实现该方法
//    if ([self.forwardObj respondsToSelector:sel]){
//        return self.forwardObj; // 实例对象
//    }else{
//        return [super forwardingTargetForSelector:sel];
//    }
//}









//// Replaced by CF (throws an NSException)
//+ (void)doesNotRecognizeSelector:(SEL)sel {
////    [super doesNotRecognizeSelector:sel];
//    
//    NSLog(@"+[%s %s]: unrecognized selector sent to instance %p",
//                class_getName(self), sel_getName(sel), self);
//}
//
//// Replaced by CF (throws an NSException)
//- (void)doesNotRecognizeSelector:(SEL)sel {
////    [super doesNotRecognizeSelector:sel];
//    
//    NSLog(@"-[%s %s]: unrecognized selector sent to instance %p",
//                object_getClassName(self), sel_getName(sel), self);
//}


- (void)demo3{
    NSLog(@"-- %s ----", __func__);
}
+ (void)demo4{
    NSLog(@"-- %s ----", __func__);
}
@end
