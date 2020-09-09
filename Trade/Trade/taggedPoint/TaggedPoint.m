//
//  TaggedPoint.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "TaggedPoint.h"

@implementation TaggedPoint

+ (void)testTaggedPoint{
    NSLog(@"\n\n");
    
    NSNumber *num0 = [NSNumber numberWithInt:10];
    NSLog(@"num0.class：%@，num0：%p， &num0：%p", num0.class, num0, &num0);
    
    NSNumber *num1 = @(10);
    NSLog(@"num1.class：%@，num1：%p， &num1：%p", num1.class, num1, &num1);
    
    NSNumber *num2 = @(1234567890);
    NSLog(@"num2.class：%@，num2：%p， &num1：%p", num2.class, num2, &num2);

    NSNumber *num3 = @(0xffffffffffffffff);
    NSLog(@"num3.class：%@，num3：%p， &num3：%p", num3.class, num3, &num3);
    
    NSString *str1 = @"abcdefghijk";
    NSLog(@"str1.class：%@，str1：%p， &str1：%p", str1.class, str1, &str1);
    
    NSString *str2 = @"abcdefghijk";
    NSLog(@"str2.class：%@，str2：%p， &str2：%p", str2.class, str2, &str2);
    
    NSString *str3 = @"abc";
    NSLog(@"str3.class：%@，str3：%p， &str3：%p", str3.class, str3, &str3);
    
    NSString *str4 = [NSString stringWithFormat:@"abcdefghijk"];
    NSLog(@"str4.class：%@，str4：%p， &str4：%p", str4.class, str4, &str4);
    
    NSString *str5 = [NSString stringWithFormat:@"abcdefghijk"];
    NSLog(@"str5.class：%@，str5：%p， &str5：%p", str5.class, str5, &str5);
    
    NSString *str6 = [NSString stringWithFormat:@"abc"];
    NSLog(@"str6.class：%@，str6：%p， &str6：%p", str6.class, str6, &str6);
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"date1.class：%@，date1：%p， &date1：%p", date1.class, date1, &date1);
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:0xffffffff];
    NSLog(@"date2.class：%@，date2：%p， &date2：%p", date2.class, date2, &date2);
    
    NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:0xffffffff];
    NSLog(@"date3.class：%@，date3：%p， &date3：%p", date3.class, date3, &date3);
    
    [self isTaggedPoint: num3];
    [self isTaggedPoint: str6];
}

+ (BOOL)isTaggedPoint:(id)ptr{
#define OBJC_MSB_TAGGED_POINTERS 1
    
    #if OBJC_MSB_TAGGED_POINTERS
#           define _OBJC_TAG_MASK (1UL<<63)  // iOS平台  0x1000.....
    #else
#           define _OBJC_TAG_MASK 1UL        // mac 平台  0x01
    #endif
    BOOL istagged = (((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK);
    // 所以由此可见：MAC平台是看二进制最低位是否是1，iOS平台是看最高位是否是1，是1则是TaggedPoint指针，否则不是。
    NSLog(@"ptr；%@， istagged : %d", ptr, istagged);
    
    return istagged;
}


@end


