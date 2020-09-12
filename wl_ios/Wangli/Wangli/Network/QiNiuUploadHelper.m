//
//  QiNiuUploadHelper.m
//  Wangli
//
//  Created by yeqiang on 2018/5/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "QiNiuUploadHelper.h"
#import <Qiniu/QiniuSDK.h>
#import "QiniuFileMo.h"

typedef void(^UploadSuccess)(id responseObject);
typedef void(^UploadFail)(id error);

@interface QiNiuUploadHelper ()

@property (nonatomic, strong) NSMutableArray *totalArr;
@property (nonatomic, assign) NSInteger uploadTag;
@property (nonatomic, strong) NSArray *arrImages;
@property (nonatomic, strong) QNUploadManager *upManager;
@property (nonatomic, strong) NSMutableArray *imgUrls;
@property (nonatomic, copy) UploadSuccess uploadSuccess;
@property (nonatomic, copy) UploadFail uploadFail;
@property (nonatomic, copy) NSString *timeStr;

@end

@implementation QiNiuUploadHelper

- (void)uploadImages:(NSArray *)iamges
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail {
    self.arrImages = iamges;
    self.uploadSuccess = success;
    self.uploadFail = fail;
    //1.获取所有的图片
    NSMutableArray *imageArray = [self getArrImgDataWithImgs:self.arrImages];
    self.uploadTag = imageArray.count;
    [Utils showHUDWithStatus:nil];
    if (self.uploadTag > 0) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            [_imgUrls removeAllObjects];
            _imgUrls = nil;
            for (int i = 0; i < imageArray.count; i ++ ) {
                [self.imgUrls addObject:@(i)];
                [self uploadQNUploadManager:upManager data:imageArray[i] tag:i success:^(id responseObject) {
                    [self.imgUrls replaceObjectAtIndex:i withObject:STRING(responseObject)];
                    self.uploadTag = self.uploadTag - 1;
                } failure:^(NSError *error) {
                    if (self.uploadFail) {
                        self.uploadFail(error);
                    }
                    return;
                }];
            }
        });
    }
}

- (void)uploadPublicImages:(NSArray *)iamges
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    self.arrImages = iamges;
    self.uploadSuccess = success;
    self.uploadFail = fail;
    //1.获取所有的图片
    NSMutableArray *imageArray = [self getArrImgDataWithImgs:self.arrImages];
    self.uploadTag = imageArray.count;
    [Utils showHUDWithStatus:nil];
    if (self.uploadTag > 0) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            [_imgUrls removeAllObjects];
            _imgUrls = nil;
            for (int i = 0; i < imageArray.count; i ++ ) {
                [self.imgUrls addObject:@(i)];
                [self uploadQNUploadManagerOpen:upManager data:imageArray[i] tag:i success:^(id responseObject) {
                    [self.imgUrls replaceObjectAtIndex:i withObject:STRING(responseObject)];
                    self.uploadTag = self.uploadTag - 1;
                } failure:^(NSError *error) {
                    if (self.uploadFail) {
                        self.uploadFail(error);
                    }
                    return;
                }];
            }
        });
    }
}

- (void)uploadFileMulti:(NSArray *)images
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    self.arrImages = images;
    self.uploadSuccess = success;
    self.uploadFail = fail;
    //1.获取所有的图片 包含 QiuNiuMo和data
    [_imgUrls removeAllObjects];
    _imgUrls = nil;
    NSMutableArray *imageArray = [self getArrImgDataWithImgs:self.arrImages];
    if (imageArray.count > 0) {
        [Utils showHUDWithStatus:_tostStr.length == 0 ? @"正在上传附件" : _tostStr];
        [[JYUserApi sharedInstance] fileUploadMultiParam:nil list:imageArray success:^(id responseObject) {
            NSError *error = nil;
            NSMutableArray *arrResponse = [QiniuFileMo arrayOfModelsFromDictionaries:responseObject error:&error];
            NSInteger tag = 0;
            for (int i = 0; i < self.imgUrls.count; i++) {
                id obj = self.imgUrls[i];
                if ([obj isKindOfClass:[NSNumber class]]) {
                    [self.imgUrls replaceObjectAtIndex:i withObject:arrResponse[tag]];
                    tag++;
                }
            }
            if (self.uploadSuccess) {
                self.uploadSuccess(self.imgUrls);
            }
        } failure:^(NSError *error) {
            [Utils showToastMessage:@"上传失败"];
            if (self.uploadFail) {
                self.uploadFail(error);
            }
        }];
    } else {
        if (self.uploadSuccess) {
            self.uploadSuccess(self.imgUrls);
        }
    }
}

