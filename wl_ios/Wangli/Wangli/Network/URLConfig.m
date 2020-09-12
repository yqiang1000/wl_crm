//
//  URLConfig.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "URLConfig.h"

@implementation URLConfig

+ (NSString *)domainUrl:(NSString *) url {
    return [NSString stringWithFormat:DOMAIN_NAME, url];
}

+ (NSString *)domainUrl:(NSString *)url withToken:(NSString *)token {
    url = [NSString stringWithFormat:DOMAIN_NAME, url];
    return [self url:url withToken:token];
}

+ (NSString *)url:(NSString *)url withToken:(NSString *)token {
    NSString * tokenParam = [url rangeOfString:@"?"].location != NSNotFound ? @"&token=%@" : @"?token=%@";
    return [url stringByAppendingFormat:tokenParam, token];
}

@end
