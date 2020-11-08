//
//  WeakObject.m
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "WeakObject.h"

@implementation WeakObject

#define  _OBJC_TAG_MASK (1UL<<63)  // iOS平台  0x1000.....
#define  SIDE_TABLE_RC_SHIFT = 2

inline uintptr_t rootRetainCount(){
    if(如果是 TaggedPointer){   // 仅针对 NSString,NSSnumber,NSDate 对象类型
        return 对象整数指针；
    }
    取出对象的 isa.bits
    if(bits.nonpointer 如果为非普通指针){ // 为1，代表是已经优化的isa指针；为0，代表普通指针，存储着Class,MetaClass的内存地址
        uintptr_t rc = 1 + bits.extra_rc;（引用计数-1）
        if(如果sidetable里面是否也存着rc){
            rc = rc + (sidetable.refcnts->second >> SIDE_TABLE_RC_SHIFT);
        }
        return rc；
    }
    return 1 + (table.refcnts->second >> SIDE_TABLE_RC_SHIFT);
}

// 判断对象所指向的地址，转换成整数后 uintptr_t ，在 & 0b01, 是否最高位是1，为1则是TaggedPoint指针，否则是普通内存地址。
static inline bool _objc_isTaggedPointer(const void * _Nullable ptr){
    return ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
}

// arm64 架构
struct {
    uintptr_t nonpointer        : 1;  // BOOL，0:普通指针,只存储着Class,MetaClass对象的内存地址，1:优化过，使用位域存储更多信息
    uintptr_t has_assoc         : 1;  // BOOL，对象是否含有或曾经含有关联引用，如果没有则释放更快
    uintptr_t has_cxx_dtor      : 1;  // BOOL，表示是否有C++析构函数或OC的dealloc，如果没有则释放更快
    uintptr_t shiftcls          : 33; // 存放着 Class、Meta-Class 对象的内存地址信息
    uintptr_t magic             : 6;  // 用于在调试时分辨对象是否未完成初始化
    uintptr_t weakly_referenced : 1;  // BOOL，是否被弱引用指向
    uintptr_t deallocating      : 1;  // BOOL，对象是否正在释放
    uintptr_t has_sidetable_rc  : 1;  // BOOL，是否在 sidetable 也存储着引用计数
    uintptr_t extra_rc          : 19; // 引用计数能够用19个二进制位存储时，直接存储在这里
    // future expansion:
    // uintptr_t fast_rr : 1;     // no r/r overrides
    // uintptr_t lock : 2;        // lock for atomic property, @synchronized
    // uintptr_t extraBytes : 1;  // allocated with extra bytes
};

struct SideTable {
    spinlock_t slock;
    RefcountMap refcnts;
    weak_table_t weak_table;
    SideTable() {
        memset(&weak_table, 0, sizeof(weak_table));
    }
    ~SideTable() {
        _objc_fatal("Do not delete SideTable.");
    }
    void lock() { slock.lock(); }
    void unlock() { slock.unlock(); }
    void forceReset() { slock.forceReset(); }
    template<HaveOld, HaveNew>
    static void lockTwo(SideTable *lock1, SideTable *lock2);
    template<HaveOld, HaveNew>
    static void unlockTwo(SideTable *lock1, SideTable *lock2);
};

struct weak_table_t {
    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};

static objc::ExplicitInit<StripedMap<SideTable>> SideTablesMap;
static StripedMap<SideTable>& SideTables() {
    return SideTablesMap.get();
}
class StripedMap {
    #if TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
        enum { StripeCount = 8 }; // 真手机 8
    #else
        enum { StripeCount = 64 };  // 其他类型均 64
    #endif
    PaddedT array[StripeCount];
}
struct PaddedT {
    T value alignas(CacheLineSize);
};

SideTables ==》SideTablesMap ==》StripedMap<SideTable> ==》SideTables 就是个装满SideTable 元素的数组，表示为 SideTables[SideTable]

typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,RefcountMapValuePurgeable> RefcountMap;


// The address of a __weak variable.
// These pointers are stored disguised so memory analysis tools
// don't see lots of interior pointers from the weak table into objects.
typedef DisguisedPtr<objc_object *> weak_referrer_t;

/**
 * The internal structure stored in the weak references table.
 * It maintains and stores
 * a hash set of weak references pointing to an object.
 * If out_of_line_ness != REFERRERS_OUT_OF_LINE then the set
 * is instead a small inline array.
 */
#define WEAK_INLINE_COUNT 4

struct weak_entry_t {
    DisguisedPtr<objc_object> referent;
    union {
        struct {
            weak_referrer_t *referrers;
            uintptr_t        out_of_line_ness : 2;
            uintptr_t        num_refs : PTR_MINUS_2;
            uintptr_t        mask;
            uintptr_t        max_hash_displacement;
        };
        struct {
            // out_of_line_ness field is low bits of inline_referrers[1]
            weak_referrer_t  inline_referrers[WEAK_INLINE_COUNT];
        };
    };

    bool out_of_line() {
        return (out_of_line_ness == REFERRERS_OUT_OF_LINE);
    }

