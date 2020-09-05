//
//  Student.m
//  Trade
//
//  Created by MacPro on 2020/8/25.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Student.h"
#include <objc/runtime.h>
#include <objc/message.h>

@interface Student()<NSSecureCoding>
@end

@implementation Student

+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (void)encodeWithCoder:(NSCoder *)coder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
    
        if ([key containsString:@"name"]) {
            object_setIvar(self, var, @"4000");
            
            id data = object_getIvar(self, var);
            NSLog(@"data：%@", data);
        }
                
        id  obj = [self valueForKey:key];
        [coder encodeObject:obj forKey:key];
    }
    
    unsigned int outCount = 0;
    objc_property_t *ps = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = ps[i];
        const char *attributeName = property_getAttributes(property);   // A C string containing the property's attributes.
        NSLog(@"attributeName：%s", attributeName);
        
        char *v1 = property_copyAttributeValue(property, "T");
        NSLog(@"v1 : %s", v1);
        
        char *v2 = property_copyAttributeValue(property, "N");
        NSLog(@"v2 : %s", v2);
        
        char *v3 = property_copyAttributeValue(property, "V");
        NSLog(@"v3 : %s", v3);
    }
    
    outCount = 0;
    const char **arr = objc_copyImageNames(&outCount);
//    for (int i = 0; i< outCount; i ++) {
//        NSLog(@"%s", arr[i]);
//    }
//    NSLog(@"outCount：%d", arr.length);
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(self.class, &count);
        for (int i = 0; i < count; i ++){
            Ivar var = ivars[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

// 安全归档必须重写此类方法。
+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)dealloc{
    NSLog(@">>>>>>>>> %s", __func__);
}

@end
