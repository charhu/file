
#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#include <objc/runtime.h>
//#include <malloc/malloc.h>
//
//#import "Demo.h"
//
#import "Student.h"

#import "Apple.h"
//#import <objc/runtime.h>

#import "KvoMessage.h"
#import "Forward.h"
#import "Son.h"

@interface Man : NSObject
@property (assign, nonatomic) int age;
@property (strong, nonatomic) NSString *name;
@end

@implementation Man
@end

struct bucket_t {
//    SEL _newSel;
//    cache_key_t _key;
    SEL _key;
    IMP _imp;
};

struct cache_t {
    struct bucket_t *_buckets;
    uint32_t _mask;
    uint16_t _occupied;
};

struct my_objc_class {
    Class ISA;
    Class superclass;
    struct cache_t cache;             // formerly cache pointer and vtable
};

//@interface Teacher : Man
//@property (assign, nonatomic) int number;
//@end
//
//@implementation Teacher
//@end

 NSInteger num = 3;  // 等同于 static auto NSInteger num = 3;
//Man *obj = nil;


void test1(){
    Son *son = [[Son alloc] init];
    NSLog(@"------------------------------------------\n");
    [son logClass];
    NSLog(@"------------------------------------------\n");
    [son instanceMember];
    NSLog(@"------------------------------------------\n");
    
    Son *son1 = [[Son alloc] init];
    if ([son isEqual:son1]) {
        NSLog(@"相同");
    }else {
        NSLog(@"不相同");
    }
    
    if (son == son1) {
        NSLog(@"相同");
    }else {
        NSLog(@"不相同");
    }
}

void fordwing();

void test2(){
    KvoMessage *msg = [[KvoMessage alloc] init];
    [msg demo5];
    [KvoMessage demo6];
    
    [msg demo5];
    [KvoMessage demo6];
    
    Forward *forw = [[Forward alloc] init];
    [forw demo11];
    [Forward demo22];
    
    [forw demo11];
    [Forward demo22];
    
    fordwing();
    
    Student *stu = [[Student alloc] init];
    [stu testStu];
    [Student testStuClass];
}

void classISA();


