//
//  BusinessInteligenceMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BusinessInteligenceMo.h"
#import "QiNiuUploadHelper.h"

@implementation IntelligenceItemSet

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"isSelected"])
        return YES;
    
    return NO;
}

- (void)configAttachmentList {
    [_images removeAllObjects];
    [_voices removeAllObjects];
    [_videos removeAllObjects];
    [_userMos removeAllObjects];
    _images = nil;
    _voices = nil;
    _videos = nil;
    _userMos = nil;
    for (NSDictionary *dic in self.attachmentList) {
        NSError *error = nil;
        QiniuFileMo *qiniuMo = [[QiniuFileMo alloc] initWithDictionary:dic error:&error];
        if ([qiniuMo.fileType containsString:@"jpg"] || [qiniuMo.fileType containsString:@"png"]) {
            [self.images addObject:qiniuMo];
        } else if ([qiniuMo.fileType containsString:@"mp3"]) {
            [self.voices addObject:qiniuMo];
        } else if ([qiniuMo.fileType containsString:@"mp4"]||
                   [qiniuMo.fileType containsString:@"mov"]||
                   [qiniuMo.fileType containsString:@"avi"]) {
            [self.videos addObject:qiniuMo];
        }
    }
    
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:self.content];
    NSArray *matches = [self findAllAt];
    if (matches.count == 0) {
        self.showText = self.content;
    }
    
    for (int i = 0; i < matches.count; i++) {
        // @=11=用户名称@
        NSTextCheckingResult *match = matches[matches.count-i-1];
        NSString *userNameId = [contentStr substringWithRange:NSMakeRange(match.range.location, match.range.length)];
        
        NSArray *arrIds = [self findId:userNameId];
        if (arrIds.count > 0) {
            // =11=
            NSTextCheckingResult *idMatch = arrIds[0];
            NSString *idStr = [userNameId substringWithRange:NSMakeRange(idMatch.range.location+1, idMatch.range.length-2)];
            NSString *nameStr = [userNameId substringWithRange:NSMakeRange(idMatch.range.length+1, userNameId.length-idMatch.range.length-2)];
            
            JYUserMo *mo = [[JYUserMo alloc] init];
            mo.id = [idStr integerValue];
            mo.name = nameStr;
            [self.userMos addObject:mo];
            [contentStr replaceCharactersInRange:match.range withString:[NSString stringWithFormat:@"@%@@", nameStr]];
        }
        self.showText = contentStr;
    }
}

- (NSArray<NSTextCheckingResult *> *)findAllAt
{
    // 找到文本中所有的@
    NSString *string = self.content;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

- (NSArray<NSTextCheckingResult *> *)findId:(NSString *)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATIDRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}


- (void)setIntelligenceType:(DicMo<Optional> *)intelligenceType {
    if ([intelligenceType isKindOfClass:[DicMo class]]) {
        _intelligenceType = intelligenceType;
    } else if ([intelligenceType isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        _intelligenceType = (DicMo<Optional> *)[[DicMo alloc] initWithDictionary:(NSDictionary *)intelligenceType error:&error];
    } else {
        _intelligenceType = intelligenceType;
    }
}

- (void)setIntelligenceInfo:(DicMo<Optional> *)intelligenceInfo {
    if ([intelligenceInfo isKindOfClass:[DicMo class]]) {
        _intelligenceInfo = intelligenceInfo;
    } else if ([intelligenceInfo isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        _intelligenceInfo = (DicMo<Optional> *)[[DicMo alloc] initWithDictionary:(NSDictionary *)intelligenceInfo error:&error];
    } else {
        _intelligenceInfo = intelligenceInfo;
    }
}


- (NSMutableArray<Optional> *)images {
    if (!_images) {
        _images = [NSMutableArray new];
    }
    return _images;
}

- (NSMutableArray<Optional> *)voices {
    if (!_voices) {
        _voices = [NSMutableArray new];
    }
    return _voices;
}

- (NSMutableArray<Optional> *)videos {
    if (!_videos) {
        _videos = [NSMutableArray new];
    }
    return _videos;
}

- (NSMutableArray<Optional> *)userMos {
    if (!_userMos) {
        _userMos = [NSMutableArray new];
    }
    return _userMos;
}

- (void)uploadAttementCompleted:(void (^)(NSMutableArray * _Nonnull))uploadSuccess {
    [Utils showHUDWithStatus:nil];
    QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
    
    [helper uploadImages:self.images voices:self.voices videos:self.videos success:^(id responseObject) {
        [_attachmentDicList removeAllObjects];
        _attachmentDicList = [NSMutableArray new];
        for (QiniuFileMo *tmpMo in responseObject) {
            if ([tmpMo.fileType containsString:@"jpg"] || [tmpMo.fileType containsString:@"png"]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
                [dic setObject:@"" forKey:@"url"];
                [dic setObject:@"" forKey:@"thumbnail"];
                [_attachmentDicList addObject:dic];
            } else {
                [_attachmentDicList addObject:[tmpMo toDictionary]];
            }
        }
        if (uploadSuccess) {
            uploadSuccess(_attachmentDicList);
        }
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    
    
//    [helper uploadFileMulti:self.images success:^(id responseObject) {
//        [_attachmentDicList removeAllObjects];
//        _attachmentDicList = [NSMutableArray new];
//        for (QiniuFileMo *tmpMo in responseObject) {
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
//            [dic setObject:@"" forKey:@"url"];
//            [dic setObject:@"" forKey:@"thumbnail"];
//            [_attachmentDicList addObject:dic];
//        }
//        if (uploadSuccess) {
//            uploadSuccess(_attachmentDicList);
//        }
//    } failure:^(NSError *error) {
//        [Utils dismissHUD];
//        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
//    }];
}

@end


@implementation BusinessInteligenceMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"id"])
        return YES;
    
    return NO;
}

@end
