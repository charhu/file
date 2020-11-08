//
//  CopyStr.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "CopyStr.h"

@implementation CopyStr

+ (void)testCopy{
    [self testArr];
    return;
    NSString *str = [NSString stringWithFormat:@"123456789a"];
    NSString *str1 = [str copy];
    NSString *str2 = str;       // 等同于 strong, retain
    
    NSLog(@"str：%@，str：%p", str, str);      // 123456789a，0x600003854460
    NSLog(@"str1：%@，str1：%p", str1, str1);  // 123456789a，0x600003854460
    NSLog(@"str2：%@，str2：%p", str2, str2);  // 123456789a，0x600003854460
    NSLog(@"\n\n");
    
    str = [NSString stringWithFormat:@"ddddddddddddd"];
    
    NSLog(@"str：%@，str：%p", str, str);      // ddddddddddddd，0x600003912e00
    NSLog(@"str1：%@，str1：%p", str1, str1);  // 123456789a，0x600003854460
    NSLog(@"str2：%@，str2：%p", str2, str2);  // 123456789a，0x600003854460
}

+ (void)testCopy1{
    NSMutableString *str = [NSMutableString stringWithFormat:@"123456789a"];
    NSString *str1 = [str copy];
    NSString *str2 = str;       // 等同于 strong, retain
    
    NSLog(@"str：%@，str：%p", str, str);      // 123456789a，0x60000009d1a0
    NSLog(@"str1：%@，str1：%p", str1, str1);  // 123456789a，0x600000ee0900
    NSLog(@"str2：%@，str2：%p", str2, str2);  // 123456789a，0x60000009d1a0
    
    [str appendString:@"dddddd"];
    
    NSLog(@"str：%@，str：%p", str, str);      // 123456789adddddd，0x60000009d1a0
    NSLog(@"str1：%@，str1：%p", str1, str1);  // 123456789a，0x600000ee0900
    NSLog(@"str2：%@，str2：%p", str2, str2);  // 123456789adddddd，0x60000009d1a0
}

+ (void)testArr{
    NSArray *arr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"123456789a"], [NSMutableString stringWithFormat:@"123456789a"], nil];
    
    NSArray *arr1 = [arr copy];
    NSArray *arr2 = arr;
    
    NSLog(@"arr：%@，arr：%p", arr, arr);      // 123456789a，123456789a，0x600003f31b60
    NSLog(@"arr1：%@，arr1：%p", arr1, arr1);  // 123456789a，123456789a，0x600003f31b60
    NSLog(@"arr2：%@，arr2：%p", arr2, arr2);  // 123456789a，123456789a，0x600003f31b60
    
    NSMutableString *temp1 = arr[0];
    temp1 = @"qqqqqqqqqqqqqqqqqqqqq";
    
    NSMutableString *temp = arr[1];
    [temp appendString:@"dddddd"];
    
    NSLog(@"arr：%@，arr：%p", arr, arr);      // 123456789a，123456789adddddd，0x600003f31b60
    NSLog(@"arr1：%@，arr1：%p", arr1, arr1);  // 123456789a，123456789adddddd，0x600003f31b60
    NSLog(@"arr2：%@，arr2：%p", arr2, arr2);  // 123456789a，123456789adddddd，0x600003f31b60
    
    
}

@end
