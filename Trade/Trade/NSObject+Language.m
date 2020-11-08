//
//  NSObject+Language.m
//  Trade
//
//  Created by MacPro on 2020/10/14.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "NSObject+Language.h"

@implementation NSObject (Language)

+ (void)setLanguageCode:(BOOL)isEnglish{
    [[NSUserDefaults standardUserDefaults] setObject:(isEnglish ? @"en" : @"zh-Hans") forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLanguageCode{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    return language ? language : @"en";
}

+ (NSString *)getLanguageOfKey:(NSString *)key {
    NSString *code = [self getLanguageCode];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:code ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
    if (!languageBundle) {
        NSLog(@"语言文件找不到");
    }
    // The receiver’s string table to search. If table is nil or is an empty string, the method attempts to use the table in Localizable.strings.
    NSString *string = [languageBundle localizedStringForKey:key value:@"" table:nil];
    if (string.length < 1) {
        string = NSLocalizedStringWithDefaultValue(key, nil, languageBundle, key, key);
    }
    return string;
}

@end

