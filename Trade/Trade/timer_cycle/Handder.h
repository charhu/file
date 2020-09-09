//
//  Handder.h
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HandderDelegate <NSObject>

- (void)testHandder;

@end

typedef void(^handerBlock)(id);

@interface Handder : NSObject

@property (assign, nonatomic) id<HandderDelegate> delegate;
@property (copy, nonatomic) handerBlock block;

@property (assign, nonatomic) id forwardObj;

@end

NS_ASSUME_NONNULL_END
