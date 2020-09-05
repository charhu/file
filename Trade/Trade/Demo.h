//
//  Demo.h
//  Trade
//
//  Created by MacPro on 2020/8/7.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Demo : NSObject
//{
//    //默认的 isa 8 字节
//    int _age;     // 4字节
//    int _height;  // 4字节
//    int _no;      // 4字节
//
//    int _age1;    // 4字节
//    int _height1; // 4字节
//    int _no1;     // 4字节
//}
@property (assign, nonatomic) int number;
@property (strong, nonatomic) NSString *name;
@end

NS_ASSUME_NONNULL_END
