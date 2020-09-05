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

void getheap(int *p){
    p = malloc(sizeof(int) * 10);
}
void getheap1(int **p){
    *p = malloc(sizeof(int) * 10);
}

void change(int *m, int *n){
    *m = *m ^ *n;
    *n = *m ^ *n;
    *m = *m ^ *n;
}

void test(int m, int n){
    printf("m：%x, n:%x \n", &m, &n);
    printf("m：%ld, n:%ld \n", &m, &n);
}

int main(int argc, char *argv[]){
    
    char *txt = (char *)"\x90\300\346\x01\xbc";
    printf("txt:%s\n", txt);
    
    char *p1 = malloc(5);
    p1[17] = 'A';
    for (int i = 0; i<20; i++) {
        printf("i:%d p：%d \n", i, p1[i]);
    }
    
    printf("malloc size：%ld\n=============\n", malloc_size(p1));
    
    char *p2 = calloc(5, 1);
    for (int i = 0; i<20; i++) {
        printf("i:%d p：%d \n", i, p2[i]);
    }
    
    printf("calloc size：%ld\n=============\n", malloc_size(p2));
    
    char *p3 = realloc(p1, 17);
    for (int i = 0; i<20; i++) {
        printf("i:%d p：%d \n", i, p3[i]);
    }
    
    printf("realloc size：%ld\n=============\n", malloc_size(p3));
    
    char *p4 = realloc(p3, 2);
    for (int i = 0; i<20; i++) {
        printf("i:%d p：%d \n", i, p4[i]);
    }
    
    printf("realloc size：%ld\n=============\n", malloc_size(p4));
    
    return 0;
}

int main2(int argc, char *argv[]){
    
    int arr[10] = {10,20,30,40,50,60,70,80,90,100};
    int *p = arr;
    
    for (int i = 0; i< 10; i++) {
        NSLog(@"前：i：%d, value：%d address：%x", i, arr[i], &arr[i]);
    }
    
    p += 5;
    p -= 2;
    p[0] = 2000;
    p[3] = 20;
    
    for (int i = 0; i< 10; i++) {
        NSLog(@"后：i：%d, value：%d address：%x", i, arr[i], &arr[i]);
    }
    
    test(2,44);
    
    return 0;
}

int main1(int argc, char *argv[]){
    
    @autoreleasepool {
        int *q = NULL;
        getheap(q);
        getheap1(&q);
        q[0] = 20;
        q[2] = 3;
        printf("q[0]：%d, q[2]：%d \n", q[0], q[2]);
        free(q);
    }
    
    int a = 100;
    
    int *m = NULL;
    m = &a;
    
    int *n = &a;
    
    *n = 1000;
    
    printf("*m:%d *n:%d\n", *m, *n);
    printf("m:%x  n:%x  a:%x\n", m, n, &a);
    
    int x = 10, y = 20;
    change(&x, &y);
    printf("x:%d, y:%d \n",x,y);
    
    int c = 0x12345678;
    unsigned char *pp = &c;
    printf("%x，%x, %x, %x \n", pp[0],pp[1],pp[2],pp[3]);

    return 0;
}

/*
1、指向NULL的指针叫空指针。 int *p = NULL;
2、指针有值，但是该地址是无意义的，叫野指针。
 int *p = NULL; p = 1000; 或者 int *p 不给初值，未来可能会有值；
 野指针导致的结果是，程序是未知的，可能会引起程序的错误。
*/

/*
 64Bit ==》寻址空间 2^64 个
 2^10 = 1024 ==> 1KByte
 2^64 = 1024 * 1024 x 1024 * 1024 x 1024 * 1024 x 2^4 = 1024PB x 16 Byte = 16384PB
 
 1024B=1KB=1024字节=2^10字节（^代表次方）

 1024KB=1MB=1048576字节=2^20字节

 1024MB=1GB=1073741824字节=2^30字节

 1024GB=1TB=1099511627776字节=2^40字节

 1024TB=1PB=1125899906842624字节=2^50字节

 1024PB=1EB=115 292150 4606846976字节=2^60字节

 1024EB=1ZB=1180591620717411303424字节=2^70字节

 1024ZB=1YB=1208925819614629174706176字节=2^80字节
 
 目前：
 32位系统最大识别3.75G内存，即 2^30 x 2^2 = 4GB
 64位系统最大识别128G内存, 受限于主板，128目前是最大值。
 
 */
