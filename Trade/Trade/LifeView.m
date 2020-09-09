//
//  LifeView.m
//  Trade
//
//  Created by MacPro on 2020/8/20.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "LifeView.h"

@implementation LifeView


+ (void)load{
//    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
//    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    
    NSLog(@"--------- 1 %s",__func__);
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index{
    [super insertSubview:view atIndex:index];
    NSLog(@"--------- 2 %s",__func__);
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2{
    [super exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    NSLog(@"--------- 3 %s",__func__);
}

- (void)addSubview:(UIView *)view{
    [super addSubview:view];
    NSLog(@"--------- 4 %s",__func__);
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview{
    [super insertSubview:view belowSubview:siblingSubview];
    NSLog(@"--------- 5 %s",__func__);
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview{
    [super insertSubview:view aboveSubview:siblingSubview];
    NSLog(@"--------- 6 %s",__func__);
}

- (void)bringSubviewToFront:(UIView *)view{
    [super bringSubviewToFront:view];
    NSLog(@"--------- 7 %s",__func__);
}

- (void)sendSubviewToBack:(UIView *)view{
    [super sendSubviewToBack:view];
    NSLog(@"--------- 8 %s",__func__);
}

- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    NSLog(@"--------- 9 %s",__func__);
}

- (void)willRemoveSubview:(UIView *)subview{
    [super willRemoveSubview:subview];
    NSLog(@"--------- 10 %s",__func__);
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    NSLog(@"--------- 11 %s",__func__);
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    NSLog(@"--------- 12 %s",__func__);
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    NSLog(@"--------- 13 %s",__func__);
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    NSLog(@"--------- 14 %s",__func__);
}

//- (BOOL)isDescendantOfView:(UIView *)view{
//    BOOL result = [super isDescendantOfView:view];
//    NSLog(@"--------- 15 %s  --------- %d",__func__, result);
//    return result;
//}

// 递归搜索。包括自己
- (nullable __kindof UIView *)viewWithTag:(NSInteger)tag{
    UIView *result = [super viewWithTag:tag];
    NSLog(@"--------- 16 %s",__func__);
    return result;
}

// 允许您在绘图周期发生之前执行布局。- layoutifrequired 强制提前布局
- (void)setNeedsLayout{
    [super setNeedsLayout];
    NSLog(@"--------- 17 %s",__func__);
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    NSLog(@"--------- 18 %s",__func__);
}

// 覆盖点。由layoutIfNeeded自动调用。在iOS 6.0中，当使用基于约束的布局时，基本实现应用基于约束的布局，否则它什么都不做。
- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"--------- 19 %s",__func__);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSLog(@"--------- 20 %s",__func__);
}

- (void)setNeedsDisplay{
    [super setNeedsDisplay];
    NSLog(@"--------- 21 %s",__func__);
}

- (void)setNeedsDisplayInRect:(CGRect)rect{
    [super setNeedsDisplayInRect:rect];
    NSLog(@"--------- 22 %s",__func__);
}

@end
