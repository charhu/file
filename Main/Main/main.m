//
//  main.m
//  Main
//
//  Created by MacPro on 2020/7/30.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

extern void _objc_autoreleasePoolPrint(void);

void testRelease(){
    Person *p = [[Person alloc] init];
    for (int i = 0; i < 1000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *a = [NSString stringWithFormat:@"aaaaaaaaaaaaaaaaaaaaaaaa"];
//            if (p->_name != a) {
//                [p.name release];
////                p->_name = [a copy];
//                p->_name = [a retain];
//            }
//            p.name = a;
            p.age = a;
        });
    }
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        _objc_autoreleasePoolPrint();
        
//        Person *obj1 = [[[Person alloc] init] autorelease];
//        Person *obj1 = [[Person alloc] init];
//        [obj1 release];
//        _objc_autoreleasePoolPrint();
//
////        Person *obj2 = [[[Person alloc] init] autorelease];
//        Person *obj2 = [[Person alloc] init];
//        [obj2 release];
//        _objc_autoreleasePoolPrint();
        
        testRelease();
        
//        Person *p = [[Person alloc] init];
//        NSLog(@"retainCount：%lud", (unsigned long)p.name.retainCount); // 0
//        p.name = [NSString stringWithFormat:@"aaaaaaaaaaaaaaaaaaaaaaaaa"];
//        NSLog(@"retainCount：%lud", (unsigned long)p.name.retainCount); // 2
//        
//        NSString *a = [p.name copy];
//        [a release];
//        NSLog(@"retainCount：%lud", (unsigned long)p.name.retainCount); // 2
//        [a release];
//        NSLog(@"retainCount：%lud", (unsigned long)p.name.retainCount); // 1
//        [a release];
//        NSLog(@"retainCount：%lud", (unsigned long)p.name.retainCount); // 0
//        
//        NSLog(@"a：%@, a：%p", a, a);
//        NSLog(@"p.name：%@, p.name：%p", p.name, p.name);
    }
    return 0;
}