    weak_entry_t& operator=(const weak_entry_t& other) {
        memcpy(this, &other, sizeof(other));
        return *this;
    }

    weak_entry_t(objc_object *newReferent, objc_object **newReferrer)
        : referent(newReferent)
    {
        inline_referrers[0] = newReferrer;
        for (int i = 1; i < WEAK_INLINE_COUNT; i++) {
            inline_referrers[i] = nil;
        }
    }
};


/**
 * Add new_entry to the object's table of weak references.
 * Does not check whether the referent is already in the table.
 */
static void weak_entry_insert(weak_table_t *weak_table, weak_entry_t *new_entry)
{
    weak_entry_t *weak_entries = weak_table->weak_entries;
    ASSERT(weak_entries != nil);

    size_t begin = hash_pointer(new_entry->referent) & (weak_table->mask);
    size_t index = begin;
    size_t hash_displacement = 0;
    while (weak_entries[index].referent != nil) {
        index = (index+1) & weak_table->mask;
        if (index == begin) bad_weak_table(weak_entries);
        hash_displacement++;
    }

    weak_entries[index] = *new_entry;
    weak_table->num_entries++;

    if (hash_displacement > weak_table->max_hash_displacement) {
        weak_table->max_hash_displacement = hash_displacement;
    }
}

/**
 * Remove entry from the zone's table of weak references.
 */
static void weak_entry_remove(weak_table_t *weak_table, weak_entry_t *entry)
{
    // remove entry
    if (entry->out_of_line()) free(entry->referrers);
    bzero(entry, sizeof(*entry));

    weak_table->num_entries--;

    weak_compact_maybe(weak_table);
}


struct __AtAutoreleasePool {
    __AtAutoreleasePool() {
        atautoreleasepoolobj = objc_autoreleasePoolPush(); // 构造函数，在创建结构体的时候自动调用
    }
    ~__AtAutoreleasePool() {
        objc_autoreleasePoolPop(atautoreleasepoolobj);     // 析构函数，在结构体销毁时候被调用
    }
    void * atautoreleasepoolobj;
};

- (void)testAutoReleasePool(){
    
    @autoreleasepool {
        NSObject *obj = [[NSObject alloc] init];
    }
    
    // 等价于：整个过程就是个入栈的过程，先进后出，FILO，后进先出。
    {
        __AtAutoreleasePool __autoreleasePool;
        atautoreleasepoolobj = objc_autoreleasePoolPush(); ==》 AutoreleasePoolPage::push()
        
        NSObject *obj = [[NSObject alloc] init];
    
        objc_autoreleasePoolPop(atautoreleasepoolobj);  ==》AutoreleasePoolPage::pop(ctxt);
    }
}
    
class AutoreleasePoolPage : private AutoreleasePoolPageData{
    __unsafe_unretained id *next;  // 指向下一个 autorelease 对象的地址
    pthread_t const thread; // 线程
    AutoreleasePoolPage * const parent; // 父指针
    AutoreleasePoolPage *child; // 子指针
    static size_t const SIZE = 4096 // 每个页面大小占用4096字节，即4kB
    static pthread_key_t const key = AUTORELEASE_POOL_KEY;
    static uint8_t const SCRIBBLE = 0xA3;  // 0xA3A3A3A3 after releasing
    static size_t const COUNT = SIZE / sizeof(id); // = 512
    
    static inline id autorelease(id obj){ /* 对外访问接口 */
        autoreleaseFast(obj);
        return obj;
    }
    id *add(id obj){ /* 插入对象 */
        id *ret = page->next;
        *page->next++ = obj; //等价于： page->next + 8字节 = obj;
        return ret;
    }
    static inline id *autoreleaseFast(id obj){
        AutoreleasePoolPage *page = hotPage();
        if (page && !page->full()) { // 获取到了page，并且空间没有满
            return page->add(obj);  // page 存储了obj的地址
        } else if (page) {
            return autoreleaseFullPage(obj, page); // 新的 page 存储了obj的地址
        } else {
            return autoreleaseNoPage(obj); // 内存空间不足，没有内存页可以提供了
        }
    }
    push(){ /* 入栈 */
        return autoreleaseFast(POOL_BOUNDARY); // #define POOL_BOUNDARY nil
    }
    pop(void *token){ /* 出栈 */
        AutoreleasePoolPage *page;
        id *stop;
        if (token == (void*)EMPTY_POOL_PLACEHOLDER) {
            page = hotPage();   // 推出顶层
            if (!page) {
                return setHotPage(nil);
            }
            page = coldPage();
            token = page->begin();
        } else {
            page = pageForPointer(token);
        }
        stop = (id *)token;
        if (*stop != POOL_BOUNDARY) { // #define POOL_BOUNDARY nil
            if (stop == page->begin()  &&  !page->parent) {
            } else {
                return badPop(token);
            }
        }
        if (PrintPoolHiwat) {
            return popPageDebug(token, page, stop);
        }
        return popPage<false>(token, page, stop);
    }
    id * begin() {// 相当于是 pool_boundary 边界的地址 - 1， #define POOL_BOUNDARY nil
        return ((uint8_t *)this + sizeof(*this));
    }
    id * end() {
        return ((uint8_t *)this + SIZE);
    }
}

