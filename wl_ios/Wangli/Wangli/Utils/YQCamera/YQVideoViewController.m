//
//  YQVideoViewController.m
//  KJCamera
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import "YQVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YQProgressHUD.h"
#import "YQAVPlayer.h"
#import <Photos/Photos.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface YQVideoViewController () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, copy) NSString *rootPath;
//轻触拍照，按住摄像
@property (nonatomic, strong) UILabel *labelTipTitle;
/** 背景 */
@property (nonatomic, strong) UIImageView *bgView;
/** 取消 */
@property (nonatomic, strong) UIButton *btnBack;
/** 重新录制 */
@property (nonatomic, strong) UIButton *btnAfresh;
/** 确定 */
@property (nonatomic, strong) UIButton *btnEnsure;
/** 摄像头切换 */
@property (nonatomic, strong) UIButton *btnCamera;
//聚焦光标
@property (nonatomic, strong) UIImageView *focusCursor;
/** 记录录制的时间 默认最大60秒 */
@property (assign, nonatomic) NSInteger seconds;

//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//负责输入和输出设备之间的数据传递
@property (nonatomic) AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;

//视频播放
@property (strong, nonatomic) YQAVPlayer *player;

@property (nonatomic, strong) YQProgressHUD *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) UIImageView *imgRecord;

@end

#define TimeMax 1

@implementation YQVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self recoverLayout];
    [self.progressView clearProgress];
    
    if (self.HSeconds == 0) {
        self.HSeconds = 15;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.labelTipTitle.hidden = YES;
        [_labelTipTitle removeFromSuperview];
        _labelTipTitle = nil;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self customCamera];
    [self.session startRunning];
}

//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)dealloc{
    [self removeNotification];
}

- (void)setUI {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.btnBack];
    [self.view addSubview:self.btnEnsure];
    [self.view addSubview:self.labelTipTitle];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.imgRecord];
    [self.view addSubview:self.focusCursor];
    [self.view addSubview:self.btnAfresh];
    [self.view addSubview:self.btnCamera];
    
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.btnEnsure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
        make.width.height.equalTo(@(70));
    }];
    
    [self.btnAfresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.btnEnsure);
        make.width.height.equalTo(self.btnEnsure);
    }];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-100);
        make.centerY.equalTo(self.btnEnsure);
        make.width.height.equalTo(@(40));
    }];
    
    [self.imgRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.btnEnsure);
        make.width.height.equalTo(@(67));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imgRecord);
        make.width.height.equalTo(@(87));
    }];
    
    [self.btnCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(23);
        make.width.height.equalTo(@(37));
    }];
    
    [self.labelTipTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.progressView.mas_top).offset(-10);
    }];
}

- (void)customCamera {
    
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    [self setFrameRateWithDurationInternal:CMTimeMake(1, 20) device:captureDevice];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;//CGRectMake(0, 0, self.view.width, self.view.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.bgView.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}


#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    NSLog(@"开始录制");
    self.seconds = self.HSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error {
    NSLog(@"视频录制完成");
    [self changeLayout];
    if (self.isVideo) {
        // 视频
//        NSString *newPath = [NSString stringWithFormat:@"new_%@", outputFileURL.absoluteString];
//        self.saveVideoUrl = [NSURL fileURLWithPath:newPath];
        self.saveVideoUrl = outputFileURL;
        if (!self.player) {
            self.player = [[YQAVPlayer alloc] initWithFrame:self.bgView.bounds url:outputFileURL finishplayblock:nil];
            [self.bgView addSubview:self.player];
            
//            [self lowQuailtyWithInputURL:outputFileURL outputURL:self.saveVideoUrl blockHandler:^(AVAssetExportSession *session) {
//                if (session.status == AVAssetExportSessionStatusCompleted)
//                {
//                    NSLog(@"压缩完成");
//                }else if (session.status == AVAssetExportSessionStatusFailed) {
//                    NSLog(@"压缩失败");
//                }
//            }];
        } else {
            if (outputFileURL) {
                self.player.videoUrl = outputFileURL;
                self.player.hidden = NO;
            }
        }
    } else {
        // 照片
        self.saveVideoUrl = nil;
        [self videoHandlePhoto:outputFileURL];
    }
}

// 视频压缩
- (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetLowQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
     }];
}

