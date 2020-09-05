//
//  Son.m
//  Trade
//
//  Created by MacPro on 2020/9/4.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Son.h"

@implementation Son

- (void)logClass{
    NSLog(@"[self class]：%@", [self class]);
    NSLog(@"[super class]：%@", [super class]);
    NSLog(@"[self superclass]：%@", [self superclass]);
    NSLog(@"[super superclass]：%@", [super superclass]);
}

/*
 [self class]：Son
 [super class]：Son
 [self superclass]：Student
 [super superclass]：Student
*/

- (void)classMember{
    BOOL re1 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL re2 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL re3 = [[Son class] KindOfClass:[Son class]];
    BOOL re4 = [[Son class] MemberOfClass:[Son class]];
    
    BOOL re5 = [[Son class] KindOfClass:[Student class]];
    BOOL re6 = [[Son class] MemberOfClass:[Student class]];
    
    NSLog(@"re1 : %d", re1 );
    NSLog(@"re2 : %d", re2);
    NSLog(@"re3 : %d", re3);
    NSLog(@"re4 : %d", re4);
    NSLog(@"re5 : %d", re5);
    NSLog(@"re6 : %d", re6);
}

+ (BOOL)KindOfClass:(Class)cls {
    for (Class tcls = [self valueForKey:@"isa"]; tcls; tcls = [tcls valueForKey:@"superclass"]) {
        if (tcls == cls){
            return YES;
        }
    }
    return NO;
}
+ (BOOL)MemberOfClass:(Class)cls {
    Class tcls = [self valueForKey:@"isa"];
    return tcls == cls;
}


/*
 re1：NSObject 的元类 == NSObject 类对象 ==> NSObject 类对象 == NSObject 类对象 ==》 YES
 re2：NSObject 的元类 == NSObject 类对象 ==》NO
 re3：Son 的元类 == Son 类对象 ==》NO
 re4：Son 的元类 == Son 类对象 ==》NO
 re5：Son 的元类 == Student 类对象 ==》NO
 re6：Son 的元类 == Student 类对象 ==》NO

 所以由此可得：KindOfClass 是 MemberOfClass 的递归查询，作用
 1、判断对象是否是元类
 2、判断2个类是否相同
*/


- (void)instanceMember{
    NSObject *obj = [[NSObject alloc] init];
    BOOL re1 = [obj isKindOfClass:[NSObject class]];
    BOOL re2 = [obj isMemberOfClass:[NSObject class]];
    
    Son *son = [[Son alloc] init];
    BOOL re3 = [son KindOfClass:[Son class]];
    BOOL re4 = [son MemberOfClass:[Son class]];
    
    BOOL re5 = [son KindOfClass:[Student class]];
    BOOL re6 = [son MemberOfClass:[Student class]];
    
    NSLog(@"re1 : %d", re1 );
    NSLog(@"re2 : %d", re2);
    NSLog(@"re3 : %d", re3);
    NSLog(@"re4 : %d", re4);
    NSLog(@"re5 : %d", re5);
    NSLog(@"re6 : %d", re6);
}

- (BOOL)KindOfClass:(Class)cls {
    for (Class tcls = [self valueForKey:@"isa"]; tcls; tcls = [tcls valueForKey:@"superclass"]) {
//    for (Class tcls = [self class]; tcls; tcls = [tcls valueForKey:@"superclass"]) {
        if (tcls == cls){
            return YES;
        }
    }
    return NO;
}

- (BOOL)MemberOfClass:(Class)cls {
    Class tcls = [self valueForKey:@"isa"];    
    return tcls == cls;
//    return [self class] == cls;
}

/*
 re1：NSObject 类对象 == NSObject 类对象 ==> YES
 re2：NSObject 类对象 == NSObject 类对象 ==》YES
 re3：Son 类对象 == Son 类对象 ==》YES
 re4：Son 类对象 == Son 类对象 ==》YES
 re5：Son 类对象 == Student 类对象 ==> Student 类对象 == Student 类对象 ==》YES
 re6：Son 类对象 == Student 类对象 ==》NO

 所以由此可得：KindOfClass 是 MemberOfClass 的递归查询，作用
 1、判断对象是否是类对象
 2、判断2个类是否相同
*/

/*
 汇总：
 1、KindOfClass 是 MemberOfClass 的递归查询, MemberOfClass 只比较一次，
    KindOfClass递归比较到基类为止
 2、如果 instance实例对象 调用，则是判断传参是否是相同的 Class 类对象
 3、如果 Class类对象 调用，则是判断传参是否是相同的 MetaClass 元类对象
*/

@end
