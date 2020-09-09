//
//  Demo.m
//  Trade
//
//  Created by MacPro on 2020/8/7.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Demo.h"

#include <objc/runtime.h>

@implementation Demo

+ (void)load{
//    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
//    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

@end
