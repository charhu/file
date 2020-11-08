//
//  LocationViewController.m
//  Trade
//
//  Created by MacPro on 2020/10/13.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "LocationViewController.h"
#import "NSObject+Language.h"

#import <CoreLocation/CoreLocation.h>

@interface LocationViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@end

@implementation LocationViewController

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.distanceFilter = 10;
        _manager.desiredAccuracy = 10;
        _manager.delegate = self;
    }
    return _manager;
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *dots = locations.lastObject;
    if (dots) {
        NSLog(@"定位信息：经度：%f  纬度： %f", dots.coordinate.longitude, dots.coordinate.latitude);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [NSObject setLanguageCode:false];
    
    [self.startBtn setTitle:[NSObject getLanguageOfKey:@"start.normal.title"]
                   forState:UIControlStateNormal];
    [self.endBtn setTitle:[NSObject getLanguageOfKey:@"end.normal.title"]
                 forState:UIControlStateNormal];
}


- (IBAction)start:(id)sender {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager requestWhenInUseAuthorization];
        [self.manager startUpdatingLocation];
    }else{
        NSLog(@"定位服务无效");
    }
}

- (IBAction)end:(id)sender {
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [NSObject setLanguageCode:true];
    
    [self.startBtn setTitle:[NSObject getLanguageOfKey:@"start.normal.title"]
                   forState:UIControlStateNormal];
    [self.endBtn setTitle:[NSObject getLanguageOfKey:@"end.normal.title"]
                 forState:UIControlStateNormal];
}

- (void)dealloc{
    NSLog(@"释放了 %s", __func__);
}

@end
