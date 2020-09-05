//
//  RecordViewController.m
//  Trade
//
//  Created by MacPro on 2020/8/18.
//  Copyright © 2020 MacPro. All rights reserved.
//

#import "RecordViewController.h"

#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVAudioSettings.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface RecordViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (copy, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableDictionary *recordSettings;

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UITextField *fileTextF;
@end

@implementation RecordViewController


+ (void)load{
    [super load];
    NSLog(@" --- %s ----", __func__);
}

+ (void)initialize{
    [super initialize];
    NSLog(@" --- %s ----", __func__);
}

- (NSMutableDictionary *)recordSettings{
    if (!_recordSettings) {
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        
        //2-2、设置编码格式：
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        
        //2-3、采样率：
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
        
        //2-4、通道数：
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        
        //2-5、音频质量，采样质量：
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        
        _recordSettings = recordSettings;
    }
    return _recordSettings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fileName{
    // 0.1 创建录音文件存放路径
    NSString *name = [NSString stringWithFormat:@"%@.caf", self.fileTextF.text];
    name = @"demo.caf";
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
//        NSLog(@"文件存在");
//        name = @"demo.caf";
//    }else{
//        NSLog(@"文件不存在");
//    }
    
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
    
    NSLog(@"%@", self.filePath);
}


- (IBAction)begin:(id)sender {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    [self fileName];
    
    self.audioRecorder = nil;
    NSError *error;
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.filePath]
                                                     settings:self.recordSettings
                                                        error:&error];
    if ([self.audioRecorder record]) {
        NSLog(@"开启 录音成功");
    }else{
        NSLog(@"开启 录音失败");
    }
}

- (IBAction)pause:(id)sender {
    [self.audioRecorder pause];
    NSLog(@"暂停 录音成功");
    
//    if (@available(iOS 13.0, *)) {
//        ASAuthorizationAppleIDButton * appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleWhite];
//        appleIDBtn.frame = CGRectMake(30, 80, self.view.bounds.size.width - 60, 64);
//        [appleIDBtn addTarget:self action:@selector(didAppleIDBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:appleIDBtn];
//
//    } else {
//        // Fallback on earlier versions
//    }
}

- (void)didAppleIDBtnClicked{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider * appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest * authAppleIDRequest = [appleIDProvider createRequest];
        ASAuthorizationPasswordRequest * passwordRequest = [[[ASAuthorizationPasswordProvider alloc] init] createRequest];
        NSMutableArray <ASAuthorizationRequest *> * array = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [array addObject:authAppleIDRequest];
        }
        if (passwordRequest) {
            [array addObject:passwordRequest];
        }
        NSArray <ASAuthorizationRequest *> * requests = [array copy];
        ASAuthorizationController * authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
        
    } else {
        // 处理不支持系统版本
        NSLog(@"系统不支持Apple登录");
    }
}

#pragma mark- ASAuthorizationControllerDelegate

// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@", errorMsg);
}
#pragma mark- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}
// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString * userID = credential.user;
        // 苹果用户信息 如果授权过，可能无法再次获取该信息
        NSPersonNameComponents * fullName = credential.fullName;
        NSString * email = credential.email;
        // 服务器验证需要使用的参数
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        // 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential * passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString * user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString * password = passwordCredential.password;
        NSLog(@"userID: %@", user);
        NSLog(@"password: %@", password);
    } else {
    }
}



- (IBAction)stop:(id)sender {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
    
    [self.audioRecorder stop];
    NSLog(@"停止 录音成功");
}

- (IBAction)play:(id)sender {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        NSLog(@"文件存在");
    }else{
        NSLog(@"文件不存在");
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data
                                              fileTypeHint:AVFileTypeWAVE
                                                     error:&error];
    NSLog(@"error：%@", error);

    [self.audioPlayer prepareToPlay];

    if ([self.audioPlayer play]) {
        NSLog(@"播放 录音成功");
    }else{
        NSLog(@"播放 录音失败");
    }
    
//UINavigationController
// UITabBarController
//    NSURLConnection
//    NSURLSession
// OS_SPINLOCK_INIT

}

@end



