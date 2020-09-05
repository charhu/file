//
//  main.m
//  Trade
//
//  Created by MacPro on 2020/7/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <malloc/malloc.h>

int sum(int num);
int sumplus(int num);
NSNumber* getindex(int num);

void test1(int num);
void test2(int num);

int* testStack();

void Ancestor(void);
void Sibling(void);
    
void testmalloc();

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
    
    NSLog(@"查询索引结果：%@", getindex(92));
    
    test1(85);
    test2(85);
    
    int *p = testStack();
    *p = 1234;
    NSLog(@"*p：%d", *p);
    
    Ancestor();
    Sibling();
    
    testmalloc();
    
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

void testmalloc(){
    unichar *pp = malloc(sizeof(unichar) * 10);
    printf("size：%ld \n", malloc_size(pp));
    printf("*pp: %d  \n  byte:%ld", *pp, sizeof(int));
}
// 00 00 60 00 02 59 e7 00 ==> 64bit = 8byte x 8
// 1个 64Bit 地址 ==> 8字节，4int = 4 x 4Byte = 16Byte = 128Bit
// 1 int = 8Byte
// 2 int = 16
// 10 int = 80 Byte
// 00 00 60 00 01 34 00 60 00 00 60 00 01 34 00 60

int* testStack(){
    int a = 100;
    return &a;
}

void Ancestor(void){
    int dwLegacy = 42;
}
void Sibling(void){
  int aaa;
  printf("aaa：%d\n", aaa);
}

void test1(int num){
    if (num < 90) {
        if (num < 70) {
            if (num < 60) {
                NSLog(@"不及格");
            }else{
                NSLog(@"及格");
            }
        }else{
            NSLog(@"良好");
        }
    }else {
        NSLog(@"优秀");
    }
}

void test2(int num){
    if (num > 60) {
        if (num > 70) {
            if (num > 90) {
                NSLog(@"优秀");
            }else{
                NSLog(@"良好");
            }
        }else{
            NSLog(@"及格");
        }
    }else {
        NSLog(@"不及格");
    }
}

// 递归计算
/*
 1、对一个因子，不断进行拆解，直到拆解到不满足条件
 2、对所有拆解的结果进行批量运算
 3、如求和100！，实质拆解转换后就是求：1+2+3+...100
 */
int sumplus(int num){   // 5.4.3.2.1....
    int result = num;
    if (num > 0) {
        result = result + sum(num - 1);
    }

    return result;
}
// 递归的本质
int sum(int num){   // 4.3.2.1....
    int result = num;
    while (num > 0) {
        num = num - 1;
        result = result + num;
    }

    return result;
}

// 二分查找
/*
1、前提是二叉查找有序树，或者是有序的顺序表集合,如数组
2、从索引0开始，设定索引 low=0,high=arr.count-1,mid=(low+high)/2, mid 可以向上取整，
3、拿arr[mid] 跟要查找的元素进行对比，根据对比结果锁定查找范围
4、后面元素依次逻辑，循环执行第1步，第2步，[low=mid,high=arr.count-1] 或 [low=mid,high=mid]
5、需要执行的循环次数最大值等于树的高度，最小值1
*/
NSNumber* getindex(int num){
    
    NSArray *tempArr = [NSArray arrayWithObjects:@5,@13,@19,@21,@37,@56,@64,@75,@80,@88,@92, nil];
        
    NSUInteger endindex = tempArr.count - 1;
    NSUInteger midindex = tempArr.count / 2;
    
    for (NSUInteger i = 0; i < tempArr.count; i ++) {
                        
        NSLog(@"i:%ld, midindex:%ld, endindex:%ld", i, midindex, endindex);
        
        int midnum = [[tempArr objectAtIndex:midindex] intValue];
        if (midnum == num) {
            return [NSNumber numberWithUnsignedLong:midindex];
            
        }else if (midindex == endindex){
            return nil;
            
        }else if (midnum < num){
            midindex = (midindex + 1 + endindex) / 2;
            
        }else{
            endindex = midindex - 1;
            midindex = endindex / 2;
        }
    }
    
    return nil;
}





typedef struct _malloc_zone_t {
    void    *reserved1;    /* 保留给CF分配器 */
    void    *reserved2;    /* 保留给CF分配器 */
    size_t     (* size)(struct _malloc_zone_t *zone, const void *ptr); /* 返回块的大小，如果不在此区域，则返回0*/
    void     *(* malloc)(struct _malloc_zone_t *zone, size_t size);
    void     *(* calloc)(struct _malloc_zone_t *zone, size_t num_items, size_t size); /* 与malloc相同，但是返回的块被设置为零 */
    void     *(* valloc)(struct _malloc_zone_t *zone, size_t size); /* 与malloc相同，但是返回的块被设置为零，并且保证是页面对齐的 */
    void     (* free)(struct _malloc_zone_t *zone, void *ptr);
    void     *(* realloc)(struct _malloc_zone_t *zone, void *ptr, size_t size);
    void     (* destroy)(struct _malloc_zone_t *zone); /* 区域被破坏，所有内存被回收 */
    const char    *zone_name;

    /* Optional batch callbacks; these may be NULL */
    unsigned    (* MALLOC_ZONE_FN_PTR(batch_malloc))(struct _malloc_zone_t *zone, size_t size, void **results, unsigned num_requested); /* 给定一个大小，返回能够保持该大小的指针;返回分配的指针数量(可能为0或小于num_requested) */
    void    (* MALLOC_ZONE_FN_PTR(batch_free))(struct _malloc_zone_t *zone, void **to_be_freed, unsigned num_to_be_freed); /* 释放to_be_freed中的所有指针;注意，to_be_freed可能会在进程期间被覆盖 */

    struct malloc_introspection_t    * MALLOC_INTROSPECT_TBL_PTR(introspect);
    unsigned    version;
        
    /* 对齐的内存分配。回调可以是NULL。目前版本>= 5。 */
    void *(* MALLOC_ZONE_FN_PTR(memalign))(struct _malloc_zone_t *zone, size_t alignment, size_t size);
    
    /* 释放一个已知位于区域内且已知具有给定大小的指针。回调可以是NULL。当前版本>= 6.*/
    void (* MALLOC_ZONE_FN_PTR(free_definite_size))(struct _malloc_zone_t *zone, void *ptr, size_t size);

    /*在面临内存压力时清空缓存。回调可以是NULL。目前版本>= 8。*/
    size_t     (* MALLOC_ZONE_FN_PTR(pressure_relief))(struct _malloc_zone_t *zone, size_t goal);

    /*
    *检查地址是否属于区域。可能是NULL。当前版本>= 10。
    *允许出现误报(例如，指针被释放，或者它在区域空间中被释放
    *尚未分配。不允许错误的否定。
    */
    boolean_t (* MALLOC_ZONE_FN_PTR(claimed_address))(struct _malloc_zone_t *zone, void *ptr);
     
} malloc_zone_t; 144


#define MALLOC_ABSOLUTE_MAX_SIZE (SIZE_T_MAX - (2 * PAGE_SIZE))

typedef struct {
    malloc_zone_t malloc_zone;  // 144
    uint8_t pad[4096 - 144];  // 1
} virtual_default_zone_t;

static virtual_default_zone_t virtual_default_zone;

static malloc_zone_t *default_zone = &virtual_default_zone.malloc_zone;

retval = malloc_zone_malloc(144[], size);

16
32
48
64
80
96
112
128
******* 144
160
176
192
208
224
240
256


81 = 96
2*16 = 32

if（num % 16 > 0）{
    size = num / 16 * 16 + 16
}else{
    size = num;
}

