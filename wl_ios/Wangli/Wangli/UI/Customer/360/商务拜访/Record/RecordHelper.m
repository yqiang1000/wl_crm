//
//  RecordHelper.m
//  Wangli
//
//  Created by yeqiang on 2018/12/29.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordHelper.h"

@interface RecordHelper ()

@property (nonatomic, strong) AVAudioRecorder *recorder;    // 录音器

@property (nonatomic, strong) NSURL *recordFileUrl;         // 文件地址

@end

static dispatch_once_t once;
static RecordHelper *_recordHelper = nil;

@implementation RecordHelper

+ (instancetype)sharedInstance {
    dispatch_once(&once, ^{
        _recordHelper = [[self alloc] init];
    });
    return _recordHelper;
}

+ (void)destoryInstance {
    _recordHelper = nil;
    once = 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 录制权限
- (BOOL)canRecord {
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

#pragma mark - 配置路径
- (NSString *)getCurrentRecordPath {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.wavPath.length == 0) {
        formatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        [RecordHelper sharedInstance].wavPath = [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", dateStr]];
        [RecordHelper sharedInstance].mp3Path = [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", dateStr]];
        [RecordHelper sharedInstance].fileName = [NSString stringWithFormat:@"%@.wav", dateStr];
    }
    return [RecordHelper sharedInstance].wavPath;
}

- (NSArray *)getHistoryList {
    NSError *error = nil;
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.rootPath error:&error];
    NSMutableArray *list = [NSMutableArray new];
    for (int i = 0; i < arr.count; i++) {
        NSString *x = arr[i];
        NSString *filePath = [self.rootPath stringByAppendingPathComponent:x];
        CGFloat size = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0;
        [list addObject:@{@"name":STRING(x),
                          @"size":@(size)}];
    }
    return list;
}

#pragma mark - 开始录制

- (void)startRecord {
    NSError *sessionError;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //1 获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:self.wavPath];
    //2 设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 11025.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
    } else {
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}

#pragma mark - 结束录制
- (void)stopRecord {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}

- (void)releaseResource {
    self.recorder = nil;
    self.recordFileUrl = nil;
}

- (BOOL)isRecording {
    return self.recorder.isRecording;
}

#pragma mark - lazy

- (NSString *)rootPath {
    if (_rootPath.length == 0) {
        //获取本地沙盒路径
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsPath = [path objectAtIndex:0];
        _rootPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@/voice",[NSString stringWithFormat:@"%ld", (long)TheUser.userMo.id]]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_rootPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _rootPath;
}

@end