- (void)uploadImages:(NSArray *)images
              voices:(NSArray *)voices
              videos:(NSArray *)videos
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail {
    self.totalArr = [[NSMutableArray alloc] init];
    if (images.count > 0) [self.totalArr addObjectsFromArray:images];
    if (voices.count > 0) [self.totalArr addObjectsFromArray:voices];
    if (videos.count > 0) [self.totalArr addObjectsFromArray:videos];
    self.uploadSuccess = success;
    self.uploadFail = fail;
    self.timeStr = @"";
    //1.获取所有的附件 包含 QiuNiuMo和data 图片语音
    [_imgUrls removeAllObjects];
    _imgUrls = nil;
    NSMutableArray *imageArray = [self dealWithTotalArr:self.totalArr];
    if (imageArray.count > 0) {
        [Utils showHUDWithStatus:_tostStr.length == 0 ? @"正在上传附件" : _tostStr];
        NSMutableDictionary *param = [NSMutableDictionary new];
        if (self.timeStr.length > 0) [param setObject:STRING(self.timeStr) forKey:@"extData"];
        [[JYUserApi sharedInstance] fileUploadMultiParam:param attFiles:imageArray success:^(id responseObject) {
            NSError *error = nil;
            NSMutableArray *arrResponse = [QiniuFileMo arrayOfModelsFromDictionaries:responseObject error:&error];
            NSInteger tag = 0;
            for (int i = 0; i < self.imgUrls.count; i++) {
                id obj = self.imgUrls[i];
                if ([obj isKindOfClass:[NSNumber class]]) {
                    
//                    QiniuFileMo *model = arrResponse[tag];
//                    if ([model.fileType containsString:@"mp3"]) {
//                        QiniuFileMo *orgMo = imageArray[tag];
//                        model.extData = orgMo.extData;
//                    }
                    if (tag < arrResponse.count) {
                        [self.imgUrls replaceObjectAtIndex:i withObject:arrResponse[tag]];
                    }
                    tag++;
                }
            }
            if (self.uploadSuccess) {
                self.uploadSuccess(self.imgUrls);
            }
        } failure:^(NSError *error) {
            [Utils showToastMessage:@"上传失败"];
            if (self.uploadFail) {
                self.uploadFail(error);
            }
        }];
    } else {
        if (self.uploadSuccess) {
            self.uploadSuccess(self.imgUrls);
        }
    }
}


- (void)uploadQNUploadManager:(QNUploadManager *)upManager
                         data:(id)data
                          tag:(NSInteger)tag
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    if ([data isKindOfClass:[NSString class]]) {
        [self.imgUrls replaceObjectAtIndex:tag withObject:STRING(data)];
        self.uploadTag = self.uploadTag - 1;
        return;
    }
    [[JYUserApi sharedInstance] getQiNiuUploadTokenSuccess:^(id responseObject) {
    NSString *token = responseObject[@"content"];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            [Utils showHUDWithStatus:_tostStr.length == 0 ? @"正在上传附件" : _tostStr];
        } params:nil checkCrc:NO cancellationSignal:nil];
        [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                if (success) {
                    success(STRING(resp[@"key"]));
                }
            }else{
                if (fail) {
                    fail(nil);
                }
            }
        } option:uploadOption];
        
    } failure:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

- (void)uploadQNUploadManagerOpen:(QNUploadManager *)upManager
                             data:(id)data
                              tag:(NSInteger)tag
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    
    if ([data isKindOfClass:[NSString class]]) {
        [self.imgUrls replaceObjectAtIndex:tag withObject:STRING(data)];
        self.uploadTag = self.uploadTag - 1;
        return;
    }
    [[JYUserApi sharedInstance] getQiNiuUploadTokenOpenSuccess:^(id responseObject) {
        NSString *token = responseObject[@"content"];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            [Utils showHUDWithStatus:_tostStr.length == 0 ? @"正在上传附件" : _tostStr];
        } params:nil checkCrc:NO cancellationSignal:nil];
        [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                if (success) {
                    success(STRING(resp[@"key"]));
                }
            }else{
                if (fail) {
                    fail(nil);
                }
            }
        } option:uploadOption];
        
    } failure:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

