//
//  LocalRemarkHelp.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "LocalRemarkHelp.h"

@implementation LocalRemarkHelp


+ (NSMutableDictionary *)remarkList:(BOOL)fromDefault {
    //获取plist文件字典
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[LocalRemarkHelp getPlistPath:fromDefault]];
    if (rootDic == nil) {
        rootDic = [[NSMutableDictionary alloc] init];
    }
    return rootDic;
}

+ (NSString *)getPlistPath:(BOOL)fromDefault {
    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *userPath = [documentsPath stringByAppendingPathComponent:fromDefault?@"Used_helper" :TheUser.userMo.oaCode];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [userPath stringByAppendingPathComponent:@"remark.plist"];
    return plistPath;
}

/** 保存信息 */
+ (void)saveMsgId:(NSString *)msgId toConvType:(NSString *)toConvType remark:(BOOL)remark fromDefault:(BOOL)fromDefault {
    if (msgId.length == 0) return;
//    NSLog(@"\n msgId:%@\n toConvType:%@\n fromDefault:%ld", msgId, toConvType, fromDefault);
    NSMutableDictionary *rootDic = [LocalRemarkHelp remarkList:fromDefault];
    NSMutableArray *msgIds = [[NSMutableArray alloc] initWithArray:[rootDic objectForKey:toConvType]];
    if (msgIds == nil) {
        msgIds = [NSMutableArray new];
    }
    if (![msgIds containsObject:msgId]) {
        [msgIds addObject:STRING(msgId)];
    }
    if (msgIds && toConvType) {
        [rootDic setObject:msgIds forKey:toConvType];
        [rootDic writeToFile:[LocalRemarkHelp getPlistPath:fromDefault] atomically:YES];
    }
}

//@"rootDic":{
//    @"type1":@[@"id1", @"id2"],
//    @"type2":@[@"id3", @"id4"],
//}

/** 通过msgId获取信息 */
+ (BOOL)getRemarkByMsgId:(NSString *)msgId fromConvType:(NSString *)fromConvType fromDefault:(BOOL)fromDefault {
    NSMutableDictionary *rootDic = [LocalRemarkHelp remarkList:fromDefault];
    NSMutableArray *msgIds = [[NSMutableArray alloc] initWithArray:[rootDic objectForKey:fromConvType]];
    return [msgIds containsObject:msgId];
}


@end
