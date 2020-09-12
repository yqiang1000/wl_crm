//
//  TaskMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TaskMo.h"

@implementation TaskMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"updateAble"]||
        [propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"favoriteAble"])
        return YES;
    return NO;
}

- (void)setAttachmentList:(NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)attachmentList {
    NSError *error = nil;
    _attachmentList = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachmentList error:&error];
}

@end