// 视频截图
- (void)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES; // 截图时候调整正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0, 30); // 缩略图创建时间 第几秒，第几帧
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败：%@", error.localizedDescription);
        [self recoverLayout];
        CGImageRelease(cgImage);
        return;
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    
    self.takeImage = image;
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    if (!self.takeImageView) {
        self.takeImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [self.bgView addSubview:self.takeImageView];
    }
    self.takeImageView.hidden = NO;
    self.takeImageView.image = self.takeImage;
}

- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            if (self.HSeconds - self.seconds >= TimeMax && !self.isVideo) {
                self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}

#pragma mark - NSNotification

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    // 注意添加区域改变捕捉通知必须首先设置设备允许捕捉
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

/**
 *  设备连接成功
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}


/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        CGPoint point = [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}


/**
 *  设置聚焦光标位置
 *  @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point {
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center = point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.focusCursor.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

/**
 *  隐藏聚焦图片
 */
- (void)onHiddenFocusCurSorAction {
    self.focusCursor.alpha=0;
    self.isFocus = NO;
}

/**
 *  设置聚焦点
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        //        if ([captureDevice isFocusPointOfInterestSupported]) {
        //            [captureDevice setFocusPointOfInterest:point];
        //        }
        //        if ([captureDevice isExposurePointOfInterestSupported]) {
        //            [captureDevice setExposurePointOfInterest:point];
        //        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}


/**
 *  改变设备属性的统一操作方法
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange {
    // 获取当前输入设备
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error = nil;
    // 改变设备属性之前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        // 自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        // 自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if (propertyChange) {
            propertyChange(captureDevice);
        }
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  取得指定位置的摄像头
 *  @param position 摄像头位置
 *  @return 摄像头设备
 */

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    NSArray *caremars = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in caremars) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

//拍摄完成时调用
- (void)changeLayout {
    self.imgRecord.hidden = YES;
    self.btnCamera.hidden = YES;
    self.btnAfresh.hidden = NO;
    self.btnEnsure.hidden = NO;
    self.btnBack.hidden = YES;
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
    
    [self.btnAfresh mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH/4.0);
    }];
    
    [self.btnEnsure mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(SCREEN_WIDTH/4.0);;
    }];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}


