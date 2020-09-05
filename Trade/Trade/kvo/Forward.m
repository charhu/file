//
//  Forward.m
//  Trade
//
//  Created by MacPro on 2020/9/3.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Forward.h"

@implementation Forward

- (void)demo1{
    NSString *func = [NSString stringWithFormat:@"%s", __func__];
    NSLog(@"--- %@ --- ", func);
}
+ (void)demo2{
    NSString *func = [NSString stringWithFormat:@"%s", __func__];
    NSLog(@"--- %@ --- ", func);
}

@end
