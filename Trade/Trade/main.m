//
//  main.m
//  Trade
//
//  Created by MacPro on 2020/7/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int sum(int num);
int sumplus(int num);

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    
    NSLog(@"sha1：%lu", (unsigned long)@"7c4a8d09ca3762af61e59520943dc26494f8941b".length);
    NSLog(@"sha224：%lu", (unsigned long)@"f8cdb04495ded47615258f9dc6a3f4707fd2405434fefc3cbf4ef4e6".length);
    NSLog(@"sha256：%lu", (unsigned long)@"8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92".length);
    NSLog(@"sha384：%lu", (unsigned long)@"0a989ebc4a77b56a6e2bb7b19d995d185ce44090c13e2984b7ecc6d446d4b61ea9991b76a4c2f04b1b4d244841449454".length);
    NSLog(@"sha512：%lu", (unsigned long)@"ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413".length);
    
    NSLog(@"求和结果：%d", sumplus(100));
    
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


int sumplus(int num){   // 5.4.3.2.1....
    if (num > 0) {
        return num + sumplus(num - 1);
    }else{
        return 0;
    }
}

int sum(int num){   // 4.3.2.1....
    int result = num;
    while (num > 0) {
        num = num - 1;
        result = result + num;
    }

    return result;
}
