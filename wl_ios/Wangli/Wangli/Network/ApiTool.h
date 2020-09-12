//
//  ApiTool.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiTool : NSObject

+ (void)init;

+ (void)setToken:(NSString *)token;

+ (NSString *)getDeviceId;

+ (NSError *)defaultHttpError;

+ (void)postWithUrl:(NSString *)url
          andParams:(NSMutableDictionary *)params
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))fail;

+ (void)getWithUrl:(NSString *)url
          andParams:(NSMutableDictionary *)params
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))fail;

+ (void)putWithUrl:(NSString *)url
         andParams:(NSMutableDictionary *)params
           success:(void (^)(id))success
           failure:(void (^)(NSError *))fail;

+ (void)deleteWithUrl:(NSString *)url
            andParams:(NSMutableDictionary *)params
              success:(void (^)(id))success
              failure:(void (^)(NSError *))fail;

+ (void)fileUploadWithUrl:(NSString *)url
                andParams:(NSMutableDictionary *)params
                    files:(NSArray *)files
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))fail;

+ (void)fileUploadWithUrl:(NSString *)url
                andParams:(NSMutableDictionary *)params
                 attFiles:(NSArray *)attFiles
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))fail;

+ (void)downTaskWithUrlStr:(NSString *)urlStr
                    toPath:(NSString *)toPath
                 andParams:(NSMutableDictionary *)params
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))fail;

+ (void)jspGetUrl:(NSString *)url
        andParams:(NSMutableDictionary *)params
          success:(void (^)(id))success
          failure:(void (^)(NSError *))fail;


+ (void)jspPostUrl:(NSString *)url
         andParams:(NSMutableDictionary *)params
           success:(void (^)(id))success
           failure:(void (^)(NSError *))fail;

// userSign单独
//+ (void)getUserSignWithUrl:(NSString *)url
//                 andParams:(NSMutableDictionary *)params
//                   success:(void (^)(id responseObject))success
//                   failure:(void (^)(NSError *error))fail;

@end
