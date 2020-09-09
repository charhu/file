//
//  Color+Update.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Color+Update.h"
#include <objc/runtime.h>

@implementation Color (Update)

+ (void)load{
    Method oldM = class_getInstanceMethod(self, @selector(setColerRgb:));
    Method newM = class_getInstanceMethod(self, @selector(runtime_setColerRgb:));
    method_exchangeImplementations(oldM, newM);
}

- (void)runtime_setColerRgb:(int)num{
    NSLog(@"新的 self：%@，num：%d", self, num);
}

@end
