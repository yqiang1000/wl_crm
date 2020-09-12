//
//  QiniuFileMo.m
//  Wangli
//
//  Created by yeqiang on 2018/6/13.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "QiniuFileMo.h"

@implementation QiniuFileMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"deleted"]||
        [propertyName isEqualToString:@"sort"]||
        [propertyName isEqualToString:@"extData"]||
        [propertyName isEqualToString:@"sizeOfByte"])
        return YES;
    return NO;
}

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)array error:(NSError *__autoreleasing *)err {
    NSMutableArray *result = [super arrayOfModelsFromDictionaries:array error:err];
    for (QiniuFileMo *tmpMo in result) {
        [tmpMo connfigUrl];
    }
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        [self connfigUrl];
    }
    return self;
}

- (void)connfigUrl {
    if ([self.fileType containsString:@"jpg"]||
        [self.fileType containsString:@"png"]) {
        if (self.qiniuKey.length > 0) {
            _url = [URLConfig domainUrl:[NSString stringWithFormat:@"%@%@", FILE_ORG_READ, _qiniuKey]];
            _thumbnail = [URLConfig domainUrl:[NSString stringWithFormat: FILE_THUMBNAIL_READ, _qiniuKey]];
        }
    } else if ([self.fileType containsString:@"mp3"]||
               [self.fileType containsString:@"mp4"]) {
//    http://crm-uat-api.aikosolar.net/file/201903/07a7019276804ec88e939137d6b1e143.mp4
        _url = [URLConfig domainUrl:[NSString stringWithFormat:@"/file/%@/%@.%@", STRING(_yyyymm), STRING(_qiniuKey), STRING(_fileType)]];
    }
}

//- (void)setQiniuKey:(NSString<Optional> *)qiniuKey {
//    _qiniuKey = qiniuKey;
//    if (_qiniuKey.length > 0) {
//        _url = [URLConfig domainUrl:[NSString stringWithFormat:@"%@%@", FILE_ORG_READ, _qiniuKey]];
//        _thumbnail = [URLConfig domainUrl:[NSString stringWithFormat: FILE_THUMBNAIL_READ, _qiniuKey]];
//    }
//}

@end
