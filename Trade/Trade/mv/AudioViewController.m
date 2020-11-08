//
//  AudioViewController.m
//  Trade
//
//  Created by MacPro on 2020/10/13.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "AudioViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioViewController ()
{
    UIBackgroundTaskIdentifier  _bgTaskId; // 后台播放任务Id
}

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *videoPlayerLayer;
@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置音频会话，允许后台播放
    _bgTaskId = [self.class backgroundPlayerID:_bgTaskId];
}

+ (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId{
    // 1. 设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    // 2. 允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 3. 设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if (newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (IBAction)start:(id)sender {
    if (!self.player) {
        // player 播放器
        NSString *path = [[NSBundle mainBundle] pathForResource:@"08-运行时和block.mp4" ofType:nil];
        self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path isDirectory:YES]];
        // 播放图层
        self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.videoPlayerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        self.videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.view.layer addSublayer:self.videoPlayerLayer];
    }
}
- (IBAction)end:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [sender setTitle:@"播放" forState:UIControlStateSelected];
    }else{
        [self.player pause];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
}




- (void)dealloc{
    NSLog(@"释放了 %s", __func__);
}

@end
