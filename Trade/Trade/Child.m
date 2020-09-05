//
//  Child.m
//  Trade
//
//  Created by MacPro on 2020/7/31.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "Child.h"
#include <objc/runtime.h>

typedef struct Link{
    char elem;
    struct Link* next;
}node;

@implementation Child

+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

node * initLink(){
    int i;
    node * p=(node*)malloc(sizeof(node));//创建一个头结点
    node * temp=p;//声明一个指针指向头结点，
    //生成链表
    for (i=1; i<5; i++) {
        node *a=(node*)malloc(sizeof(node));
        a->elem=i;
        a->next=NULL;
        temp->next=a;
        temp=temp->next;
    }
    return p;
}

- (Child *)init{
    self = [super init];
    if(self){
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
        NSLog(@"%@", NSStringFromClass([self superclass]));
        
//        Class *a = object_getClass("Child");
//        Class *b = class_getSuperclass(a);
//        NSLog(@"a : %@, b: %@", a,b);
        
        NSLog(@"123", initLink());
    }
    return self;
}

@end

//(void *)objc_msgSend)((id)son,
//                      sel_registerName("run"));
//
//(void *)objc_msgSendSuper)((__rw_objc_super){
//    (id)son,
//    (id)class_getSuperclass(objc_getClass("Son"))
//}, sel_registerName("run"));






