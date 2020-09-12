//
//  WBScreenRecordUtil.m
//  WBLiveKit
//
//  Created by bing on 2016/12/14.
//  Copyright © 2016年 wangchun. All rights reserved.
//

#import "WBScreenRecordUtil.h"
#import "ASScreenRecorder.h"
#import "WBAudioRecorder.h"
#import "WBVideoUtil.h"

#define VIDEO_NAME @"ibeelive"

@interface WBScreenRecordUtil()<WBAudioRecorderDelegate,ASScreenRecorderDelegate>
{
    NSString *screenVideoPath;
    NSString *screenAudioPath;
}

@end

@implementation WBScreenRecordUtil


+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WBScreenRecordUtil *mWBScreenRecordUtil;
    dispatch_once(&once, ^{
        mWBScreenRecordUtil = [[self alloc] init];
    });
    return mWBScreenRecordUtil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRecording = NO;
        screenVideoPath = [self tempFileURL];
        screenAudioPath = [self getPathByFileName:VIDEO_NAME ofType:@"mp4"];
    }
    return self;
}

- (NSString*)tempFileURL
{
    NSString *outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/screenCapture.mp4"];
    return outputPath;
}

-(void) startScreemRecord
{
    [self startScreemRecordByView:nil];
}

-(void) startScreemRecordByView:(UIView *) recordView
{
    if([ASScreenRecorder sharedInstance].isRecording) return;
    self.isRecording = YES;
    //    [[ASScreenRecorder sharedInstance] setVideoURL:[NSURL URLWithString:screenVideoPath]];
    [ASScreenRecorder sharedInstance].fps = 5;
    [ASScreenRecorder sharedInstance].delegate = self;
    [[ASScreenRecorder sharedInstance] startRecordingByView:recordView];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:screenAudioPath]){
        [fileManager removeItemAtPath:screenAudioPath error:nil];
    }
    [self performSelector:@selector(toStartAudioRecord:) withObject:screenAudioPath afterDelay:0.1];
}

-(void) toStartAudioRecord:(NSString *) filePath
{
    [WBAudioRecorder sharedInstance].delegate = self;
    [[WBAudioRecorder sharedInstance] beginAudioRecordByFileName:filePath];
}

-(void) stopScreemRecord
{
    self.isRecording = NO;
    [[ASScreenRecorder sharedInstance] stopRecordingWithCompletion:^{
        [[WBAudioRecorder sharedInstance] finishAudioRecord];
    }];
}

-(void) stopScreemRecordAndGenPreview
{
    self.isRecording = NO;
    [[ASScreenRecorder sharedInstance] stopRecordingWithCompletion:^{
        [[WBAudioRecorder sharedInstance] finishAudioRecordAndGenPreview];
    }];
}

-(void) pauseScreemRecord
{
    [[ASScreenRecorder sharedInstance] pauseRecording];
    [[WBAudioRecorder sharedInstance] pauseAudioRecord];
}

-(void) resumeScreemRecord
{
    [[ASScreenRecorder sharedInstance] resumeRecording];
    [[WBAudioRecorder sharedInstance] startAudioRecord];
}

- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:_type];
    return fileDirectory;
}

- (void)mergedidFinish:(NSArray *)info WithError:(NSError *)error
{
    NSString *videoPath = [info objectAtIndex:0];
    NSInteger videDuration = [[info objectAtIndex:1] integerValue];

    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];

    
    [WBVideoUtil removeTempFilePath:tempFilePath];
    [self removeVideoAtPath:videoPath to:tempFilePath];
    
    if([self.delegate respondsToSelector:@selector(megerTempVideoPathFinish)]){
        [self.delegate megerTempVideoPathFinish];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]) {
//        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
//        [allFileArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]];
//        [allFileArr insertObject:courseFileName atIndex:0];
//        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
//    }
//    else{
//        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
//        [allFileArr addObject:courseFileName];
//        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
//    }
    //    //音频与视频合并结束，存入相册中
    //    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
    //        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    //    }

}

- (void)mergedidPreviewFinish:(NSArray *)info WithError:(NSError *)error
{
    NSString *videoPath = [info objectAtIndex:0];
    NSInteger videDuration = [[info objectAtIndex:1] integerValue];
    
    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];
    
    [WBVideoUtil removeTempFilePath:tempFilePath];
    [self removeVideoAtPath:videoPath to:tempFilePath];
    [self genPreviewRecord];
}

