//
//  RiskFollowMo.m
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "RiskFollowMo.h"

@implementation RiskFollowMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"hasImgUrl"])
        return YES;
    
    return NO;
}

- (void)setAttachmentList:(NSArray<QiniuFileMo *><QiniuFileMo> *)attachmentList {
    _attachmentList = (NSArray<QiniuFileMo *><QiniuFileMo> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachmentList error:nil];
    _hasImgUrl = _attachmentList.count == 0 ? NO : YES;
    
    _arrImgs = [NSMutableArray new];
    _arrUrls = [NSMutableArray new];
    for (QiniuFileMo *mo in _attachmentList) {
        [_arrImgs addObject:STRING(mo.thumbnail)];
        [_arrUrls addObject:STRING(mo.url)];
    }
}

- (void)setAttachments:(NSArray<QiniuFileMo *><QiniuFileMo> *)attachments {
    _attachments = (NSArray<QiniuFileMo *><QiniuFileMo> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachments error:nil];
    _hasImgUrl = _attachmentList.count == 0 ? NO : YES;
    
    _arrImgs = [NSMutableArray new];
    _arrUrls = [NSMutableArray new];
    for (QiniuFileMo *mo in _attachments) {
        [_arrImgs addObject:STRING(mo.thumbnail)];
        [_arrUrls addObject:STRING(mo.url)];
    }
}

//- (void)setType:(DicMo<DicMo,Optional> *)type {
//    _type = [[DicMo alloc] initWithDictionary:type error:nil];
//}

@end
