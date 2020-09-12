//
//  JYIMUtils.m
//  HangGuo
//
//  Created by yeqiang on 2020/2/7.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "JYIMUtils.h"

@implementation JYIMUtils

+ (instancetype)standardJYIMUtils {
    
    static JYIMUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JYIMUtils alloc] init];
    });
    return instance;
}

+ (NSArray *)getIM_Helper_List {
    if (![JYIMUtils standardJYIMUtils].imHelperList) {
        [JYIMUtils standardJYIMUtils].imHelperList = [NSArray yy_modelArrayWithClass:[JYDictItemMo class] json:[NSUserDefaults getUserDefaultsWithKey:IM_HELPER_TYPE_LIST]];
    }
    return [JYIMUtils standardJYIMUtils].imHelperList;
}

+ (NSArray *)getIM_Style_List {
    if (![JYIMUtils standardJYIMUtils].imStyleList) {
        [JYIMUtils standardJYIMUtils].imStyleList = [NSArray yy_modelArrayWithClass:[JYDictItemMo class] json:[NSUserDefaults getUserDefaultsWithKey:IM_CONFIG_STYLE_LIST]];
    }
    return [JYIMUtils standardJYIMUtils].imStyleList;
}


+ (JYDictItemMo *)getIMHelperMoById:(NSString *)converId {
    for (int i = 0; i < [JYIMUtils standardJYIMUtils].imHelperList.count; i++) {
        JYDictItemMo *tmpMo = [JYIMUtils standardJYIMUtils].imHelperList[i];
        if ([tmpMo.code isEqualToString:converId]) {
            return tmpMo;
        }
    }
    return nil;
}

+ (JYDictItemMo *)getIMHelperStyleByStyle:(NSString *)style {
    for (int i = 0; i < [JYIMUtils standardJYIMUtils].imStyleList.count; i++) {
        JYDictItemMo *tmpMo = [JYIMUtils standardJYIMUtils].imStyleList[i];
        if ([tmpMo.code isEqualToString:style]) {
            return tmpMo;
        }
    }
    return nil;
}

+ (JYMessageDataModel *)getJYMessageDataModel:(NSDictionary *)param {
    JYMessageDataModel *mo = [JYMessageDataModel yy_modelWithDictionary:param];
    if ([mo.fromAccount containsString:@"_helper"]) {
        return mo;
    }
    return nil;
}

@end
