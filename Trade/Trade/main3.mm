
#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#include <objc/runtime.h>
#include <objc/message.h>

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

#import "MJPerson.h"

#import "RedColor.h"

#import <sys/poll.h>
#include <malloc/malloc.h>

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

void testSon(){
    MJPerson *per = [[MJPerson alloc] init];
    [per isEqual:[[MJPerson alloc] init]];
}

void testRemory(){
    NSObject *obj1 = [[NSObject alloc] init];
    NSObject *obj2 = [[NSObject alloc] init];
    NSObject *obj3 = [[NSObject alloc] init];
    
    NSLog(@"堆 obj1：%p", obj1);  // 0x600002b4c0a0   低：↓
    NSLog(@"堆 obj2：%p", obj2);  // 0x600002b4c0e0   中：↓
    NSLog(@"堆 obj3：%p", obj3);  // 0x600002b4c100   高：↓
    
    NSLog(@"栈 obj1：%p", &obj1); // 0x7ffee9305be8   高：↓
    NSLog(@"栈 obj2：%p", &obj2); // 0x7ffee9305be0   中：↓
    NSLog(@"栈 obj3：%p", &obj3); // 0x7ffee9305bc8   低：↓
/*
因为堆遵守先进先出FIFO，栈遵守先进后出FILO(则后进先出)，所以由此可见，堆栈区，实际上都是遵守，低地址的变量先出去
 */
}

void testSon3(){
    int *c = nil;
    NSString *test = @"123";
    id cls = [MJPerson class];
//    [cls test40];
    objc_msgSend(cls, @selector(test40));
    
    void *obj = &cls;
    [(__bridge id)obj test30];
    objc_msgSend((__bridge id)obj, @selector(test30));
    
    MJPerson *per = [[MJPerson alloc] init];
//    [MJPerson test40];
    objc_msgSend(MJPerson.class, @selector(test40));
//    [per test30];
    objc_msgSend(per, @selector(test30));
}

void testSon2(){
    Son *ss = [[Son alloc] init];
    [ss test2];
    [Son test1];
    
    [ss test2];
    [Son test1];
    
    [ss test2];
    [Son test1];
}

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

void classISA();

void testArr(){
    NSString *obj = nil;
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"1"];
    [arr addObject:@"3"];
    [arr addObject:obj];
    [arr addObject:@"4"];
    
    NSDictionary *dic = @{@"key":@"value"};
    NSString *var = dic[@"ss"];
}

void testColor(){
    RedColor *redC = [[RedColor alloc] init];
    [redC setColerRgb:100];
    
    Color *cc = [[Color alloc] init];
    [cc setColerRgb:100];
}

void testPlusPlus(){
    int i = 1;  // i = 1
    i = i++;    // i = 1
    int j = i++;  // j = 1, i = 1
    int k = i + ++i * i++; // 2 + 3 * 3
    NSLog(@"i=%d",i); // 4
    NSLog(@"j=%d",j); // 1
    NSLog(@"k=%d",k); // 11
    
    if (i < 6) {
        NSLog(@"333333");
    }else if (i < 7) {
        NSLog(@"444444");
    }else if (i < 0) {
        NSLog(@"000000");
    }else if (i < 5) {
        NSLog(@"555555");
    }else{
        NSLog(@"xxxxxxx");
    }
}

void loadEnv(){
    NSDictionary * environments = [[NSProcessInfo processInfo] environment];
    BOOL logOn = [[environments objectForKey:@"CUSTOM_ENV"] isEqualToString:@"YES"];
    NSLog(@"\n\n count: %ud， env：%@  logOn：%d \n\n ", environments.allKeys.count, [environments objectForKey:@"CUSTOM_ENV"], logOn );
}

void testRetain(){
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"retainCount-obj：%@", [obj valueForKey:@"retainCount"]);  // retainCount = 1
    
    NSMutableArray *arr1 = [NSMutableArray array];
    [arr1 addObject:obj];
    NSLog(@"retainCount-obj：%@", [obj valueForKey:@"retainCount"]);  // retainCount = 2
    
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObject:obj];
    NSLog(@"retainCount-obj：%@", [obj valueForKey:@"retainCount"]);  // retainCount = 3
    
    NSMutableArray *arr3 = [NSMutableArray array];
    [arr3 addObject:obj];
    NSLog(@"retainCount-obj：%@", [obj valueForKey:@"retainCount"]);  // retainCount = 4
    
    NSLog(@"SERIAL：%x", dispatch_queue_create("ss1", DISPATCH_QUEUE_SERIAL));
    NSLog(@"SERIAL：%x", dispatch_queue_create("ss2", DISPATCH_QUEUE_SERIAL));
    NSLog(@"ss2：%x", dispatch_queue_create("ss3", DISPATCH_QUEUE_CONCURRENT));
    NSLog(@"ss2：%x", dispatch_queue_create("ss2", DISPATCH_QUEUE_CONCURRENT));
    NSLog(@"global：%x", dispatch_get_global_queue(0, 0));
    NSLog(@"main：%x", dispatch_get_main_queue());
}

//    dispatch_queue_t queue = dispatch_queue_create("AA", DISPATCH_QUEUE_CONCURRENT);
//dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

void testThreadLock(){
//    dispatch_queue_t queue = dispatch_queue_create("AA", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        NSLog(@"执行2");
//        dispatch_async(queue, ^{
//            NSLog(@"执行3");
//        });
//        NSLog(@"执行4");
//    });
//     NSLog(@"执行5");
}

void testMainQueue(){
    dispatch_queue_t sq1 = dispatch_queue_create("st01", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(dispatch_get_main_queue(), ^{   // block1
        NSLog(@"log：2");
        dispatch_sync(sq1, ^{   // block2
            NSLog(@"log：3");
        });
        NSLog(@"log：4");
    });
}

void testRelease(){
    MJPerson *p = [[MJPerson alloc] init];
    for (int i = 0; i < 100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            p.name = [NSMutableString stringWithFormat:@"aaaaaaaaaaaaaaaaaaaaaa"];
        });
    }
}

int main(int argc, char *argv[]){
    
    int right = 4;
    right = right + 0b1000 >> 2;
    
    NSLog(@"poll1：%d, right：%x", !poll, right);
    
    @autoreleasepool {
        testRelease();
        
//        testThreadLock();
        
//        testRetain();
        
//      CFRunLoopObserverRef *ref = (CFRunLoopObserverRef *)malloc(sizeof(CFRunLoopObserverRef));
//        loadEnv();
//        testPlusPlus();
        
        
//        testColor();
//        testArr();
//        testSon();
//        test1();
        
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
  
        /*
         PAGE_MAX_SIZE
         PAGE_MIN_SIZE
        */
        NSLog(@"PAGE_MAX_SIZE：%d", PAGE_MAX_SIZE);
        NSLog(@"PAGE_MIN_SIZE：%d", PAGE_MIN_SIZE);
        
//        NSDictionary *dic = [NSDictionary dictionary];
//        [dic setValue:nil forKey:nil];
        
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
     
    KvoMessage *msg = [[KvoMessage alloc] init];
    [msg demo5];
    [KvoMessage demo6];
    
    Forward *forw = [[Forward alloc] init];
    [forw demo11];
    [Forward demo22];
    
    Student *stu = [[Student alloc] init];
    [stu testStu];
    [Student testStuClass];
    
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
