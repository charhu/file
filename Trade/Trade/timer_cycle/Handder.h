//
//  Handder.h
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HandderDelegate <NSObject>
- (void)testHandder;
@end

typedef void(^handerBlock)(id);
@interface Handder : NSObject
@property (assign, nonatomic) id<HandderDelegate> delegate;  // 方案1：代理
@property (copy, nonatomic) handerBlock block;  // 方案2：block
@property (assign, nonatomic) id forwardObj;    // 方案3：本类实现动态转发
@end
