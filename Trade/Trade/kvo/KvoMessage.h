//
//  KvoMessage.h
//  Trade
//
//  Created by MacPro on 2020/8/28.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NSObjectBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface KvoMessage : NSObjectBase
{
    @public
    int _count;
    NSString *_name;
}
@property (strong, nonatomic) NSString *number;

+ (void)test;
- (void)resolveThisMethodDynamically;
+ (void)resolveThisClassMethodDynamically;

- (void)demo1;
+ (void)demo2;

- (void)demo3;
+ (void)demo4;

- (void)demo5;
+ (void)demo6;
@end

NS_ASSUME_NONNULL_END
