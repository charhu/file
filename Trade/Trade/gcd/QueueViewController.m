//
//  QueueViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/8.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "QueueViewController.h"
#include <libkern/OSAtomic.h>
#include <os/lock.h>
#include <pthread/pthread.h>

@interface QueueViewController ()
{
    BOOL _isDone;
    NSLock *_nlock;
    NSRecursiveLock *_rlock;
    NSCondition *_condition;
    NSConditionLock *_conditionLock;
    dispatch_semaphore_t _sem;
    dispatch_queue_t _queue;
}
@property (assign, nonatomic) NSInteger count;
@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self testLock];
}

- (void)testLock{
    self.count = 90;
    
    if (!_sem) {
      _sem = dispatch_semaphore_create(1);
    }
    
    if (!_queue) {
        _queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (int i = 0; i < 30; i ++) {
            NSLog(@"线程号  %@", [NSThread currentThread]);
            [strongSelf sellTikcet];
        }
    });
    
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (int i = 0; i < 30; i ++) {
            NSLog(@"线程号  %@", [NSThread currentThread]);
            [strongSelf sellTikcet];
        }
    });
    
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (int i = 0; i < 30; i ++) {
            NSLog(@"线程号  %@", [NSThread currentThread]);
            [strongSelf sellTikcet];
        }
    });
}
- (void)sellTikcet{
    
// 1、在需要加锁的代码那边加锁代码
/*
     @synchronized (锁) {
        // do Something...
     }
 */

// 2、声明全局变量，接着在其他地方先初始化 _
/*
    static OSSpinLock lockit = OS_SPINLOCK_INIT;
    if (!OSSpinLockTry(&_lockit)) {
        OSSpinLockLock(&_lockit);
    }
    // do Something...
    OSSpinLockUnlock(&_lockit);
*/
        
// 3、使用打标记的方式，原理就是通过标记为判断代码是否执行完毕，知道完毕了，才更新标记的状态，
/*
 if (!_isDone) {
    _isDone = true;
    // do Something...
    _isDone = false;
 }
*/
    
// 4、#include <os/lock.h>
/*
 static os_unfair_lock unfair_lock = OS_UNFAIR_LOCK_INIT;
 if(!os_unfair_lock_trylock(&unfair_lock)){  // 判断锁没有锁住，才进行安全加锁
     os_unfair_lock_lock(&unfair_lock);
 }
 // do Something...
 os_unfair_lock_unlock(&unfair_lock);    // 执行完了进行解锁
*/
    
// 5、pthread_mutex_lock
//    初始化方案1
    // 初始化属性
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
//    // 初始化锁
//    static pthread_mutex_t mutex_lock;
//    pthread_mutex_init(&mutex_lock, &attr);
    
//    初始化方案2
//    static pthread_mutex_t mutex_lock;
//    pthread_mutex_init(&mutex_lock, NULL);
    
//    初始化方案3
    // 静态初始化方法
//    static pthread_mutex_t mutex_lock = PTHREAD_MUTEX_INITIALIZER;
//    // 互斥锁：允许同一个线程，对一把锁进行重复加锁，否则不会加锁成功
//    pthread_mutex_lock(&mutex_lock);
//    if (self.count <= 0) {
//        pthread_mutex_unlock(&mutex_lock);    // 注意释放锁，不然由于再次调用，可能出现坏内存访问
//        return;
//    }
//    [self doSomeThing];
//    pthread_mutex_unlock(&mutex_lock);    // 执行完了进行解锁
    
// 6、NSLock
//    if (!_nlock) {
//        _nlock = [[NSLock alloc] init];
//    }
//    // 互斥锁：允许同一个线程，对一把锁进行重复加锁，否则不会加锁成功
//    [_nlock lock];
//    if (self.count <= 0) {
//        [_nlock unlock];   // 注意释放锁，不然由于再次调用，可能出现坏内存访问
//        return;
//    }
//    [self doSomeThing];
//    [_nlock unlock];;    // 执行完了进行解锁

// 7、NSRecursiveLock；
//    if (!_rlock) {
//        _rlock = [[NSRecursiveLock alloc] init];
//    }
//    // 互斥锁：允许同一个线程，对一把锁进行重复加锁，否则不会加锁成功
//    [_rlock lock];
//    if (self.count <= 0) {
//        [_rlock unlock];   // 注意释放锁，不然由于再次调用，可能出现坏内存访问
//        return;
//    }
//    [self doSomeThing];
//    [_rlock unlock];;    // 执行完了进行解锁
    
// 8、_condition
//    if (!_condition) {
//        _condition = [[NSCondition alloc] init];
//    }
//    // 互斥锁：允许同一个线程，对一把锁进行重复加锁，否则不会加锁成功
//    [_condition lock];
//    if (self.count <= 0) {
//        [_condition unlock];   // 注意释放锁，不然由于再次调用，可能出现坏内存访问
//        return;
//    }
//    [self doSomeThing];
//    [_condition unlock];;    // 执行完了进行解锁
    
// 9、_conditionLock
//    if(!_conditionLock){
//        _conditionLock = [[NSConditionLock alloc] initWithCondition:1];
//    }
//
//    [_conditionLock lockWhenCondition:1];
//
//    if (self.count <= 0) {
//        [_conditionLock unlockWithCondition:1];;   // 注意释放锁，不然由于再次调用，可能出现坏内存访问
//        return;
//    }
//    [self doSomeThing];
//
//    [_conditionLock unlockWithCondition:1];
    
// 10、dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(_queue, ^{  // 同步，串行队列
//        if (self.count <= 0) {
//            return;
//        }
//        [self doSomeThing];
//    });
//
//    dispatch_sync(_queue, ^{  // 异步，串行队列
//        if (self.count <= 0) {
//            return;
//        }
//        [self doSomeThing];
//    });
//
// 11、dispatch_semphore_t
//    dispatch_semaphore_wait(_sem, DISPATCH_TIME_FOREVER); // 等待时间永久
//    if (self.count <= 0) {
//        return;
//    }
//    [self doSomeThing];
//    dispatch_semaphore_signal(_sem);
    
//  12、pthread_rwlock_t
//    static pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
//    pthread_rwlock_wrlock(&rwlock);
//    if (self.count <= 0) {
//        return;
//    }
//    [self doSomeThing];
//    pthread_rwlock_unlock(&rwlock);
    
    dispatch_async(_queue, ^{
        // 执行读操作
    });
    
    dispatch_barrier_async(_queue, ^{
        // 执行写操作
    });
}

