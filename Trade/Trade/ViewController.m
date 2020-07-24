//
//  ViewController.m
//  Trade
//
//  Created by MacPro on 2020/7/2.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "ViewController.h"
#include <dlfcn.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *aTextFild;
@property (weak, nonatomic) IBOutlet UITextField *bTextFild;
@property (weak, nonatomic) IBOutlet UITextField *cTextFild;

@property (weak, nonatomic) IBOutlet UITextField *r1TextFild;
@property (weak, nonatomic) IBOutlet UITextField *r2TextFild;
@property (weak, nonatomic) IBOutlet UITextField *r3TextFild;

@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)clickCalculate:(UIButton *)sender {
    [self callMethodOfFrameWork];
    return;
    if(sender.tag % 100){
        self.aTextFild.text = @"";
        self.bTextFild.text = @"";
        self.cTextFild.text = @"";
        return;
    }
    
    NSString *a = self.aTextFild.text;
    NSString *b = self.bTextFild.text;
    
    // 目标1
    double r1 = sqrt(a.doubleValue * b.doubleValue);
    NSString *c = [NSString stringWithFormat:@"%.4f", r1];
    self.r1TextFild.text = c;
    
    // 目标2
    double r2 = (a.doubleValue >= b.doubleValue) ? sqrt(b.doubleValue * c.doubleValue) : sqrt(a.doubleValue * c.doubleValue);
    self.r2TextFild.text = [NSString stringWithFormat:@"%.4f", r2];
    
    // 最小趋势幅度值
    double value = fabs(a.doubleValue - b.doubleValue) * 1.382;
    double r3 = 0;
    if (self.switchBtn.isOn) {
        r3 = (a.doubleValue >= b.doubleValue) ? b.doubleValue  + value: a.doubleValue + value;
    }else{
        r3 = (a.doubleValue >= b.doubleValue) ? a.doubleValue  - value: b.doubleValue - value;
    }
    self.r3TextFild.text = [NSString stringWithFormat:@"%.4f", r3];
    
    // 涨跌幅
    double res = fabs(a.doubleValue - b.doubleValue);
    if (self.cTextFild.text.doubleValue <= 0) {
        return;
    }
    NSString *upString = [self upString:res and:self.cTextFild.text.doubleValue];
    NSString *downString = [self downString:res and:self.cTextFild.text.doubleValue];
    self.textV.text = [NSString stringWithFormat:@"上涨幅度：\n%@\n下跌幅度：\n%@", upString, downString];
}

- (NSString *)upString:(double)res and:(double)c{
    
    // 1.1254-1.1183 = 0.0071;
    NSString *string1 = [NSString stringWithFormat:@"上涨落差值：%.4f", res];
    // 0.382
    NSString *string22 = [NSString stringWithFormat:@"0.382值：%.4f", res * 0.382 + c];
    // 0.618
    NSString *string2 = [NSString stringWithFormat:@"0.618值：%.4f", res * 0.618 + c];
    // 1.0
    NSString *string3 = [NSString stringWithFormat:@"1.0值：%.4f", res + c];
    // 1.414
    NSString *string4 = [NSString stringWithFormat:@"1.414值：%.4f", res * 1.414 + c];
    // 1.618
    NSString *string5 = [NSString stringWithFormat:@"1.618值：%.4f", res * 1.618 + c];
    // 2.0
    NSString *string6 = [NSString stringWithFormat:@"2.0值：%.4f", res * 2.0 + c];

    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n", string1, string22, string2, string3, string4, string5, string6];
    

    //0.618  0.0071 * 0.618 + 1.1206 = 1.1249878
    //1      0.0071 + 1.1206 = 1.1277
    //1.414  0.0071 * 1.414 + 1.1206 = 1.1306394
    //1.618  0.0071 * 1.618 + 1.1206 = 1.1320878
    //2      0.0071 * 2 + 1.1206 = 1.1348
}

- (NSString *)downString:(double)res and:(double)c{
    
    // 1.1254-1.1183 = 0.0071;
    NSString *string1 = [NSString stringWithFormat:@"下跌落差值：%.4f", res];
    // 0.382
    NSString *string22 = [NSString stringWithFormat:@"0.382值：%.4f", c-res * 0.382];
    // 0.618
    NSString *string2 = [NSString stringWithFormat:@"0.618值：%.4f", c - res * 0.618];
    // 1.0
    NSString *string3 = [NSString stringWithFormat:@"1.0值：%.4f", c - res];
    // 1.414
    NSString *string4 = [NSString stringWithFormat:@"1.414值：%.4f", c - res * 1.414];
    // 1.618
    NSString *string5 = [NSString stringWithFormat:@"1.618值：%.4f", c - res * 1.618];
    // 2.0
    NSString *string6 = [NSString stringWithFormat:@"2.0值：%.4f", c - res * 2.0];

    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n", string1, string22, string2, string3, string4, string5, string6];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
    
//    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    
    [self loadFrameWorkByBundle];
}

- (void)loadFrameWorkByBundle{
    //从服务器去下载并且存入Documents下(只要知道存哪里即可),事先要知道framework名字,然后去加载
    NSString *frameworkPath = [NSString stringWithFormat:@"%@/Documents/DynamicLlib.framework", NSHomeDirectory()];
    
    NSError *err = nil;
    NSBundle *bundle = [NSBundle bundleWithPath:frameworkPath];
    NSString *str = @"加载动态库失败!";
    if ([bundle loadAndReturnError:&err]) {
        NSLog(@"bundle load framework success.");
        str = @"加载动态库成功!";
    } else {
        NSLog(@"bundle load framework err:%@",err);
    }
}

//调用framework的方法,利用runtime运行时
- (void)callMethodOfFrameWork {
    Class DynamicLlibClass = NSClassFromString(@"DemoTool");
    if(DynamicLlibClass){
        //事先要知道有什么方法在这个framework中
        id object = [[DynamicLlibClass alloc] init];
        //由于没有引入相关头文件故通过performSelector调用
        [object performSelector:@selector(doSomething)];
    }else {
        NSLog(@"调用方法失败!");
    }
}

@end
