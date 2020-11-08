//
//  CopyStr.h
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CopyStr : NSObject

@property (copy, nonatomic) NSString *name;

+ (void)testCopy;
@end

NS_ASSUME_NONNULL_END
