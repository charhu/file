//
//  LifeViewController.m
//  Trade
//
//  Created by MacPro on 2020/8/20.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "LifeViewController.h"

#import "DemoViewController.h"

@interface LifeViewController ()

@end

@implementation LifeViewController


+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    NSLog(@"->->->->->->->->->->->->->-> 111 %s",__func__);
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"->->->->->->->->->->->->->-> 112 %s",__func__);
}


- (void)loadView; // This is where subclasses should create their custom view hierarchy if they aren't using a nib. Should never be called directly.
{
    [super loadView];
    NSLog(@"1 %s",__func__);
}

- (void)loadViewIfNeeded // Loads the view controller's view if it has not already been set.
{
    [super loadViewIfNeeded];
    NSLog(@"2 %s",__func__);
}

// ios(5.0, 6.0):
- (void)viewWillUnload {
    [super viewWillUnload];
    NSLog(@"3 %s",__func__);
}
// ios(3.0, 6.0) 在视图控制器的视图被释放并设置为nil后调用。例如，导致视图被清除的内存警告。不作为-dealloc的结果调用。
- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@"4 %s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"5 %s",__func__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"6 %s",__func__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"7 %s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"8 %s",__func__);
}

- (void)viewDidDisappear:(BOOL)animate {
    [super viewDidDisappear:animate];
    NSLog(@"9 %s",__func__);
}

// ios(5.0) 在调用视图控制器的视图的layoutSubviews方法之前调用。子类可以根据需要实现。默认值是nop。
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"10 %s",__func__);
}

// ios(5.0) 在视图控制器的视图的layoutSubviews方法被调用后调用。子类可以根据需要实现。默认值是nop。
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"11 %s",__func__);
}

- (void)didReceiveMemoryWarning; {
    NSLog(@"12 %s",__func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DemoViewController *dvc = [[DemoViewController alloc] init];
    [self.navigationController pushViewController:dvc animated:YES];
}

@end
