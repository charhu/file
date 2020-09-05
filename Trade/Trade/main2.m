//
//  Child.m
//  Trade
//
//  Created by MacPro on 2020/7/31.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <objc/runtime.h>
#include <malloc/malloc.h>

typedef struct Link{
    char elem;
    struct Link* next;
}node;

int main(int argc, char *argv[]){
    
    @autoreleasepool {
        int i = 257;
//        for (int i = 1; i <= 257; i++) {
//            int *p = (int *)malloc(i);
//            printf("i：%d  size：%ld \n", i, malloc_size(p));
//            free(p);
//        }
        
        
//        for (int num = 1; num <= 257; num ++) {
//
//            int size = (num % 16 == 0)? num : num / 16 * 16 + 16;
//
//            printf("num：%d  size：%d \n", num, size);
//        }
    }
    
    size_t qq = pow(2, 40);
    size_t *p = (size_t *)malloc(qq);
    printf("i：0  size：%ld \n", malloc_size(p));
    free(p);
    
    return 0;
}