-(void) genPreviewRecord
{
    NSString *previewFileName=[NSString stringWithFormat:@"%@-video-preview.mp4",self.courseId];
    NSString *previewFilePath = [self.draftUrl stringByAppendingPathComponent:previewFileName];
    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];
    
    NSString* courseFileName=[NSString stringWithFormat:@"%@-video.mp4",self.courseId];
    NSString *courseFilePath = [self.courseUrl stringByAppendingPathComponent:courseFileName];
    
    if ([WBVideoUtil isTempFileExist:tempFilePath]) {//临时文件存在时
        if ([WBVideoUtil isTempFileExist:previewFilePath]) {//如果临时文件存在和预览文件存在时合并两个文件
            NSArray *videoArr = [NSArray arrayWithObjects:previewFilePath,tempFilePath, nil];
            [WBVideoUtil mergeVideoToOneVideo:videoArr toStorePath:previewFilePath success:^{
                
            } failure:^{
                
            }];
        }else{
            if([WBVideoUtil isTempFileExist:courseFilePath]){
                NSArray *videoArr = [NSArray arrayWithObjects:courseFilePath,tempFilePath, nil];//如果临时文件存在和预览文件不存在时合并courseFilePath 和 tempFilePath
                [WBVideoUtil mergeVideoToOneVideoDeleteTemp:videoArr toStorePath:previewFilePath success:^{
                    
                } failure:^{
                }];
            }else{
                [self removeVideoAtPath:tempFilePath to:previewFilePath];
            }
        }
    }
}

-(void) generatePreviewRecord;
{
    
    NSString *previewFileName=[NSString stringWithFormat:@"%@-video-preview.mp4",self.courseId];
    NSString *previewFilePath = [self.draftUrl stringByAppendingPathComponent:previewFileName];
    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];
    
    
    NSString* courseFileName=[NSString stringWithFormat:@"%@-video.mp4",self.courseId];
    NSString *courseFilePath = [self.courseUrl stringByAppendingPathComponent:courseFileName];
    
    if ([WBVideoUtil isTempFileExist:tempFilePath]) {//临时文件存在时
        if ([WBVideoUtil isTempFileExist:previewFilePath]) {//如果临时文件存在和预览文件存在时合并两个文件
            NSArray *videoArr = [NSArray arrayWithObjects:previewFilePath,tempFilePath, nil];
            [WBVideoUtil mergeVideoToOneVideo:videoArr toStorePath:previewFilePath success:^{
                if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                    [self.delegate previewRecordPath:previewFilePath];
                }
            } failure:^{
                if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                    [self.delegate previewRecordPath:nil];
                }
            }];
        }else{
            if([WBVideoUtil isTempFileExist:courseFilePath]){
                NSArray *videoArr = [NSArray arrayWithObjects:courseFilePath,tempFilePath, nil];//如果临时文件存在和预览文件不存在时合并courseFilePath 和 tempFilePath
                [WBVideoUtil mergeVideoToOneVideoDeleteTemp:videoArr toStorePath:previewFilePath success:^{
                    if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                        [self.delegate previewRecordPath:previewFilePath];
                    }
                } failure:^{
                    if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                        [self.delegate previewRecordPath:nil];
                    }
                }];
            }else{
                [self removeVideoAtPath:tempFilePath to:previewFilePath];
                if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                    [self.delegate previewRecordPath:previewFilePath];
                }

            }
        }
    }else{
        if ([WBVideoUtil isTempFileExist:previewFilePath]) {//如果临时文件不存在和预览文件存在时，返回previewFilePath
            if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                [self.delegate previewRecordPath:previewFilePath];
            }
        }else{
            if ([WBVideoUtil isTempFileExist:courseFilePath]) {//如果临时文件不存在和预览文件不存在时，返回courseFilePath
                if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                    [self.delegate previewRecordPath:courseFilePath];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(previewRecordPath:)]) {
                    [self.delegate previewRecordPath:nil];
                }
            }
        }
    }
}

