//
//  ApiTool.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "ApiTool.h"
#import <AFNetworking/AFNetworking-umbrella.h>
#import "URLConfig.h"
#import <SAMKeychain/SAMKeychain.h>

#define API_VERSION @"v1.0.7"

static NSError * defaultHttpError;
static AFHTTPSessionManager * manager;

@implementation ApiTool


+ (void)init {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"image/png",
                                                         @"application/x-www-form-urlencoded",
                                                         @"charset=UTF-8",
                                                         nil];
    
//    charset=UTF-8;application/x-www-form-urlencoded
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 120;
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    [manager.requestSerializer setValue:@"Wangli" forHTTPHeaderField:@"User-Agent"];
    
    manager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;//缓存，可在没有网络的情况下加
    if (TheUser.userMo.id_token.length != 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TheUser.userMo.id_token] forHTTPHeaderField:@"Authorization"];
    }
    defaultHttpError = [NSError errorWithDomain:@"NetworkCenter"
                                           code:0
                                       userInfo:@{@"msg" : @"天了噜，你的网络离家出走了，请重新尝试"}];
}

+ (AFSecurityPolicy *)customSecurityPolicy
{
    /** https */
    NSString*cerPath = [[NSBundle mainBundle] pathForResource:@"kyfw.12306.cn.cer"ofType:nil];
    NSData*cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet*set = [[NSSet alloc] initWithObjects:cerData,nil];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];
    return policy;
}


+(void) setToken:(NSString *)token
{
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
}

+ (void)postWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {

    url = [URLConfig domainUrl:url];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}

+ (void)getWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    url = [URLConfig domainUrl:url];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}

+ (void)putWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    
    url = [URLConfig domainUrl:url];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}


+ (void)deleteWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    url = [URLConfig domainUrl:url];
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}


+ (void)fileUploadWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params files:(NSArray *)files success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    url = [URLConfig domainUrl:url];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *tmpData in files) {
            NSString *name = [formatter stringFromDate:[NSDate date]];
            [formData appendPartWithFileData:tmpData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg", name] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSString *value = [NSString stringWithFormat:@"%@", uploadProgress];
        NSLog(@"value ====== %@", value);
        [Utils showHUDWithStatus:[NSString stringWithFormat:@"图片上传中%.2f %%", uploadProgress.fractionCompleted*100]];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}

+ (void)fileUploadWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params attFiles:(NSArray *)attFiles success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    url = [URLConfig domainUrl:url];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < attFiles.count; i++) {
            QiniuFileMo *fileMo = attFiles[i];
            
            if ([fileMo.fileType containsString:@"jpg"] || [fileMo.fileType containsString:@"png"]) {
                [formData appendPartWithFileData:fileMo.myData name:@"file" fileName:fileMo.fileName mimeType:@"image/png"];
            } else if ([fileMo.fileType containsString:@"mp3"]) {
                NSError *error = nil;
                NSURL *url = [NSURL fileURLWithPath:fileMo.url];
                [formData appendPartWithFileURL:url name:@"file" error:&error];
            } else if ([fileMo.fileType containsString:@"mp4"]||
                       [fileMo.fileType containsString:@"mov"]||
                       [fileMo.fileType containsString:@"avi"]) {
                NSError *error = nil;
                NSURL *url = [NSURL URLWithString:fileMo.url];
                [formData appendPartWithFileURL:url name:@"file" error:&error];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSString *value = [NSString stringWithFormat:@"%@", uploadProgress];
        NSLog(@"value ====== %@", value);
        [Utils showHUDWithStatus:[NSString stringWithFormat:@"附件上传中%.2f %%\n请勿退出应用", uploadProgress.fractionCompleted*100]];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}

+ (void)downTaskWithUrlStr:(NSString *)urlStr toPath:(NSString *)toPath andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成后的回调
     filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        [Utils showHUDWithStatus:[NSString stringWithFormat:@"下载中%.2f %%", downloadProgress.fractionCompleted*100]];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //保存的文件路径
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:toPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
    }];
    
    //执行Task
    [download resume];
}
// userSign单独
//+ (void)getUserSignWithUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
//    url = [URLConfig domainUrl:url];
//    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//}


+ (NSString *)getDeviceId
{
    NSString *currentDeviceUUIDStr = [SAMKeychain passwordForService:[Utils bundleId] account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:[Utils bundleId] account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

+ (NSError *)dealError:(NSError *)error {
    
    NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSDictionary *dic = nil;
    NSString *errorDomain = @"";
    if (data == nil) {
        if ([TheUser currentNetState] == AFNetworkReachabilityStatusNotReachable) {
            errorDomain = @"服务器连接中...";
            dic = @{@"message":@"服务器连接中..."};
        } else if ([TheUser currentNetState] == AFNetworkReachabilityStatusUnknown) {
            errorDomain = @"服务器连接中...";
            dic = @{@"message":@"服务器连接中..."};
        } else {
            errorDomain = @"请求超时";
            dic = @{@"message":@"请求超时"};
        }
    } else {
        NSError *err;
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        errorDomain = STRING(dic[@"message"]);
    }
    
    NSError *aError = [NSError errorWithDomain:errorDomain code:[STRING(dic[@"code"]) integerValue] userInfo:dic];
    if ([dic[@"code"] integerValue] == 401) {
        [Utils showToastMessage:@"身份授权失效，请重新登录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_LOGOUT_SUCCESS object:nil];
    }
    return aError;
}

//+ (NSError *)errorCode:(NSInteger)code userInfo:(NSDictionary *)dic {
//    return [NSError errorWithDomain:[NSString stringWithFormat:@"%ld",code]
//                               code:code
//                           userInfo:dic];
//}

+ (NSError *)defaultHttpError{
    return defaultHttpError;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)jspGetUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}

+ (void)jspPostUrl:(NSString *)url andParams:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *newError = [ApiTool dealError:error];
        if (fail) {
            fail(newError);
        };
    }];
}


@end
