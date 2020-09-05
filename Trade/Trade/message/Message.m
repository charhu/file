//
//  Message.m
//  Trade
//
//  Created by MacPro on 2020/9/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Message.h"

@implementation Message

void _objc_msgSend(id recevier, SEL sel){
    
    // LNilReceiver_f
    if (recevier == nil) {
        return;
    }
    
    // GetClassFromIsa
    Class isa = recevier->isa;
    // 如果 recevier 是实例对象，则返回类对象，如果是类对象，则返回元类对象
    
    // 通过isa，得到类对象，或者元类，去查询Cache缓存buckets, index = sel & mask，
    // CacheLookup：根据 CacheLookup2 以及传入sel 找到的bucket，得到imp
    // CacheLookup2：主要作用是根据传入的sel找到 sel的bucket
    int index = sel & mask
    imp = bucket->imp
    if (imp) {
        return;
    }
    
    //执行 __objc_msgSend_uncached 下面的 MethodTableLookup 下面的 lookUpImpOrForward
    // 搜索方法列表，尝试方法解析器，等等。
    lookUpImpOrForward(obj, sel, cls, LOOKUP_INITIALIZE | LOOKUP_RESOLVER)
}
/* method lookup */
enum {
    LOOKUP_INITIALIZE = 1,
    LOOKUP_RESOLVER = 2,
    LOOKUP_CACHE = 4,
    LOOKUP_NIL = 8,
};

IMP cache_getImp(Class cls, SEL sel){
    // CacheLookup
    int index = sel & mask
    
    // CacheLookup2
    if (bucket->sel == 1) {
        cache wrap;
        return;
    }
    
    if (bucket->sel == 0) {
        cache miss;
    }
}

IMP lookUpImpOrForward(id inst, SEL sel, Class cls, int behavior)
{
    const IMP forward_imp = (IMP)_objc_msgForward_impcache;
    IMP imp = nil;
    Class curClass;

    runtimeLock.assertUnlocked();

    //快速的缓存查找
    if (fastpath(behavior & LOOKUP_CACHE)) {
        imp = cache_getImp(cls, sel);
        if (imp) goto done_nolock;
    }
   // runtimeLock在isrealize和isInitialized检查期间被保持，以防止与并发实现竞争。

    /* runtimeLock在方法搜索期间进行，使方法查找+缓存填充相对于方法添加具有原子性。否则，
     可能会添加一个类别，但会无限期地忽略它，因为在缓存刷新后会用旧值重新填充缓存。*/

    runtimeLock.lock();

    /* 我们不希望人们能够创建一个看起来像类但实际上不是类的二进制blob，并进行CFI攻击。
       为了使这些更困难，我们想要确保这是一个类，它要么内建在二进制文件中，要么通过
       objc_duplicateClass、objc_initializeClassPair或objc_allocateClassPair合法注册。
     待办事项:这个检查在进程启动过程中非常重要。*/
    checkIsKnownClass(cls);

    if (slowpath(!cls->isRealized())) {
        cls = realizeClassMaybeSwiftAndLeaveLocked(cls, runtimeLock);
        // runtimeLock可能已被删除，但现在再次锁定
    }

    if (slowpath((behavior & LOOKUP_INITIALIZE) && !cls->isInitialized())) {
        cls = initializeAndLeaveLocked(cls, inst, runtimeLock);
        // runtimeLock可能已被删除，但现在再次锁定
        
        /* 如果sel == initialize，则class_initialize将发送+initialize，
        然后messenger在此过程结束后再次发送+initialize。当然，如果这不是被messenger调用，
        那么它不会发生。*/
    }

    runtimeLock.assertLocked();
    curClass = cls;

    // 在我们锁定之后，用于再次查找类缓存的代码，但对于大多数情况，证据显示这在大多数时候都是缺失的，因此是时间损失。
    
    // 在没有执行某种缓存查找的情况下调用这个函数的唯一代码路径是class_getInstanceMethod()。
    for (unsigned attempts = unreasonableClassCount();;) {
        // 当前类方法列表
        Method meth = getMethodNoSuper_nolock(curClass, sel);
        if (meth) {
            imp = meth->imp;
            goto done;
        }

        if (slowpath((curClass = curClass->superclass) == nil)) {
            // 没有找到实现，并且动态解析没有帮助，那么就使用forwarding转发
            imp = forward_imp;
            break;
        }

        // 如果父类链中存在循环，则停止。
        if (slowpath(--attempts == 0)) {
            _objc_fatal("Memory corruption in class list.");
        }

        // 父类的缓存
        imp = cache_getImp(curClass, sel);
        if (slowpath(imp == forward_imp)) {
            //在父类中发现一个forward::条目。停止搜索，但还没有缓存;首先调用该类的方法解析器。
            break;
        }
        if (fastpath(imp)) {
            // 在父类中找到该方法。在这个类中缓存它。
            goto done;
        }
    }

    // 没有找到实现，则尝试一次动态解析
    if (slowpath(behavior & LOOKUP_RESOLVER)) {
        behavior ^= LOOKUP_RESOLVER;
        return resolveMethod_locked(inst, sel, cls, behavior);
    }

 done:
    // 在任何类中找到该方法。就在这个类中缓存它。
    log_and_fill_cache(cls, imp, sel, inst, curClass);
    runtimeLock.unlock();
 done_nolock:
    
    if (slowpath((behavior & LOOKUP_NIL) && imp == forward_imp)) {
        return nil;
    }
    return imp;
}

