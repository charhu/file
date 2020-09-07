//
//  KvoMessage.h
//  Trade
//
//  Created by MacPro on 2020/8/28.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KvoMessage : NSObject
{
    @public
    int _count;
    NSString *_name;
}
@property (strong, nonatomic) NSString *number;

+ (void)test;
- (void)resolveInstanceMethodDynamically;
+ (void)resolveClassMethodDynamically;

- (void)demo1;
+ (void)demo2;

- (void)demo3;
+ (void)demo4;

- (void)demo5;
+ (void)demo6;
@end

NS_ASSUME_NONNULL_END
