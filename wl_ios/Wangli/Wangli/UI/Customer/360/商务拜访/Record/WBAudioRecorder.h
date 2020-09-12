//
//  WBAudioRecorder.h
//  WBLiveKit
//
//  Created by bing on 2016/12/14.
//  Copyright © 2016年 wangchun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol WBAudioRecorderDelegate<NSObject>
@optional
- (void)recorderDuration:(NSInteger) vDuration;
-(void) audioRecordComplete;
-(void) audioRecordAndGenPreViewComplete;
@end

@interface WBAudioRecorder : NSObject

+ (instancetype)sharedInstance;
+ (BOOL)canRecord;

@property (nonatomic, assign) id<WBAudioRecorderDelegate> delegate;

@property (retain, nonatomic)AVAudioRecorder *recorder;
@property (copy, nonatomic)NSString *recordFilePath;//录音文件路径
@property (assign,nonatomic) BOOL nowPause;
@property (assign,nonatomic,getter=isRecording) BOOL isRecording;
@property (assign,nonatomic) BOOL isOnlyAudio;
@property(nonatomic, assign) NSInteger videDuration;

- (void) beginAudioRecordByFileName:(NSString*)filePath;

- (void) finishAudioRecord;

- (void) pauseAudioRecord;

- (void) startAudioRecord;

- (void) finishAudioRecordAndGenPreview;

@end
