//
//  QiNiuUploadHelper.h
//  Wangli
//
//  Created by yeqiang on 2018/5/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiNiuUploadHelper : NSObject

@property (nonatomic, copy) NSString *tostStr;

// 上传私有的图片
- (void)uploadImages:(NSArray* )iamges
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail;

// 上传共有的图片
- (void)uploadPublicImages:(NSArray* )iamges
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;


- (void)uploadFileMulti:(NSArray *)images
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

- (void)uploadImages:(NSArray *)images
              voices:(NSArray *)voices
              videos:(NSArray *)videos
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail;

@end
