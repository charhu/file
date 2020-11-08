//
//  NSObject+Language.h
//  Trade
//
//  Created by MacPro on 2020/10/14.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Language)

+ (void)setLanguageCode:(BOOL)isEnglish;
+ (NSString *)getLanguageCode;
+ (NSString *)getLanguageOfKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
