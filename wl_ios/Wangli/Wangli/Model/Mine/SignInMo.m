//
//  SignInMo.m
//  Wangli
//
//  Created by yeqiang on 2019/3/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SignInMo.h"

@implementation SignInMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"hasImgUrl"])
        return YES;
    return NO;
}

- (void)setAttachments:(NSMutableArray<Optional> *)attachments {
    NSError *error = nil;
    _attachments = [QiniuFileMo arrayOfModelsFromDictionaries:attachments error:&error];
    _hasImgUrl = _attachments.count == 0 ? NO : YES;
    _arrImgs = [NSMutableArray new];
    _arrUrls = [NSMutableArray new];
    for (QiniuFileMo *mo in _attachments) {
        [_arrImgs addObject:STRING(mo.thumbnail)];
        [_arrUrls addObject:STRING(mo.url)];
    }
}

@end