- (void)doSomeThing{
    NSInteger old = self.count;
    sleep(0.2);
    old--;
    self.count = old;
    NSLog(@"还剩 %ld 张", (long)self.count);
}

// 异步并发执行任务
- (void)testThreadGCD{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf test1];
        
        dispatch_async(queue, ^{
            [strongSelf test2];
        });
    });
}


- (void)testThreadGCD1{
//    dispatch_queue_t   OS_OBJECT_DECL_SUBCLASS(name, dispatch_object)
//    dispatch_queue_global_t   OS_OBJECT_DECL_SUBCLASS(dispatch_queue_global, name)
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf test1];
        
        dispatch_sync(queue, ^{
            [strongSelf test2];
        });
        
        NSLog(@"222");
    });
    
    
//    dispatch_queue_t queue = dispatch_queue_create("CONCURRENT", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [strongSelf test1];
//
//            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//                [strongSelf test2];
//            });
//
//            NSLog(@"222");
//        });
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [strongSelf test3];
//        });
//    });
}

- (void)runlooThread{
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(test)
                                                 object:nil];
    [thread start];

    [self performSelector:@selector(test2) onThread:thread withObject:nil waitUntilDone:NO];
}
- (void)test3{
    NSLog(@"30");
}
- (void)test2{
    NSLog(@"20");
}
- (void)test1{
    NSLog(@"10");
}

- (void)testQueue{
    dispatch_queue_global_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_sync(queue, ^{
//        NSLog(@"1");
//        [self performSelector:@selector(test) withObject:nil afterDelay:0.0];
//        NSLog(@"3");
//    });
// 1,3,2
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(test) withObject:nil afterDelay:0.0];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]]; // 开启子线程runloop进行修复
        NSLog(@"3");
    });
// 1,3，不打印
    
    /* 修复办法是:开启子线程runloop进行修复
     [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
     
     - (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
     这个方法是声明在 runloop类里面的，它的本质，是添加了定时器，既然如此，在子线程有定时器，同时也添加到了runloop，如果要想启动它
     那肯定得开启子线程的runloop才行
     */
}

- (void)test{
    NSLog(@"2");

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    
    NSLog(@"finish");
}

- (void)dealloc{
    NSLog(@"---%s---", __func__);
}

@end
