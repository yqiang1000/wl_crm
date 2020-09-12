//
//  CusInfoMo.m
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CusInfoMo.h"

@implementation CusInfoDetailMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"change"])
        return YES;
    
    return NO;
}

- (void)setRightValue:(NSString<Optional> *)rightValue {
    if (rightValue.length == 0) {
        rightValue = @"demo";
    } else {
        _rightValue = rightValue;
    }
}

@end

@implementation CusInfoMo

- (void)setData:(NSMutableArray<CusInfoDetailMo *><Optional> *)data {
    _data = (NSMutableArray<CusInfoDetailMo *><Optional> *)[CusInfoDetailMo arrayOfModelsFromDictionaries:data error:nil];
}

- (void)setAttachments:(NSMutableArray<QiniuFileMo *><Optional> *)attachments {
    _attachments = (NSMutableArray<QiniuFileMo *><Optional> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachments error:nil];
}

@end

