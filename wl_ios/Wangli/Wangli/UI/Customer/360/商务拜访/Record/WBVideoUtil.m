//
//  WBVideoUtil.m
//  WBLiveKit
//
//  Created by bing on 2016/12/14.
//  Copyright © 2016年 wangchun. All rights reserved.
//

#import "WBVideoUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation WBVideoUtil

+ (void)mergeVideo:(NSString *)videoPath andAudio:(NSString *)audioPath andTarget:(id)target andAction:(SEL)action
{
    NSURL *audioUrl=[NSURL fileURLWithPath:audioPath];
    NSURL *videoUrl=[NSURL fileURLWithPath:videoPath];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    //混合音乐
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *audioTracks = [NSArray arrayWithArray: [audioAsset tracksWithMediaType:AVMediaTypeAudio]];
    [compositionCommentaryTrack insertTimeRange:videoTimeRange
                                        ofTrack:([audioTracks count]>0)?[audioTracks objectAtIndex:0]:nil
                                         atTime:kCMTimeZero error:nil];
    
    
    //混合视频
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *videoTracks = [NSArray arrayWithArray: [videoAsset tracksWithMediaType:AVMediaTypeVideo]];
    [compositionVideoTrack insertTimeRange:videoTimeRange
                                   ofTrack:([videoTracks count]>0)?[videoTracks objectAtIndex:0]:nil
                                    atTime:kCMTimeZero error:nil];
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    
    
    //[audioAsset release];
    //[videoAsset release];
    
    //保存混合后的文件的过程
    NSString* videoName = @"export2.mov";
    NSString *exportPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:videoName];
    [self removeTempFilePath:exportPath];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;// @"com.apple.quicktime-movie";
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) 
     {    
         NSLog(@"音视频混合完成");
         if ([target respondsToSelector:action])
         {
             NSUInteger dTotalSeconds = CMTimeGetSeconds(videoAsset.duration);
             NSArray *objectArr = [NSArray arrayWithObjects:exportPath,@(dTotalSeconds), nil];
             [target performSelector:action withObject:objectArr withObject:nil];
         }
         [self removeTempFilePath:videoPath];
         [self removeTempFilePath:audioPath];
     }];
    
    //[_assetExport release];
}

+(BOOL)isTempFileExist:(NSString *) filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+(void)removeAllTempFilePath:(NSArray*) fileArray
{
    for (NSInteger i=0; i < [fileArray count]; i++) {
        NSString *path = (NSString*)[fileArray objectAtIndex:i];
        [self removeTempFilePath:path];
    }
}


+(void)removeTempFilePath:(NSString*)filePath
{
    if ([self isTempFileExist:filePath]) {
        NSError* error;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording:%@", [error localizedDescription]);
        }
    }
}

+ (void)removeContentsOfDirectory:(NSString*)directory withExtension:(NSString*)extension
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:directory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if (extension != nil) {
            if ([[filename pathExtension] hasPrefix:extension]) {
                
                [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
            }
        }else{
            [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

+(void)mergeVideoToOneVideo:(NSArray *)tArray toStorePath:(NSString *)storePath success:(void (^)(void))successBlock failure:(void (^)(void))failureBlcok
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime startTime = kCMTimeZero;
    
    for (NSInteger i=0; i < [tArray count]; i++) {
        
        NSString *path = (NSString*)[tArray objectAtIndex:i];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        
        NSArray *audioTracks = [NSArray arrayWithArray: [asset tracksWithMediaType:AVMediaTypeAudio]];
        NSArray *videoTracks = [NSArray arrayWithArray: [asset tracksWithMediaType:AVMediaTypeVideo]];
        AVAssetTrack *videoTrack = ([videoTracks count]>0)?[videoTracks firstObject]:nil;
        AVAssetTrack *audioTrack = ([audioTracks count]>0)?[audioTracks firstObject]:nil;
        
        //set the orientation
        if(i == 0)
        {
            [compositionVideoTrack setPreferredTransform:videoTrack.preferredTransform];
        }
        
        NSError *videoError = nil;
        BOOL ok1 = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:videoTrack atTime:startTime error:&videoError];
        NSLog(@"mergeVideoToOneVideo errorVideo:%@%d",videoError,ok1);
        NSError *audioError = nil;
        BOOL ok2 = [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:audioTrack atTime:startTime error:&audioError];
        NSLog(@"mergeVideoToOneVideo errorVideo:%@%d",audioError,ok1);
        
        startTime = CMTimeAdd(startTime, [asset duration]);
    }
    
    [self removeAllTempFilePath:tArray];
    NSURL *exportUrl = [[NSURL alloc] initFileURLWithPath: storePath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                      presetName:AVAssetExportPresetPassthrough];
    exporter.outputURL = exportUrl;
    exporter.outputFileType = [[exporter supportedFileTypes] objectAtIndex:0];
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"视频混合完成");
        successBlock();
    }];
}

