//
//  Person.m
//  Main
//
//  Created by MacPro on 2020/9/11.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Person.h"



@implementation Person
@dynamic name;
@dynamic age;

- (void)setName:(NSString *)name{
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}
- (NSString *)name{
    return _name;
}

- (void)setAge:(NSMutableString *)age{
    if (_age != age) {
        [_age release];
        _age = [age copy];
    }
}
- (NSString *)age{
    return _age;
}


- (void)dealloc{
    NSLog(@"--%s---", __func__);
    [super dealloc];
}

@end