ALWAYS_INLINE bool objc_object::rootRelease(bool performDealloc, bool handleUnderflow){
    if (isTaggedPointer()) return false;
    bool sideTableLocked = false;
    isa_t oldisa, newisa;
retry:do {
        oldisa = LoadExclusive(&isa.bits);
        newisa = oldisa;
        if (!newisa.nonpointer) {   // 如果是普通指针
            ClearExclusive(&isa.bits);  // 清除占有的
            if (rawISA()->isMetaClass()) return false; // 是元类则直接返回跳出
            return sidetable_release(performDealloc);
        }
        uintptr_t carry; // 不检查 newisa.fast_rr; 我们已经调用了任何 RR 的重写
        newisa.bits = subc(newisa.bits, RC_ONE, 0, &carry);  // extra_rc--, RC_ONE=(1<<45)
        if (carry) {
            goto underflow; /* don't ClearExclusive() */
        }
    } while (!StoreReleaseExclusive(&isa.bits, oldisa.bits, newisa.bits));
    return false;
    
underflow:// newisa.extra_rc : 从sidetable中减去或者释放
    newisa = oldisa;
    if (newisa.has_sidetable_rc) {
        ClearExclusive(&isa.bits); // 将sidetable中的引用计数转换到内联存储，转换 the nonpointer 为 raw pointer
        // 尝试从sidetable中清除引用计数，首先获取应该从 sidetable 的引用计数中减去多少 size_t borrowed = oldRefcnt - (delta_rc << SIDE_TABLE_RC_SHIFT);
        size_t borrowed = sidetable_subExtraRC_nolock(RC_HALF); // RC_HALF=(1ULL<<18)， SIDE_TABLE_RC_SHIFT=2
        // 为了避免冲突，has_sidetable_rc 必须保持，即使 sidetable 引用计数现在是零。
        if (borrowed > 0) {// 减少 Sidetable 的引用计数，尝试将它们添加到内联计数中。
            newisa.extra_rc = borrowed - 1;  // 尝试做减法，并赋值
            bool stored = StoreReleaseExclusive(&isa.bits, oldisa.bits, newisa.bits);
            if (!stored) {// 内联更新失败，再次尝试一次
                isa_t oldisa2 = LoadExclusive(&isa.bits);
                isa_t newisa2 = oldisa2;
                if (newisa2.nonpointer) {
                    uintptr_t overflow;
                    newisa2.bits = addc(newisa2.bits, RC_ONE * (borrowed-1), 0, &overflow);
                    if (!overflow) {
                        stored = StoreReleaseExclusive(&isa.bits, oldisa2.bits, newisa2.bits);
                    }
                }
            }
            if (!stored) { // 如果内联更新失败，则把引用计数放回sidetable
                sidetable_addExtraRC_nolock(borrowed);
                goto retry;  // 再次跳回去重新尝试
            }
            return false;
        }else { /* sidetable是空的*/ }
    }
    if (newisa.deallocating) {     // 真正的释放
        ClearExclusive(&isa.bits);  // 清除占有的
        return overrelease_error(); // 实际上不会返回
    }
    newisa.deallocating = true;
    if (!StoreExclusive(&isa.bits, oldisa.bits, newisa.bits)) goto retry;
    if (performDealloc) {
        ((void(*)(objc_object *, SEL))objc_msgSend)(this, @selector(dealloc));
    }
    return true;
}

uintptr_t objc_object::sidetable_release(bool performDealloc){
    SideTable& table = SideTables()[this];
    bool do_dealloc = false;
    auto it = table.refcnts.try_emplace(this, SIDE_TABLE_DEALLOCATING);
    //字节 1:spinlock_t slock; 字节2:RefcountMap refcnts;， 所以 it 即 refcnts
    auto &refcnt = it.first->second; // auto &refcnt = refcnts->second
    if (it.second) {  // NumEntries，如果有引用记录，there was entry
        do_dealloc = true;
        
    } else if (refcnt < SIDE_TABLE_DEALLOCATING) { // SIDE_TABLE_DEALLOCATING=(1UL<<1)，
        // （refcnt < 2），SIDE_TABLE_WEAKLY_REFERENCED 可能被设置了，不要修改它
        do_dealloc = true;
        refcnt |= SIDE_TABLE_DEALLOCATING;  /* refcnt = refcnt | 0b10 */
        
    } else if (! (refcnt & SIDE_TABLE_RC_PINNED)) {  // WORD_BITS=64，SIDE_TABLE_RC_PINNED=(1UL<<(WORD_BITS-1))
        // !(refcnt & (1<<63)) ==> !(refcnt & 0b100..00) ==>MSB 是0还是1
        refcnt -= SIDE_TABLE_RC_ONE;    // SIDE_TABLE_RC_ONE=(1UL<<2)
        /* refcnt = refcnt - 4 */
    }
    if (do_dealloc  &&  performDealloc) {
        ((void(*)(objc_object *, SEL))objc_msgSend)(this, @selector(dealloc));
    }
    return do_dealloc;
}

