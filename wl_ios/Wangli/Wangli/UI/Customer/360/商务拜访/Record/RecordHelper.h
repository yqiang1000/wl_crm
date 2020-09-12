//
//  RecordHelper.h
//  Wangli
//
//  Created by yeqiang on 2018/12/29.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

#define MAX_RECORD_COUNT (60*60*5)

@class RecordHelper;
@protocol RecordHelperDelegate <NSObject>
@optional
- (void)recordHelperFinishRecord;
@end

@interface RecordHelper : NSObject

@property (nonatomic, weak) id <RecordHelperDelegate> delegate;

@property (nonatomic, copy) NSString *fileName;             // 录音文件名
@property (nonatomic, copy) NSString *wavPath;              // wav路经
@property (nonatomic, copy) NSString *mp3Path;              // 转mp3路经
@property (nonatomic, copy) NSString *rootPath;             // 录音文件根路径

+ (instancetype)sharedInstance;

- (BOOL)canRecord;

- (BOOL)isRecording;

- (NSString *)getCurrentRecordPath;

- (NSArray *)getHistoryList;

- (void)startRecord;

- (void)stopRecord;

- (void)releaseResource;

+ (void)destoryInstance;

@end

NS_ASSUME_NONNULL_END