static method_t *getMethodNoSuper_nolock(Class cls, SEL sel)
{
    runtimeLock.assertLocked();

    ASSERT(cls->isRealized());
    // fixme nil cls?
    // fixme nil sel?
    /*
     class_rw_t* data() const {
         return (class_rw_t *)(bits & FAST_DATA_MASK);
     }
     
     struct class_rw_ext_t {
        const class_ro_t *ro;
        method_array_t methods;
     }
     
     class list_array_tt {
         List* const * beginLists() const {
             if (hasArray()) {
                 return array()->lists;
             } else {
                 return &list;
             }
         }
         List* const * endLists() const {
             if (hasArray()) {
                 return array()->lists + array()->count;
             } else if (list) {
                 return &list + 1;
             } else {
                 return &list;
             }
         }
     }
     */
    class_rw_t* data = cls->data();
    auto const methods = (class_rw_t)->methods();
    
    auto const methods = cls->data()->methods();
    for (auto mlists = methods.beginLists(),
              end = methods.endLists();
         mlists != end;
         ++mlists)
    {
        // <rdar://problem/46904873> getMethodNoSuper_nolock is the hottest
        // caller of search_method_list, inlining it turns
        // getMethodNoSuper_nolock into a frame-less function and eliminates
        // any store from this codepath.
        method_t *m = search_method_list_inline(*methods.list, sel);
        if (m) return m;
    }

    return nil;
}

ALWAYS_INLINE static method_t *
search_method_list_inline(const method_list_t *mlist, SEL sel)
{
    int methodListIsFixedUp = mlist->isFixedUp();
    int methodListHasExpectedSize = mlist->entsize() == sizeof(method_t);
    
    if (fastpath(methodListIsFixedUp && methodListHasExpectedSize)) {
        return findMethodInSortedMethodList(sel, mlist);
    } else {
        // Linear search of unsorted method list
        for (auto& meth : *mlist) {
            if (meth.name == sel) return &meth;
        }
    }

#if DEBUG
    // sanity-check negative results
    if (mlist->isFixedUp()) {
        for (auto& meth : *mlist) {
            if (meth.name == sel) {
                _objc_fatal("linear search worked when binary search did not");
            }
        }
    }
#endif

    return nil;
}

ALWAYS_INLINE static method_t *
findMethodInSortedMethodList(SEL key, const method_list_t *list)
{
    ASSERT(list);

    const method_t * const first = &list->first;
    const method_t *base = first;
    const method_t *probe;
    uintptr_t keyValue = (uintptr_t)key;
    uint32_t count;
    
    for (count = list->count; count != 0; count >>= 1) {
        probe = base + (count >> 1);
        
        uintptr_t probeValue = (uintptr_t)probe->name;
        
        if (keyValue == probeValue) {
            // `probe` is a match.
            // Rewind looking for the *first* occurrence of this value.
            // This is required for correct category overrides.
            while (probe > first && keyValue == (uintptr_t)probe[-1].name) {
                probe--;
            }
            return (method_t *)probe;
        }
        
        if (keyValue > probeValue) {
            base = probe + 1;
            count--;
        }
    }
    
    return nil;
}

@end