@end


static void __CFRunLoopDoObservers(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFRunLoopActivity activity) {    /* DOES CALLOUT */
    CHECK_FOR_FORK();

    CFIndex cnt = rlm->_observers ? CFArrayGetCount(rlm->_observers) : 0;
    if (cnt < 1) return;

    /* Fire the observers */
    STACK_BUFFER_DECL(CFRunLoopObserverRef, buffer, (cnt <= 1024) ? cnt : 1);
    
    CFRunLoopObserverRef *collectedObservers = (cnt <= 1024) ? buffer : (CFRunLoopObserverRef *)malloc(cnt * sizeof(CFRunLoopObserverRef));
    CFIndex obs_cnt = 0;
    for (CFIndex idx = 0; idx < cnt; idx++) {
        CFRunLoopObserverRef rlo = (CFRunLoopObserverRef)CFArrayGetValueAtIndex(rlm->_observers, idx);
        if (0 != (rlo->_activities & activity) && __CFIsValid(rlo) && !__CFRunLoopObserverIsFiring(rlo)) {
            collectedObservers[obs_cnt++] = (CFRunLoopObserverRef)CFRetain(rlo);
        }
    }
    __CFRunLoopModeUnlock(rlm);
    __CFRunLoopUnlock(rl);
    for (CFIndex idx = 0; idx < obs_cnt; idx++) {
        CFRunLoopObserverRef rlo = collectedObservers[idx];
        __CFRunLoopObserverLock(rlo);
        if (__CFIsValid(rlo)) {
            Boolean doInvalidate = !__CFRunLoopObserverRepeats(rlo);
            __CFRunLoopObserverSetFiring(rlo);
            __CFRunLoopObserverUnlock(rlo);
            __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(rlo->_callout, rlo, activity, rlo->_context.info);
            if (doInvalidate) {
                CFRunLoopObserverInvalidate(rlo);
            }
            __CFRunLoopObserverUnsetFiring(rlo);
        } else {
            __CFRunLoopObserverUnlock(rlo);
        }
        CFRelease(rlo);
    }
    __CFRunLoopLock(rl);
    __CFRunLoopModeLock(rlm);

    if (collectedObservers != buffer) free(collectedObservers);
}





// wildcard
1、NSNotificationName == * && ObjectB == *
observe（Selector） // 1

// nameless
2、ObjectB == ObjectA
observe（Selector) + object  // 1

// named
3、NSNotificationName == ’name‘
n =【observe（Selector）+ NSNotificationName || observe（Selector）+ NSNotificationName + object】
m = n；
3.1、
【observe（Selector）+ NSNotificationName + object】    // 1
3.2
【observe（Selector）+ NSNotificationName + nil】 // 1



总结：
if（NSNotificationName == null && ObjectB == null){       // select * from table where NSNotificationName = null && ObjectB = null
    observe（Selector)
}
if（NSNotificationName == null && ObjectB == ObjectA){    // select * from table where NSNotificationName = null && ObjectB = ObjectA
    observe（Selector) + object
}
if（NSNotificationName == ’name‘ && ObjectB == ObjectA){  // select * from table where NSNotificationName = ’name‘ && ObjectB = ObjectA
    observe（Selector）+ NSNotificationName + object
}
if（NSNotificationName == ’name‘ && ObjectB == null){     // select * from table where NSNotificationName = ’name‘ && ObjectB = null
    observe（Selector）+ NSNotificationName
}


// 或者用消息转发
NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
SEL sel = observer.selector;
if ([observer.observer respondsToSelector:sel]) {
    [invocation setTarget:observer.observer];
    [invocation setSelector:sel];
    [invocation setArgument:&notification atIndex:2];
    [invocation invoke];
}


总结：
if（NSNotificationName == null && ObjectB == null){
    wildcard 通配符链表  【observe（Selector)】
}
if（NSNotificationName == null){
    named 整表
    while(){
        if(object == null){
            remove(by observer); 【observe（Selector）+ NSNotificationName】
            remove(by observer); 【observe（Selector）+ NSNotificationName + object】
        }else {
            remove(by observer); 【observe（Selector）+ NSNotificationName + object】
        }
    }
    nameless 整表
    if(object == null){
        while(){
            remove(by observer); 【observe（Selector） + *任意obj】
        }
    }else {
        remove(by observer); 【observe（Selector） + object】
    }
    
}else {
    在 named 整表 指定name 的数据
   if(object == null){
       while(){
           remove(by observer); 【observe（Selector）+ NSNotificationName】
           remove(by observer); 【observe（Selector）+ NSNotificationName + *任意obj】
       }
   }else {
       remove(by observer); 【observe（Selector）+ NSNotificationName + object】
   }
}



typedef struct _NSNotificationQueueRegistration{
  struct _NSNotificationQueueRegistration    *next;
  struct _NSNotificationQueueRegistration    *prev;
  NSNotification                *notification;
  id                            name;
  id                            object;
  NSArray                       *modes;
} NSNotificationQueueRegistration;

