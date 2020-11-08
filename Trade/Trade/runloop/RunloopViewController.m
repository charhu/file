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
#import "SideTableViewController.h"
#import "NoticeViewController.h"
#import "LocationViewController.h"
#import "AudioViewController.h"

@implementation RunloopViewController

static int num = 3;

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    lab.text = [NSString stringWithFormat:@"num is %d", num];
    lab.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:lab];
    
    
//    for (UIView *v in self.view.subviews) {
//        if ([v isKindOfClass:UILabel.class]) {
//            UILabel *lab = (UILabel *)v;
//            lab.text = [NSString stringWithFormat:@"num is %d", num + 5];
//            break;
//        }
//    }
    
//    NSLog(@"\n\n runloop：%@ \n\n", CFRunLoopGetCurrent());
//    NSLog(@"\n\n runloop：%@ \n\n", [NSRunLoop currentRunLoop]);
    
//    NSLog(@"\n\n %@", [NSRunLoop currentRunLoop]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    TimerViewController *vc = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
//    QueueViewController *vc = [[QueueViewController alloc] init];
//    DisplayLinkViewController *vc = [[DisplayLinkViewController alloc] initWithNibName:@"DisplayLinkViewController" bundle:nil];
    
//    SideTableViewController *vc = [[SideTableViewController alloc] init];
//    NoticeViewController *vc = [NoticeViewController new];
    
//    LocationViewController *vc = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    AudioViewController *vc = [[AudioViewController alloc] initWithNibName:@"AudioViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
