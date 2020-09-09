//
//  Student.h
//  Trade
//
//  Created by MacPro on 2020/8/25.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (assign, nonatomic) int age;
////@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *name;

- (void)testStu;
+ (void)testStuClass;

- (void)test20;
@end

NS_ASSUME_NONNULL_END