typedef struct _NSNotificationQueueList{
  struct _NSNotificationQueueRegistration    *head;
  struct _NSNotificationQueueRegistration    *tail;
}

enum NSNotificationCoalescing{  // 筛选方式
  NSNotificationNoCoalescing = 0,           // 不筛选
  NSNotificationCoalescingOnName = 1,       // 根据相同name 筛选
  NSNotificationCoalescingOnSender = 2      // 根据相同object 筛选
};

enum NSPostingStyle{  // 发送策略
  NSPostWhenIdle = 1, // 当runloop处于空闲状态时，立即post
  NSPostASAP = 2,     // 当前runloop完成之后,立即post
  NSPostNow = 3       // 立即post
};

struct _NSNotificationQueueList *_asapQueue = NSZoneCalloc(_zone, 1, sizeof(NSNotificationQueueList));
struct _NSNotificationQueueList *_idleQueue = NSZoneCalloc(_zone, 1, sizeof(NSNotificationQueueList));

// 删除规则：
if(notificationname = ’name‘ && object = 'object'){
    if (( [name isEqual: item->name] && object == item->object) )
        remove_from_queue(_asapQueue, item, _zone);
        remove_from_queue(_idleQueue, item, _zone);
    }
    
}else if(notificationname = ’name‘){
    if (( [name isEqual: item->name]) )
        remove_from_queue(_asapQueue, item, _zone);
        remove_from_queue(_idleQueue, item, _zone);
    }
    
}else if(object = 'object'){
    if (( object == item->object) )
        remove_from_queue(_asapQueue, item, _zone);
        remove_from_queue(_idleQueue, item, _zone);
    }

}else {
// 不合并
}




