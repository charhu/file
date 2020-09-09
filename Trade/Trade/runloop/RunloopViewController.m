//
//  RunloopViewController.m
//  Trade
//
//  Created by MacPro on 2020/9/8.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "RunloopViewController.h"
#import "TimerViewController.h"
#import "QueueViewController.h"
#import "DisplayLinkViewController.h"


@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    TimerViewController *vc = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
//    QueueViewController *vc = [[QueueViewController alloc] init];
    DisplayLinkViewController *vc = [[DisplayLinkViewController alloc] initWithNibName:@"DisplayLinkViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
