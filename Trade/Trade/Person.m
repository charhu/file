//
//  Person.m
//  Trade
//
//  Created by MacPro on 2020/8/11.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Person.h"

@interface Person ()
{
    //默认的 isa 8 字节
    int _height;  // 4字节
    int _no;      // 4字节
}
@property (nonatomic,assign) int age;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation Person

+ (void)load{
//    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
//    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

+ (Person *)instance:(int)num{
    Person *obj = [[Person alloc] init];
    return obj;
}

- (void)addSum:(int)num1 and:(int)num2{
    int num = num1 + num2;
    NSLog(@"num 的结果：%d", num);
}

- (void)dealloc{
    NSLog(@"------person dealloc");
}
@end
