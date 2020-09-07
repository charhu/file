//
//  NSObject+Execption.h
//  Trade
//
//  Created by MacPro on 2020/9/4.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Execption)

+ (NSMethodSignature *)customMethodSignatureForSelector:(SEL)aSelector;
+ (void)customForwardInvocation:(NSInvocation *)invocation;

- (NSMethodSignature *)customMethodSignatureForSelector:(SEL)aSelector;
- (void)customForwardInvocation:(NSInvocation *)invocation;
@end

NS_ASSUME_NONNULL_END