//重新拍摄时调用
- (void)recoverLayout {
    if (self.isVideo) {
        self.isVideo = NO;
        [self.player stopPlayer];
        self.player.hidden = YES;
    }
    [self.session startRunning];
    
    if (!self.takeImageView.hidden) {
        self.takeImageView.hidden = YES;
    }
    self.saveVideoUrl = nil;
    self.imgRecord.hidden = NO;
    self.btnCamera.hidden = NO;
    self.btnAfresh.hidden = YES;
    self.btnEnsure.hidden = YES;
    self.btnBack.hidden = NO;
    [self.btnAfresh mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];
    
    [self.btnEnsure mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 没调用
/**
 *  设置闪光灯模式
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

#pragma mark - event

- (void)btnBackClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)btnAfreshClick:(UIButton *)sender {
    NSLog(@"重新录制");
    [self recoverLayout];
}

- (void)btnEnsureClick:(UIButton *)sender {
    NSLog(@"确定 这里进行保存或者发送出去");
    
    if (self.saveVideoUrl) {
        [Utils showToastMessage:@"视频保存中..."];
        // 保存视频
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.saveVideoUrl];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"保存视频到相册中失败，错误信息：%@", error.localizedDescription);
                [Utils showToastMessage:@"保存视频到相册发生错误"];
                [Utils dismissHUD];
            } else {
                [Utils dismissHUD];
                NSDictionary *dic = [self getVideoInfoWithSourcePath:self.saveVideoUrl.absoluteString];
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.takeBlock) self.takeBlock(self.saveVideoUrl);
                }];
//                if (self.takeBlock) self.takeBlock(self.takeImage);
//                [self btnBackClick:nil];
            }
        }];
    } else {
        //照片
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:self.takeImage];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                NSLog(@"保存图片到相册中失败，错误信息：%@", error.localizedDescription);
                [Utils showToastMessage:@"保存图片到相册发生错误"];
                [Utils dismissHUD];
            } else {
                [Utils dismissHUD];
//                if (self.takeBlock) self.takeBlock(self.takeImage);
//                [self btnBackClick:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self.takeBlock) self.takeBlock(self.takeImage);
                }];
            }
        }];
    }
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}

// 前后摄像头切换
- (void)btnCameraClick:(UIButton *)sender {
    NSLog(@"切换摄像头");
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    // 前置
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    AVCaptureDevice *toChangeDevice = nil;
    if (currentPosition == AVCaptureDevicePositionUnspecified ||
        currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    
    // 获取要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    // 修改帧数
    [self setFrameRateWithDurationInternal:CMTimeMake(1, 20) device:toChangeDevice];
    
    // 改变会话的配置前先开启配置，设置完后再提交配置改变
    [self.session beginConfiguration];
    
    // 移除原先输入对象
    [self.session removeInput:self.captureDeviceInput];
    // 添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    // 提交回话
    [self.session commitConfiguration];
}

// 修改视频帧数
- (void)setFrameRateWithDurationInternal:(CMTime)frameDuration device:(AVCaptureDevice *)videoDevice {
    frameDuration = CMTimeMake(1, 15);
    NSError *error = nil;
    NSArray *supportedFrameRateRanges        = [videoDevice.activeFormat videoSupportedFrameRateRanges];
    BOOL frameRateSupported                  = NO;
    for(AVFrameRateRange *range in supportedFrameRateRanges){
        if(CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) &&
           CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
            frameRateSupported  = YES;
            break;
        }
    }
    
    if(frameRateSupported && [videoDevice lockForConfiguration:&error]) {
        [videoDevice setActiveVideoMaxFrameDuration:frameDuration];
        [videoDevice setActiveVideoMinFrameDuration:frameDuration];
        [videoDevice unlockForConfiguration];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"开始录制");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddhhmmss";
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            NSString *outputFielPath = [[self rootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateStr]];
            NSLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            NSLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.imgRecord) {
        NSLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

#pragma mark - lazy

- (NSString *)rootPath {
    if (_rootPath.length == 0) {
        //获取本地沙盒路径
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsPath = [path objectAtIndex:0];
        _rootPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@/video",[NSString stringWithFormat:@"%ld", (long)TheUser.userMo.id]]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_rootPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _rootPath;
}


- (UILabel *)labelTipTitle {
    if (!_labelTipTitle) {
        _labelTipTitle = [UILabel new];
        _labelTipTitle.text = @"轻触拍照，按住摄像";
        _labelTipTitle.font = [UIFont systemFontOfSize:14];
        _labelTipTitle.textColor = UIColor.whiteColor;
    }
    return _labelTipTitle;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.backgroundColor = UIColor.redColor;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusCursor.image = [UIImage imageNamed:@"hVideo_focusing"];
        _focusCursor.alpha = 0;
    }
    return _focusCursor;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        _btnBack = [UIButton new];
        [_btnBack setImage:[UIImage imageNamed:@"hVideo_back"] forState:UIControlStateNormal];
        [_btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBack;
}

- (UIButton *)btnAfresh {
    if (!_btnAfresh) {
        _btnAfresh = [UIButton new];
        [_btnAfresh setImage:[UIImage imageNamed:@"hVideo_cancel"] forState:UIControlStateNormal];
        [_btnAfresh addTarget:self action:@selector(btnAfreshClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAfresh;
}

- (UIButton *)btnEnsure {
    if (!_btnEnsure) {
        _btnEnsure = [UIButton new];
        [_btnEnsure setImage:[UIImage imageNamed:@"hVideo_confirm"] forState:UIControlStateNormal];
        [_btnEnsure addTarget:self action:@selector(btnEnsureClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnEnsure;
}

- (UIButton *)btnCamera {
    if (!_btnCamera) {
        _btnCamera = [UIButton new];
        [_btnCamera setImage:[UIImage imageNamed:@"btn_video_flip_camera.png"] forState:UIControlStateNormal];
        [_btnCamera addTarget:self action:@selector(btnCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCamera;
}

- (UIImageView *)imgRecord {
    if (!_imgRecord) {
        _imgRecord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hVideo_take"]];;
        _imgRecord.userInteractionEnabled = YES;
    }
    return _imgRecord;
}

- (YQProgressHUD *)progressView {
    if (!_progressView) {
        _progressView = [[YQProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 87, 87)];
        _progressView.backgroundColor = [UIColor colorWithRed:206/255.0 green:202/255.0 blue:197/255.0 alpha:1];
        _progressView.layer.cornerRadius = _progressView.frame.size.width/2;
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}

@end
