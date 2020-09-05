//
//  Message+Slove.m
//  Trade
//
//  Created by MacPro on 2020/9/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Message+Slove.h"

@implementation Message (Slove)

static NEVER_INLINE IMP resolveMethod_locked(id inst, SEL sel, Class cls, int behavior)
{
    runtimeLock.assertLocked();
    ASSERT(cls->isRealized());

    runtimeLock.unlock();

    if (! cls->isMetaClass()) {
        // try [cls resolveInstanceMethod:sel]
        resolveInstanceMethod(inst, sel, cls);
    }
    else {
        // try [nonMetaClass resolveClassMethod:sel]
        // and [cls resolveInstanceMethod:sel]
        resolveClassMethod(inst, sel, cls);
        if (!lookUpImpOrNil(inst, sel, cls)) {
            resolveInstanceMethod(inst, sel, cls);
        }
    }
    
    // 有可能调用解析器已经填充了缓存，所以尝试使用它
    return lookUpImpOrForward(inst, sel, cls, LOOKUP_CACHE);
}

static void resolveInstanceMethod(id inst, SEL sel, Class cls)
{
    runtimeLock.assertUnlocked();
    ASSERT(cls->isRealized());
    SEL resolve_sel = @selector(resolveInstanceMethod:);

    if (!lookUpImpOrNil(cls, resolve_sel, cls->ISA())) {
        // 解析器没有实现
        return;
    }

    BOOL (*msg)(Class, SEL, SEL) = (typeof(msg))objc_msgSend;
    bool resolved = msg(cls, @selector(resolveInstanceMethod:), sel);
    bool resolved = objc_msgSend(cls, @selector(resolveInstanceMethod:), sel);
    
    // 把缓存结果存下来(YES或NO)，这样解析器下次就不会触发
    // +resolveInstanceMethod adds to self cls
    IMP imp = lookUpImpOrNil(inst, sel, cls);
}

static void resolveClassMethod(id inst, SEL sel, Class cls)
{
    runtimeLock.assertUnlocked();
    ASSERT(cls->isRealized());
    ASSERT(cls->isMetaClass());

    if (!lookUpImpOrNil(inst, @selector(resolveClassMethod:), cls)) {
        // Resolver not implemented.
        return;
    }

    Class nonmeta;
    {
        mutex_locker_t lock(runtimeLock);
        nonmeta = getMaybeUnrealizedNonMetaClass(cls, inst);
        // +initialize path should have realized nonmeta already
        if (!nonmeta->isRealized()) {
            _objc_fatal("nonmeta class %s (%p) unexpectedly not realized",
                        nonmeta->nameForLogging(), nonmeta);
        }
    }
    BOOL (*msg)(Class, SEL, SEL) = (typeof(msg))objc_msgSend;
    bool resolved = msg(nonmeta, @selector(resolveClassMethod:), sel);

    // 把缓存结果存下来(YES或NO)，这样解析器下次就不会触发
    // +resolveClassMethod adds to self->ISA() a.k.a. cls
    IMP imp = lookUpImpOrNil(inst, sel, cls);
}

static inline IMP lookUpImpOrNil(id obj, SEL sel, Class cls, int behavior = 0)
{
    return lookUpImpOrForward(obj, sel, cls, LOOKUP_CACHE | LOOKUP_NIL);
}

@end
