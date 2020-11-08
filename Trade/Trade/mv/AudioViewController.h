//
//  AudioViewController.h
//  Trade
//
//  Created by MacPro on 2020/10/13.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textV;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@end

NS_ASSUME_NONNULL_END
