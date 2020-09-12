//
//  WBVideoUtil.h
//  WBLiveKit
//
//  Created by bing on 2016/12/14.
//  Copyright © 2016年 wangchun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBVideoUtil : NSObject

+ (void)mergeVideo:(NSString *)videoPath andAudio:(NSString *)audioPath andTarget:(id)target andAction:(SEL)action;

+ (void)removeTempFilePath:(NSString*)filePath;

+ (void)removeContentsOfDirectory:(NSString*)directory withExtension:(NSString*)extension;

+ (void)mergeVideoToOneVideoDeleteTemp:(NSArray *)tArray toStorePath:(NSString *)storePath success:(void (^)(void))successBlock failure:(void (^)(void))failureBlcok;

+ (void)mergeVideoToOneVideo:(NSArray *)tArray toStorePath:(NSString *)storePath success:(void (^)(void))successBlock failure:(void (^)(void))failureBlcok;

+(void)mergeAudioToOneAudio:(NSArray *)tArray toStorePath:(NSString *)storePath isDelTemp:(BOOL)isDelTemp success:(void (^)(NSInteger vDuration))successBlock failure:(void (^)(void))failureBlcok;

+ (BOOL)isTempFileExist:(NSString *) filePath;

+ (void)removeAllTempFilePath:(NSArray*) fileArray;

@end
