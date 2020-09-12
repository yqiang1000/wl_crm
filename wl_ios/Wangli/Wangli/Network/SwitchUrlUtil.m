//
//  SwitchUrlUtil.m
//  Wangli
//
//  Created by yeqiang on 2019/1/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SwitchUrlUtil.h"

static SwitchUrlUtil *urlUtil = nil;

@implementation SwitchUrlUtilMo

+ (SwitchUrlUtilMo *)setupWithStaticUrl:(NSString *)staticUrl {
    SwitchUrlUtilMo *mo  = [[SwitchUrlUtilMo alloc] init];
    mo.staticUrl = staticUrl;
    return mo;
}

@end

@implementation SwitchUrlUtil

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlUtil = [[SwitchUrlUtil alloc] init];
    });
    return urlUtil;
}


//#define DOMAIN_NAME                     @"http://crm-test-api.aikosolar.net%@"
//#define H5_URL                          @"http://crm-test-h5.aikosolar.net/#"
- (void)localUrlConfig {
    
    SwitchUrlUtilMo *urlMo = [[SwitchUrlUtilMo alloc] init];
    urlMo.urlKey = @"domain";
    urlMo.staticUrl = @"http://crm-test-api.aikosolar.net%@";

    
    NSDictionary *urls = @{@"domain":@"http://crm-test-api.aikosolar.net%@",
                           @"h5url":@"http://crm-test-h5.aikosolar.net/#"};
}


- (NSString *)imgUrlWithKey:(NSString *)key {
    return [URLConfig domainUrl:[NSString stringWithFormat:@"%@%@", FILE_ORG_READ, key]];
//    _thumbnail = [URLConfig domainUrl:[NSString stringWithFormat: FILE_THUMBNAIL_READ, _qiniuKey]];
//    return [NSString stringWithFormat:DOMAIN_NAME, key];
}


@end
