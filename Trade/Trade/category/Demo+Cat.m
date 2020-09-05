//
//  Demo+Dog.m
//  Trade
//
//  Created by MacPro on 2020/8/27.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Demo+Dog.h"

@implementation Demo (Cat)


+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

@end