//- (NSMutableArray *)getArrImgDataWithImgs:(NSArray *)arrImgs {
//    NSMutableArray *arrData = [NSMutableArray new];
//    for (int i = 0; i < arrImgs.count; i++) {
//        id obj = arrImgs[i];
//        if ([obj isKindOfClass:[UIImage class]]) {
//            UIImage *image =(UIImage *)obj;
//            // 压缩图片
//            NSData *data = [self zipNSDataWithImage:image];
//            [arrData addObject:data];
//            // 占位
//            [self.imgUrls addObject:@(i)];
//        } else {
//            [arrData addObject:STRING(obj)];
//            [self.imgUrls addObject:STRING(obj)];
//        }
//    }
//    return arrData;
//}

- (NSMutableArray *)getArrImgDataWithImgs:(NSArray *)arrImgs {
    NSMutableArray *arrData = [NSMutableArray new];
    for (int i = 0; i < arrImgs.count; i++) {
        id obj = arrImgs[i];
        if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *image =(UIImage *)obj;
            // 压缩图片
            NSData *data = [self zipNSDataWithImage:image];
            [arrData addObject:data];
            // 占位
            [self.imgUrls addObject:@(i)];
        } else {
            [self.imgUrls addObject:STRING(obj)];
        }
    }
    return arrData;
}

- (NSMutableArray *)dealWithTotalArr:(NSMutableArray *)totalArr {
    
    NSMutableArray *arrData = [NSMutableArray new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    for (int i = 0; i < totalArr.count; i++) {
        id obj = totalArr[i];
        if ([obj isKindOfClass:[UIImage class]]) {
            
            UIImage *image =(UIImage *)obj;
            // 压缩图片
            NSData *data = [self zipNSDataWithImage:image];
            QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] init];
            qiniuMo.myData = data;
            qiniuMo.fileType = @"jpg";
            qiniuMo.fileName = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:[NSDate date]]];
            [arrData addObject:qiniuMo];
            // 占位
            [self.imgUrls addObject:@(i)];
            self.timeStr = [self.timeStr stringByAppendingString:@"0"];
            if (i < totalArr.count-1) self.timeStr = [self.timeStr stringByAppendingString:@","];
        }
        else if ([obj isKindOfClass:[QiniuFileMo class]]) {
            QiniuFileMo *fileMo = (QiniuFileMo *)obj;
            // 录音
            if ([fileMo.fileType containsString:@"mp3"]||
                [fileMo.fileType containsString:@"mp4"]||
                [fileMo.fileType containsString:@"mov"]||
                [fileMo.fileType containsString:@"avi"]) {
                // 网络资源不需要上传
                if ([fileMo.url containsString:@"https"] || [fileMo.url containsString:@"http"]) {
                    [self.imgUrls addObject:STRING(obj)];
                } else {
                    [arrData addObject:fileMo];
                    // 占位
                    [self.imgUrls addObject:@(i)];
                    self.timeStr = [self.timeStr stringByAppendingString:[NSString stringWithFormat:@"%lld", fileMo.extData]];
                    if (i < totalArr.count-1) self.timeStr = [self.timeStr stringByAppendingString:@","];
                }
            }
            // 图片
            else if ([fileMo.fileType containsString:@"jpg"] || [fileMo.fileType containsString:@"png"]) {
                [self.imgUrls addObject:STRING(obj)];
            }
        }
        else {
            [self.imgUrls addObject:STRING(obj)];
        }
    }
    return arrData;
}


- (void)setUploadTag:(NSInteger)uploadTag {
    _uploadTag = uploadTag;
    if (_uploadTag == 0) {
        // 所有都上传成功
        if (self.uploadSuccess) {
            
            NSMutableArray *arr = [NSMutableArray new];
            for (NSString *key in self.imgUrls) {
                [arr addObject:@{@"qiniuKey":STRING(key)}];
            }
            self.uploadSuccess(arr);
        }
    } else {
        // 未完成不处理，可能失败
    }
}

- (NSMutableArray *)imgUrls {
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray new];
    }
    return _imgUrls;
}

- (NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}


@end
