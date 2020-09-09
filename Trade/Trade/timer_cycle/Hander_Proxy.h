//
//  Hander_Proxy.h
//  Trade
//
//  Created by MacPro on 2020/9/9.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hander_Proxy : NSProxy
@property (assign, nonatomic) id forwardObj;
@end

NS_ASSUME_NONNULL_END
