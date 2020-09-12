//
//  UserLocalDataUtils.m
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "UserLocalDataUtils.h"

@implementation UserLocalDataUtils

+ (NSMutableDictionary *)remarkList {
    //获取plist文件字典
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[UserLocalDataUtils getPlistPath]];
    if (rootDic == nil) {
        rootDic = [[NSMutableDictionary alloc] init];
    }
    return rootDic;
}

+ (NSString *)getPlistPath {
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *userPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userLocalData_%ld", TheUser.userMo.id]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [userPath stringByAppendingPathComponent:@"tmpRemark.plist"];
    return plistPath;
}

/** 保存信息 */
+ (void)saveRemark:(long long)msgId msgType:(NSString *)msgType {
    NSMutableDictionary *rootDic = [UserLocalDataUtils remarkList];
    NSMutableArray *msgIds = [[NSMutableArray alloc] initWithArray:[rootDic objectForKey:msgType]];
    if (msgIds == nil) {
        msgIds = [NSMutableArray new];
    }
    if (![msgIds containsObject:@(msgId)]) {
        [msgIds addObject:@(msgId)];
        if (msgIds && msgType) {
            [rootDic setObject:msgIds forKey:msgType];
            [rootDic writeToFile:[UserLocalDataUtils getPlistPath] atomically:YES];
        }
    }
}


//@"rootDic":{
//    @"type1":@[@"id1", @"id2"],
//    @"type2":@[@"id3", @"id4"],
//}

/** 通过msgId获取信息 */
+ (BOOL)getRemarkByMsgId:(long long)msgId msgType:(NSString *)msgType {
    NSMutableDictionary *rootDic = [UserLocalDataUtils remarkList];
    NSMutableArray *msgIds = [[NSMutableArray alloc] initWithArray:[rootDic objectForKey:msgType]];
    return [msgIds containsObject:@(msgId)];
}

@end