+(void)mergeVideoToOneVideoDeleteTemp:(NSArray *)tArray toStorePath:(NSString *)storePath success:(void (^)(void))successBlock failure:(void (^)(void))failureBlcok
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime startTime = kCMTimeZero;
    
    for (NSInteger i=0; i < [tArray count]; i++) {
        
        NSString *path = (NSString*)[tArray objectAtIndex:i];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        
        NSArray *audioTracks = [NSArray arrayWithArray: [asset tracksWithMediaType:AVMediaTypeAudio]];
        NSArray *videoTracks = [NSArray arrayWithArray: [asset tracksWithMediaType:AVMediaTypeVideo]];
        AVAssetTrack *videoTrack = ([videoTracks count]>0)?[videoTracks objectAtIndex:0]:nil;
        AVAssetTrack *audioTrack = ([audioTracks count]>0)?[audioTracks objectAtIndex:0]:nil;
        
        //set the orientation
        if(i == 0)
        {
            [compositionVideoTrack setPreferredTransform:videoTrack.preferredTransform];
        }
        
        NSError *videoError = nil;
        BOOL ok1 = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:videoTrack atTime:startTime error:&videoError];
        NSLog(@"mergeVideoToOneVideo errorVideo:%@%d",videoError,ok1);
        NSError *audioError = nil;
        BOOL ok2 = [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:audioTrack atTime:startTime error:&audioError];
        NSLog(@"mergeVideoToOneVideo errorVideo:%@%d",audioError,ok1);
        
        startTime = CMTimeAdd(startTime, [asset duration]);
    }
    if([tArray count]>1){
        [self removeTempFilePath:tArray[1]];
    }
    NSURL *exportUrl = [[NSURL alloc] initFileURLWithPath: storePath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                      presetName:AVAssetExportPresetPassthrough];
    exporter.outputURL = exportUrl;
    exporter.outputFileType = [[exporter supportedFileTypes] objectAtIndex:0];
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"视频混合完成");
        successBlock();
    }];
}

+(void)mergeAudioToOneAudio:(NSArray *)tArray toStorePath:(NSString *)storePath isDelTemp:(BOOL)isDelTemp success:(void (^)(NSInteger vDuration))successBlock failure:(void (^)(void))failureBlcok
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime startTime = kCMTimeZero;
    
    for (NSInteger i=0; i < [tArray count]; i++) {
        
        NSString *path = (NSString*)[tArray objectAtIndex:i];
        
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        if (asset == nil) continue;
        
        NSArray *audioTracks = [NSArray arrayWithArray: [asset tracksWithMediaType:AVMediaTypeAudio]];
        AVAssetTrack *audioTrack = ([audioTracks count]>0)?[audioTracks objectAtIndex:0]:nil;
        if (audioTrack == nil) continue;
        
        //set the orientation
        NSError *audioError = nil;
        float duration = [asset duration].value;
        BOOL ok2 = [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:audioTrack atTime:startTime error:&audioError];
        NSLog(@"mergeAudioToOneAudio errorVideo:%@%d",audioError,ok2);
        
        startTime = CMTimeAdd(startTime, [asset duration]);
    }
  
    if (isDelTemp) {
        for (int i=0; i<[tArray count]; i++) {
            if (![tArray[i] isEqualToString:storePath]) {
                [self removeTempFilePath:tArray[i]];
            }
        }
    }
    [self removeTempFilePath:storePath];
    
    NSURL *exportUrl = [[NSURL alloc] initFileURLWithPath: storePath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                      presetName:AVAssetExportPresetAppleM4A];
    exporter.outputURL = exportUrl;
    exporter.outputFileType = [[exporter supportedFileTypes] objectAtIndex:0];
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        NSLog(@"音频混合完成");
        AVURLAsset *assetTmp = [AVURLAsset URLAssetWithURL:exportUrl options:nil];
        successBlock(assetTmp.duration.value/assetTmp.duration.timescale);
    }];
}


@end
