
//
//  TrendsInteligenceMo.m
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsInteligenceMo.h"

@implementation TrendsInteligenceMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"id"]||
        [propertyName isEqualToString:@"viewCount"]||
        [propertyName isEqualToString:@"read"])
        return YES;
    
    return NO;
}

- (void)configAttachmentList {
    [_images removeAllObjects];
    [_voices removeAllObjects];
    [_videos removeAllObjects];
    _images = nil;
    _voices = nil;
    _videos = nil;
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
}

- (NSMutableArray<Optional> *)images {
    if (!_images) _images = [NSMutableArray new];
    return _images;
}

- (NSMutableArray<Optional> *)voices {
    if (!_voices) _voices = [NSMutableArray new];
    return _voices;
}

- (NSMutableArray<Optional> *)videos {
    if (!_videos) _videos = [NSMutableArray new];
    return _videos;
}


@end
