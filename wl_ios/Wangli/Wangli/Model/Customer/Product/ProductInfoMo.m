//
//  ProductInfoMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ProductInfoMo.h"

@implementation ProductInfoMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"])
        return YES;
    
    return NO;
}

- (void)setAttachments:(NSArray<QiniuFileMo *><QiniuFileMo> *)attachments {
    _attachments = [QiniuFileMo arrayOfModelsFromDictionaries:attachments error:nil];
}

@end