>>> po [NSRunLoop mainRunLoop]
<CFRunLoop 0x60000317c100 [0x7fff8062d750]>{wakeup port = 0x2903, stopped = false, ignoreWakeUps = false,
current mode = kCFRunLoopDefaultMode,
common modes = <CFBasicHash 0x60000032d380 [0x7fff8062d750]>{type = mutable set, count = 2,
entries =>
    0 : <CFString 0x7fff869c52a0 [0x7fff8062d750]>{contents = "UITrackingRunLoopMode"}
    2 : <CFString 0x7fff80640a20 [0x7fff8062d750]>{contents = "kCFRunLoopDefaultMode"}
}
2 : <CFRunLoopMode 0x600003674270 [0x7fff8062d750]>{name = UITrackingRunLoopMode}
    sources0：
            <CFRunLoopSource context>：callout = PurpleEventSignalCallback   // 事件信号回调
            <CFRunLoopSource context>：callout = __handleEventQueue          // 处理事件队列
            <CFRunLoopSource context>：callout = __handleHIDEventFetcherDrain        // HID(Human Interface Device), 处理用户交互事件
            <CFRunLoopSource context>：callout = FBSSerialQueueRunLoopSourceHandler  // FBS(forward-basedsystem)，处理基于前向系统的串行队列运行循环源
    sources1：
            <CFRunLoopSource context>：callout = PurpleEventCallback     // CoreFoundation层和UIKit层之间的事件桥梁。
            <CFRunLoopSource MIG Server> {port = 17163}                  /* MIG(Mach Interface Generator)，Mach接口生成器(MIG)是一个IDL编译器。基于接口定义，它创建存根代码来调用对象方法和对传入的消息进行多路复用。这些存根函数方便地隐藏了Mach的IPC和端口机制的细节，
                                                                          使得实现和使用Mach接口作为远程过程调用(RPC)变得容易:通过使用存根函数，客户端程序可以或多或少地像其他C函数一样调用远程过程。*/
    /* Mach是一个由卡内基梅隆大学开发的用于支持操作系统研究的操作系统内核。该项目在1985年启动，并且在1994年因为mach3.0的显著失败而告终。但是mach却是一个真正的微核。mach被开发成了UNIX中BSD的替代内核。Mac OS X（使用XNU核心）都是使用Mach或其派生系统 */
    observers：
            activities = 0x01，callout = _wrapRunLoopWithAutoreleasePoolHandler // 监视即将进入Loop，调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
            activities = 0x20，callout = _UIGestureRecognizerUpdateObserver  // 手势更新
            activities = 0xa0，callout = _beforeCACommitHandler  // 页面转场切换提交前
            activities = 0xa0，callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv   // UI更新
            activities = 0xa0，callout = _afterCACommitHandler   // 页面转场切换提交后
            activities = 0xa0，callout = _wrapRunLoopWithAutoreleasePoolHandler /* 监视了两个事件：
    1）BeforeWaiting(准备进入休眠) 时调用 _objc_autoreleasePoolPop() 释放旧池和 _objc_autoreleasePoolPush() 创建新池；
    2）Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。*/
    timers：
            </QuartzCore.framework/QuartzCore> callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv  // // 遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面
3 : <CFRunLoopMode 0x600003674340 [0x7fff8062d750]>{name = GSEventReceiveRunLoopMode}
    sources0：
            <CFRunLoopSource context>：callout = PurpleEventSignalCallback
    sources1：
            <CFRunLoopSource context>：callout = PurpleEventCallback     // CoreFoundation层和UIKit层之间的事件桥梁。
    observers：null
    timers：null
4 : <CFRunLoopMode 0x60000367c0d0 [0x7fff8062d750]>{name = kCFRunLoopDefaultMode}
    sources0：
            <CFRunLoopSource context>：callout = PurpleEventSignalCallback   // 事件信号回调
            <CFRunLoopSource context>：callout = __handleEventQueue          // 处理事件队列
            <CFRunLoopSource context>：callout = __handleHIDEventFetcherDrain        // HID(Human Interface Device), 处理用户交互事件
            <CFRunLoopSource context>：callout = FBSSerialQueueRunLoopSourceHandler  // FBS(forward-basedsystem)，处理基于前向系统的串行队列运行循环源
    sources1：
            <CFRunLoopSource context>：callout = PurpleEventCallback     // CoreFoundation层和UIKit层之间的事件桥梁。
            <CFRunLoopSource MIG Server> {port = 17163}                  /* MIG(Mach Interface Generator)，Mach接口生成器(MIG)是一个IDL编译器。跟Mach 内核打交道 */
    observers：
            activities = 0x01，callout = _wrapRunLoopWithAutoreleasePoolHandler // 监视即将进入Loop，调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
            activities = 0x20，callout = _UIGestureRecognizerUpdateObserver     // 手势更新
            activities = 0xa0，callout = _beforeCACommitHandler                 // 页面转场切换提交前
            activities = 0xa0，callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv   // UI更新
            activities = 0xa0，callout = _afterCACommitHandler                                              // 页面转场切换提交后
            activities = 0xa0，callout = _wrapRunLoopWithAutoreleasePoolHandler /* 监视了两个事件：BeforeWaiting(准备进入休眠)，Exit(即将退出Loop)*/
    timers：
            </QuartzCore.framework/QuartzCore> callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv  // // 遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面
5 : <CFRunLoopMode 0x60000365bcf0 [0x7fff8062d750]>{name = kCFRunLoopCommonModes}
    sources0：null
    sources1：null
    observers：null
    timers：null

    
    



<CFRunLoop 0x600001350200 [0x7fff8062d750]>{wakeup port = 0x1c03, stopped = false, ignoreWakeUps = false,
current mode = kCFRunLoopDefaultMode,
common modes = <CFBasicHash 0x6000021033c0 [0x7fff8062d750]>{type = mutable set, count = 2,
entries =>
    0 : <CFString 0x7fff869c52a0 [0x7fff8062d750]>{contents = "UITrackingRunLoopMode"}
    2 : <CFString 0x7fff80640a20 [0x7fff8062d750]>{contents = "kCFRunLoopDefaultMode"}
}
,
common mode items = <CFBasicHash 0x60000211fb10 [0x7fff8062d750]>{type = mutable set, count = 13,
entries =>
    0 : <CFRunLoopSource 0x600001a54300 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x0, callout = PurpleEventSignalCallback (0x7fff38c3a9b2)}}
    1 : <CFRunLoopSource 0x600001a58840 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource MIG Server> {port = 24587, subsystem = 0x7fff81f8dd28, context = 0x600000b5d260}}
    3 : <CFRunLoopSource 0x600001a58540 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x600000b55b60, callout = FBSSerialQueueRunLoopSourceHandler (0x7fff36d82bd5)}}
    4 : <CFRunLoopObserver 0x600001e58820 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2000000, callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv (0x7fff2b477daa), context = <CFRunLoopObserver context 0x0>}
    6 : <CFRunLoopSource 0x600001a500c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 1, info = 0x2f03, callout = PurpleEventCallback (0x7fff38c3a9be)}}
    7 : <CFRunLoopObserver 0x600001e54140 [0x7fff8062d750]>{valid = Yes, activities = 0x20, repeats = Yes, order = 0, callout = _UIGestureRecognizerUpdateObserver (0x7fff48eaa99e), context = <CFRunLoopObserver context 0x60000045cc40>}
    8 : <CFRunLoopSource 0x600001a50240 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x600001458410, callout = __handleEventQueue (0x7fff493c2e6e)}}
    12 : <CFRunLoopSource 0x600001a503c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -2, context = <CFRunLoopSource context>{version = 0, info = 0x60000214a130, callout = __handleHIDEventFetcherDrain (0x7fff493c2edd)}}
    14 : <CFRunLoopObserver 0x600001e5c6e0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (
    0 : <0x7f865d809048>)}}
    15 : <CFRunLoopObserver 0x600001e5c640 [0x7fff8062d750]>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (
    0 : <0x7f865d809048>)}}
    16 : <CFRunLoopObserver 0x600001e5c5a0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2001000, callout = _afterCACommitHandler (0x7fff4934fab8), context = <CFRunLoopObserver context 0x7f865bc047b0>}
    19 : <CFRunLoopObserver 0x600001e5c3c0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 1999000, callout = _beforeCACommitHandler (0x7fff4934fa4f), context = <CFRunLoopObserver context 0x7f865bc047b0>}
    21 : <CFRunLoopTimer 0x600001a5ca80 [0x7fff8062d750]>{valid = Yes, firing = No, interval = 3.1536e+09, tolerance = 0, next fire date = 1.12692956e+09 (504910756 @ 506268574646827061), callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv (0x7fff2b478139 / 0x7fff2b478139) (/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/QuartzCore.framework/QuartzCore), context = <CFRunLoopTimer context 0x0>}
}
,
modes = <CFBasicHash 0x600002103480 [0x7fff8062d750]>{type = mutable set, count = 4,
entries =>
    2 : <CFRunLoopMode 0x60000145c1a0 [0x7fff8062d750]>{name = UITrackingRunLoopMode, port set = 0x2c03, queue = 0x600000159b00, source = 0x600000159c00 (not fired), timer port = 0x5103,
    sources0 = <CFBasicHash 0x60000211fb70 [0x7fff8062d750]>{type = mutable set, count = 4,
entries =>
    0 : <CFRunLoopSource 0x600001a54300 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x0, callout = PurpleEventSignalCallback (0x7fff38c3a9b2)}}
    1 : <CFRunLoopSource 0x600001a50240 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x600001458410, callout = __handleEventQueue (0x7fff493c2e6e)}}
    2 : <CFRunLoopSource 0x600001a503c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -2, context = <CFRunLoopSource context>{version = 0, info = 0x60000214a130, callout = __handleHIDEventFetcherDrain (0x7fff493c2edd)}}
    6 : <CFRunLoopSource 0x600001a58540 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x600000b55b60, callout = FBSSerialQueueRunLoopSourceHandler (0x7fff36d82bd5)}}
}
,
    sources1 = <CFBasicHash 0x60000211fba0 [0x7fff8062d750]>{type = mutable set, count = 2,
entries =>
    0 : <CFRunLoopSource 0x600001a58840 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource MIG Server> {port = 24587, subsystem = 0x7fff81f8dd28, context = 0x600000b5d260}}
    2 : <CFRunLoopSource 0x600001a500c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 1, info = 0x2f03, callout = PurpleEventCallback (0x7fff38c3a9be)}}
}
,
    observers = (
    "<CFRunLoopObserver 0x600001e5c640 [0x7fff8062d750]>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7f865d809048>\n)}}",
    "<CFRunLoopObserver 0x600001e54140 [0x7fff8062d750]>{valid = Yes, activities = 0x20, repeats = Yes, order = 0, callout = _UIGestureRecognizerUpdateObserver (0x7fff48eaa99e), context = <CFRunLoopObserver context 0x60000045cc40>}",
    "<CFRunLoopObserver 0x600001e5c3c0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 1999000, callout = _beforeCACommitHandler (0x7fff4934fa4f), context = <CFRunLoopObserver context 0x7f865bc047b0>}",
    "<CFRunLoopObserver 0x600001e58820 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2000000, callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv (0x7fff2b477daa), context = <CFRunLoopObserver context 0x0>}",
    "<CFRunLoopObserver 0x600001e5c5a0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2001000, callout = _afterCACommitHandler (0x7fff4934fab8), context = <CFRunLoopObserver context 0x7f865bc047b0>}",
    "<CFRunLoopObserver 0x600001e5c6e0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7f865d809048>\n)}}"
),
    timers = <CFArray 0x600000b5e040 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (
    0 : <CFRunLoopTimer 0x600001a5ca80 [0x7fff8062d750]>{valid = Yes, firing = No, interval = 3.1536e+09, tolerance = 0, next fire date = 1.12692956e+09 (504910756 @ 506268574646827061), callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv (0x7fff2b478139 / 0x7fff2b478139) (/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/QuartzCore.framework/QuartzCore), context = <CFRunLoopTimer context 0x0>}
)},
    currently 622018808 (1357819033464337) / soft deadline in: 504910756 sec (@ 506268574646827061) / hard deadline in: 504910756 sec (@ 506268574646827061)
},

    3 : <CFRunLoopMode 0x60000145c270 [0x7fff8062d750]>{name = GSEventReceiveRunLoopMode, port set = 0x2d03, queue = 0x600000159c80, source = 0x600000159d80 (not fired), timer port = 0x5003,
    sources0 = <CFBasicHash 0x60000211fc30 [0x7fff8062d750]>{type = mutable set, count = 1,
entries =>
    0 : <CFRunLoopSource 0x600001a54300 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x0, callout = PurpleEventSignalCallback (0x7fff38c3a9b2)}}
}
,
    sources1 = <CFBasicHash 0x60000211fc60 [0x7fff8062d750]>{type = mutable set, count = 1,
entries =>
    2 : <CFRunLoopSource 0x600001a50180 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 1, info = 0x2f03, callout = PurpleEventCallback (0x7fff38c3a9be)}}
}
,
    observers = (null),
    timers = (null),
    currently 622018808 (1357819035352525) / soft deadline in: 1.84453863e+10 sec (@ -1) / hard deadline in: 1.84453863e+10 sec (@ -1)
},

    4 : <CFRunLoopMode 0x6000014541a0 [0x7fff8062d750]>{name = kCFRunLoopDefaultMode, port set = 0x2003, queue = 0x600000151680, source = 0x600000151780 (not fired), timer port = 0x1e03,
    sources0 = <CFBasicHash 0x60000211fbd0 [0x7fff8062d750]>{type = mutable set, count = 4,
entries =>
    0 : <CFRunLoopSource 0x600001a54300 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x0, callout = PurpleEventSignalCallback (0x7fff38c3a9b2)}}
    1 : <CFRunLoopSource 0x600001a50240 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 0, info = 0x600001458410, callout = __handleEventQueue (0x7fff493c2e6e)}}
    2 : <CFRunLoopSource 0x600001a503c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -2, context = <CFRunLoopSource context>{version = 0, info = 0x60000214a130, callout = __handleHIDEventFetcherDrain (0x7fff493c2edd)}}
    6 : <CFRunLoopSource 0x600001a58540 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource context>{version = 0, info = 0x600000b55b60, callout = FBSSerialQueueRunLoopSourceHandler (0x7fff36d82bd5)}}
}
,
    sources1 = <CFBasicHash 0x60000211fc00 [0x7fff8062d750]>{type = mutable set, count = 2,
entries =>
    0 : <CFRunLoopSource 0x600001a58840 [0x7fff8062d750]>{signalled = No, valid = Yes, order = 0, context = <CFRunLoopSource MIG Server> {port = 24587, subsystem = 0x7fff81f8dd28, context = 0x600000b5d260}}
    2 : <CFRunLoopSource 0x600001a500c0 [0x7fff8062d750]>{signalled = No, valid = Yes, order = -1, context = <CFRunLoopSource context>{version = 1, info = 0x2f03, callout = PurpleEventCallback (0x7fff38c3a9be)}}
}
,
    observers = (
    "<CFRunLoopObserver 0x600001e5c640 [0x7fff8062d750]>{valid = Yes, activities = 0x1, repeats = Yes, order = -2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7f865d809048>\n)}}",
    "<CFRunLoopObserver 0x600001e54140 [0x7fff8062d750]>{valid = Yes, activities = 0x20, repeats = Yes, order = 0, callout = _UIGestureRecognizerUpdateObserver (0x7fff48eaa99e), context = <CFRunLoopObserver context 0x60000045cc40>}",
    "<CFRunLoopObserver 0x600001e5c3c0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 1999000, callout = _beforeCACommitHandler (0x7fff4934fa4f), context = <CFRunLoopObserver context 0x7f865bc047b0>}",
    "<CFRunLoopObserver 0x600001e58820 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2000000, callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv (0x7fff2b477daa), context = <CFRunLoopObserver context 0x0>}",
    "<CFRunLoopObserver 0x600001e5c5a0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2001000, callout = _afterCACommitHandler (0x7fff4934fab8), context = <CFRunLoopObserver context 0x7f865bc047b0>}",
    "<CFRunLoopObserver 0x600001e5c6e0 [0x7fff8062d750]>{valid = Yes, activities = 0xa0, repeats = Yes, order = 2147483647, callout = _wrapRunLoopWithAutoreleasePoolHandler (0x7fff4931eaa4), context = <CFArray 0x600002109020 [0x7fff8062d750]>{type = mutable-small, count = 1, values = (\n\t0 : <0x7f865d809048>\n)}}"
),
    timers = <CFArray 0x600000b55860 [0x7fff8062d750]>{type = mutable-small, count = 2, values = (
    0 : <CFRunLoopTimer 0x600001a5c240 [0x7fff8062d750]>{valid = Yes, firing = No, interval = 1, tolerance = 0, next fire date = 622018753 (-54.9646851 @ 1357764074845101), callout = (NSTimer) [_NSTimerBlockTarget fire:] (0x7fff259774e6 / 0x7fff25976be2) (/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation), context = <CFRunLoopTimer context 0x600002f36d00>}
    1 : <CFRunLoopTimer 0x600001a5ca80 [0x7fff8062d750]>{valid = Yes, firing = No, interval = 3.1536e+09, tolerance = 0, next fire date = 1.12692956e+09 (504910756 @ 506268574646827061), callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv (0x7fff2b478139 / 0x7fff2b478139) (/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/QuartzCore.framework/QuartzCore), context = <CFRunLoopTimer context 0x0>}
)},
    currently 622018808 (1357819035404028) / soft deadline in: 1.8446744e+10 sec (@ 1357764074845101) / hard deadline in: 1.8446744e+10 sec (@ 1357764074845101)
},

    5 : <CFRunLoopMode 0x60000147b5a0 [0x7fff8062d750]>{name = kCFRunLoopCommonModes, port set = 0x610f, queue = 0x60000015b500, source = 0x60000015a580 (not fired), timer port = 0x5d13,
    sources0 = (null),
    sources1 = (null),
    observers = (null),
    timers = (null),
    currently 622018808 (1357819038059097) / soft deadline in: 1.84453863e+10 sec (@ -1) / hard deadline in: 1.84453863e+10 sec (@ -1)
},

}
}
