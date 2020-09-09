//
//  NSMutableArray+Insert.m
//  Trade
//
//  Created by MacPro on 2020/9/8.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NSMutableArray+Insert.h"
#include <objc/runtime.h>
@implementation NSMutableArray (Insert)

+ (void)load{
    NSLog(@"--- %s ---", __func__);
    Class cls = objc_getClass("__NSArrayM");
    Method oldM = class_getInstanceMethod(cls, @selector(addObject:));
    Method newM = class_getInstanceMethod(cls, @selector(runtime_addObject:));
    method_exchangeImplementations(oldM, newM);
}

//- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
//
//}

- (void)runtime_insertObject:(id)anObject atIndex:(NSUInteger)index{
    if (!anObject) {
        NSLog(@"对象不存在");
        return;
    }
    [self runtime_insertObject:anObject atIndex:index];
    NSLog(@"self：%@", self);
}

- (void)runtime_addObject:(id)anObject{
    if (!anObject) {
        NSLog(@"对象不存在 runtime_addObject");
        return;
    }
    [self runtime_addObject:anObject];
//    NSLog(@"self：%@", self);
}

@end
