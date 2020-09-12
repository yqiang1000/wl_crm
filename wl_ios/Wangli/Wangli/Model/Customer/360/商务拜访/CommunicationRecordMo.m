//
//  CommunicationRecordMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CommunicationRecordMo.h"


@implementation CommunicationRecordMo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"isSelected"]||
        [propertyName isEqualToString:@"height"])
        return YES;
    
    return NO;
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

@end