int main(int argc, char *argv[]){
    
    @autoreleasepool {
        
//        test1();
        test2();
//        fordwing();
//        NSInteger num = 3;
//
//        NSObject *obj = [[NSObject alloc] init];
//        __weak typeof(obj) weakSelf = obj;
//        NSInteger (^block)(NSInteger) = ^NSInteger(NSInteger n){
//            NSLog(@"weakSelf : %@", weakSelf);
//            return n * num;
//        };
//        NSInteger result = block(2);
//        NSLog(@"result：%ld", result);
  
        
        Man *obj1 = [[Man alloc] init];
        obj1.age = 40;
        
        __block Man *obj2 = [[Man alloc] init];
        obj2.age = 13;
//        __weak typeof(obj) weakSelf = obj;
        
        void (^block)(NSInteger) = ^void(NSInteger n){
//            weakSelf.age = 100;
//            NSLog(@"weakSelf.age : %d", weakSelf.age);
            NSLog(@"obj1 : %@", obj1);
            NSLog(@"obj2 : %@", obj2);
        };
//        obj.age = 44;
//        block(2);
//        NSLog(@"obj.age：%d", obj.age);
        
        /*  值捕获  */
//        NSInteger num = 3;  // 等同于 auto NSInteger num = 3;
//        void (^block)(NSInteger) = ^void(NSInteger n){
//            NSLog(@"n : %ld", (long)num);
//        };
//        num = 20;
//        block(num);
//        打印结果：n : 3
                
        
        /* 指针捕获 */
//        static NSInteger num = 3;  // 等同于 static auto NSInteger num = 3;
//        void (^block)(NSInteger) = ^void(NSInteger n){
//            NSLog(@"n : %ld", (long)num);
//        };
//        num = 20;
//        block(num);
//        打印结果：n : 20
        
        /* 不捕获 */
//        void (^block)(NSInteger) = ^void(NSInteger n){
//            num = num + 5;
//            NSLog(@"n : %ld", (long)num);
//        };
//        num = 20;
//        block(num);
//        打印结果：n : 25, 等同于直接20传参进去，在做运算，所以是没有捕获
        
    {
//        Apple *app = [[Apple alloc] init];
        
//        app.number = 13;
//        NSLog(@"%d", app->_age);
        
//        __weak Apple *weakSelf = app;
//        app.block = ^{
////            __strong typeof(weakSelf) strongSelf = weakSelf;
////            NSLog(@"app.number ： %ld", (long)strongSelf.number);
//
////            NSLog(@"app.number ： %ld", (long)weakSelf->_age);
//        };
//        app.block();
        
//        [app test];
        
//        [app click3];
    }
//        return 0;
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}



void fordwing(){
     if (__builtin_expect(3,1)) {
         NSLog(@"YES");
     }else{
         NSLog(@"no");
     }
     
     KvoMessage *kvo1 = [[KvoMessage alloc] init];
     [kvo1 demo1];
     [KvoMessage demo2];

     [kvo1 demo1];
     [KvoMessage demo2];
     
     [kvo1 demo1];
     [KvoMessage demo2];
     
     // 测试动态解析
     [kvo1 resolveInstanceMethodDynamically];
     [KvoMessage resolveClassMethodDynamically];
}

void classISA(){
    
    KvoMessage *kvo1 = [[KvoMessage alloc] init];
    NSLog(@"kvo1： %@,  %p   %d", kvo1, kvo1, class_isMetaClass(kvo1));
    
    id obj10 = [kvo1 valueForKey:@"isa"];
    NSLog(@"obj10： %@,  %p   %d", obj10, obj10, class_isMetaClass(obj10));
    
    Class obj20 = kvo1.class;
    NSLog(@"obj20： %@,  %p   %d", obj20, obj20, class_isMetaClass(obj20));
    
    Class obj30 = [obj20 class];
    NSLog(@"obj30： %@,  %p   %d", obj30, obj30, class_isMetaClass(obj30));
    
    id obj40 = [obj30 valueForKey:@"isa"];
    NSLog(@"obj40： %@,  %p   %d", obj40, obj40, class_isMetaClass(obj40));
    
    id obj50 = [obj40 valueForKey:@"isa"];
    NSLog(@"obj50： %@,  %p   %d", obj50, obj50, class_isMetaClass(obj50));
    
    id obj60 = [obj50 valueForKey:@"isa"];
    NSLog(@"obj60： %@,  %p   %d", obj60, obj60, class_isMetaClass(obj60));
    
/*
 2020-09-03 02:39:59.610096+0800 Trade[6215:505936] kvo1： <KvoMessage: 0x6000036d4d20>,  0x6000036d4d20   0
 2020-09-03 02:39:59.610453+0800 Trade[6215:505936] obj10： KvoMessage,  0x1078703c8   0
 2020-09-03 02:39:59.610595+0800 Trade[6215:505936] obj20： KvoMessage,  0x1078703c8   0
 2020-09-03 02:39:59.610705+0800 Trade[6215:505936] obj30： KvoMessage,  0x1078703c8   0
 2020-09-03 02:39:59.610867+0800 Trade[6215:505936] obj40： KvoMessage,  0x1078703a0   1
 2020-09-03 02:39:59.611045+0800 Trade[6215:505936] obj50： NSObject,  0x7fff89d0fcd8   1
 2020-09-03 02:40:02.393575+0800 Trade[6215:505936] obj60： NSObject,  0x7fff89d0fcd8   1
 */
/*
 通过打印结果可知：
 1、对于实例对象 instance，拿isa其实就相当于在拿类对象Class
 2、对于类对象 Class，拿isa其实就相当于在拿元类对象MetaClass
 3、元类对象的 基类是 NSObject MetaClass
 */
}
