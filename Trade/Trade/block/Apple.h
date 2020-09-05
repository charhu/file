//
//  Apple.h
//  Trade
//
//  Created by MacPro on 2020/9/1.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AppleBlock)(void);
@interface Apple : NSObject
{
    @public
    int _age;
}
@property (assign, nonatomic) NSInteger number;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) AppleBlock block;
@property (strong, nonatomic) AppleBlock demoBlock;

- (void)test;
- (void)click1;
- (void)click2;
- (void)click3;

+ (void)click4;
@end

NS_ASSUME_NONNULL_END
