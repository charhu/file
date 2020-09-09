//
//  Son.h
//  Trade
//
//  Created by MacPro on 2020/9/4.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Son : Student

- (void)logClass;

- (void)classMember;
- (void)instanceMember;

+ (void)test1;
- (void)test2;
@end

NS_ASSUME_NONNULL_END
