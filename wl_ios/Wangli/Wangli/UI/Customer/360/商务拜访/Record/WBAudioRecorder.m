//
//  WBAudioRecorder.m
//  WBLiveKit
//
//  Created by bing on 2016/12/14.
//  Copyright © 2016年 wangchun. All rights reserved.
//

#import "WBAudioRecorder.h"
#import "WBVideoUtil.h"

@interface WBAudioRecorder()

@property (nonatomic, strong) NSString *tempPath;

@end

@implementation WBAudioRecorder

#pragma mark - initializers

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WBAudioRecorder *wBAudioRecorder;
    dispatch_once(&once, ^{
        wBAudioRecorder = [[self alloc] init];
    });
    return wBAudioRecorder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tempPath = [self getPathByFileName:@"temp" ofType:@"wav"];
        _isOnlyAudio = NO;
    }
    return self;
}

- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:_type];
    return fileDirectory;
}

+ (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

#pragma mark - 开始录音
- (void)beginAudioRecordByFileName:(NSString*)filePath
{
    //设置文件名和录音路径
    self.recordFilePath = filePath;
    
    [self startAudioRecord];
}

#pragma mark - 开始或结束
-(void)toRecordOrPause:(NSNotification*)sender
{
    NSString* str=(NSString*)[sender object];
    if ([str intValue]) {
        [self startAudioRecord];
    }
    else{
        [self pauseAudioRecord];
    }
}

#pragma mark - 录音开始
-(void)startAudioRecord {
    if (_recorder == nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toRecordOrPause:) name:@"toRecordOrPause" object:nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:_tempPath]){
            [fileManager removeItemAtPath:_tempPath error:nil];
        }
        
        //初始化录音
        NSError *error = nil;
        AVAudioRecorder *temp = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:[_tempPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                                           settings:[self getAudioRecorderSettingDict]
                                                              error:&error];
        self.recorder = temp;
        self.recorder.meteringEnabled = YES;
        BOOL isOK = [self.recorder prepareToRecord];
        //开始录音
        if (isOK) {
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    }
    
    [self.recorder record];
    _nowPause=NO;
}

#pragma mark - 录音暂停
-(void)pauseAudioRecord {
    if (self.recorder.isRecording) {
        if (!_nowPause) [self.recorder pause];
        _nowPause=YES;
    }
}

#pragma mark - 录音结束
- (void)finishAudioRecord{
    BOOL isrec  = self.recorder.isRecording;
    
    if (self.recorder.isRecording||(!self.recorder.isRecording&&_nowPause)) {
        [self.recorder stop];
        self.recorder = nil;
        
        if (_isOnlyAudio) {
            [WBVideoUtil mergeAudioToOneAudio:@[self.recordFilePath, self.tempPath] toStorePath:self.recordFilePath isDelTemp:YES success:^(NSInteger vDuration) {
                self.videDuration = vDuration;
                if ([self.delegate respondsToSelector:@selector(audioRecordComplete)]) {
                    [self.delegate audioRecordComplete];
                }
            } failure:^{

            }];
        }
        else if ([self.delegate respondsToSelector:@selector(audioRecordComplete)]) {
            [self.delegate audioRecordComplete];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toRecordOrPause" object:nil];
}

- (void)finishAudioRecordAndGenPreview{
    if (self.recorder.isRecording||(!self.recorder.isRecording&&_nowPause)) {
        [self.recorder stop];
        self.recorder = nil;
        
        if (_isOnlyAudio) {
            [WBVideoUtil mergeAudioToOneAudio:@[self.recordFilePath, self.tempPath] toStorePath:self.recordFilePath isDelTemp:YES success:^(NSInteger vDuration) {
                self.videDuration = vDuration;
                if ([self.delegate respondsToSelector:@selector(audioRecordAndGenPreViewComplete)]) {
                    [self.delegate audioRecordAndGenPreViewComplete];
                }
            } failure:^{
            }];
        }
        else if ([self.delegate respondsToSelector:@selector(audioRecordAndGenPreViewComplete)]) {
            [self.delegate audioRecordAndGenPreViewComplete];
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"toRecordOrPause" object:nil];
}


- (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   nil];
    
    
//    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
//                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
//                                    [NSNumber numberWithInt:AVAudioQualityHigh], AVSampleRateConverterAudioQualityKey,
//                                    [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
//                                    [NSNumber numberWithInt:16], AVEncoderBitDepthHintKey,
//                                    nil];
    return recordSetting;
}

- (BOOL)isRecording
{
    return self.recorder.isRecording;
}

@end