-(void) saveFinalRecordVideo
{
    NSString *previewFileName=[NSString stringWithFormat:@"%@-video-preview.mp4",self.courseId];
    NSString *previewFilePath = [self.draftUrl stringByAppendingPathComponent:previewFileName];
    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];
    
    
    NSString* courseFileName=[NSString stringWithFormat:@"%@-video.mp4",self.courseId];
    NSString *courseFilePath = [self.courseUrl stringByAppendingPathComponent:courseFileName];
    
    self.recordName = courseFileName;
    
    if ([WBVideoUtil isTempFileExist:tempFilePath]) {
        if ([WBVideoUtil isTempFileExist:previewFilePath]) {
            [WBVideoUtil removeTempFilePath:courseFilePath];
            NSArray *videoArr = [NSArray arrayWithObjects:previewFilePath,tempFilePath, nil];
            [WBVideoUtil mergeVideoToOneVideo:videoArr toStorePath:courseFilePath success:^{
                if ([self.delegate respondsToSelector:@selector(saveCourseVideoFinish)]) {
                    [self.delegate saveCourseVideoFinish];
                }
            } failure:^{
                
            }];
        }else{
            if ([WBVideoUtil isTempFileExist:courseFilePath]) {
                NSArray *videoArr = [NSArray arrayWithObjects:courseFilePath,tempFilePath, nil];
                [WBVideoUtil mergeVideoToOneVideo:videoArr toStorePath:courseFilePath success:^{
                    if ([self.delegate respondsToSelector:@selector(saveCourseVideoFinish)]) {
                        [self.delegate saveCourseVideoFinish];
                    }
                } failure:^{
                    
                }];
            }else{
                [self removeVideoAtPath:tempFilePath to:courseFilePath];
                if ([self.delegate respondsToSelector:@selector(saveCourseVideoFinish)]) {
                    [self.delegate saveCourseVideoFinish];
                }
            }
        }
    }else{
        if ([WBVideoUtil isTempFileExist:previewFilePath]) {
            [WBVideoUtil removeTempFilePath:courseFilePath];
            [self removeVideoAtPath:previewFilePath to:courseFilePath];
        }else{
            if (![WBVideoUtil isTempFileExist:courseFilePath]) {
                self.recordName = nil;
                self.videDuration = 0;
            }
        }
        if ([self.delegate respondsToSelector:@selector(saveCourseVideoFinish)]) {
            [self.delegate saveCourseVideoFinish];
        }
    }
}

-(void) removeTempAndPreviewVideo
{
    NSString *previewFileName=[NSString stringWithFormat:@"%@-video-preview.mp4",self.courseId];
    NSString *previewFilePath = [self.draftUrl stringByAppendingPathComponent:previewFileName];
    
    NSString *tempFileName=[NSString stringWithFormat:@"%@-video-tmp.mp4",self.courseId];
    NSString *tempFilePath = [self.draftUrl stringByAppendingPathComponent:tempFileName];
    
    NSArray *videoArr = [NSArray arrayWithObjects:tempFilePath,previewFilePath, nil];
    [WBVideoUtil removeAllTempFilePath:videoArr];
}

-(void) setRecordView:(UIView *) recordView
{
    [[ASScreenRecorder sharedInstance] setRecordView:recordView];
}

-(void) removeVideoAtPath:(NSString *) fromPath to:(NSString *) toPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath]){
        NSError *err=nil;
        [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:&err];
    }
}

- (void)video: (NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    if (error) {
        NSLog(@"---%@",[error localizedDescription]);
    }
}

- (UIImage*) getVideoPreViewImage:(NSURL *) videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    CGImageRef thumbnailImageRef = NULL;
    CMTime thumbnailTime = [asset duration];
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:&thumbnailImageGenerationError];
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;

    return thumbnailImage;
}

#pragma mark-WBAudioRecorderDelegate
-(void) audioRecordComplete
{
    [WBVideoUtil mergeVideo:screenVideoPath andAudio:screenAudioPath andTarget:self andAction:@selector(mergedidFinish:WithError:)];
}

-(void) audioRecordAndGenPreViewComplete
{
    [WBVideoUtil mergeVideo:screenVideoPath andAudio:screenAudioPath andTarget:self andAction:@selector(mergedidPreviewFinish:WithError:)];
}

#pragma mark-ASScreenRecorderDelegate
- (void)recorderDuration:(NSInteger) vDuration
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(recorderDuration:)]) {
            [self.delegate recorderDuration:vDuration];
        }
    });
}



@end
