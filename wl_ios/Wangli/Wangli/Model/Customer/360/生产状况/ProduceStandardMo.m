//
//  ProduceStandardMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/5.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "ProduceStandardMo.h"

@implementation ProduceStandardMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

- (void)setAttachmentList:(NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)attachmentList {
    NSError *error = nil;
    _attachmentList = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachmentList error:&error];
    NSLog(@"%@", error);
}

@end
