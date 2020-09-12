//
//  JYClick.m
//  Wangli
//
//  Created by yeqiang on 2018/10/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "JYClick.h"
//#import <UMAnalytics/MobClick.h>

@interface JYClick ()

@property (nonatomic, strong) dispatch_queue_t workQueue;

@end

@implementation JYClick

+ (JYClick *)shareInstance {
    static JYClick *jyClick = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jyClick = [[JYClick alloc] init];
    });
    return jyClick;
}

- (void)event:(NSString *)eventId {
//    if (eventId.length != 0) {
//        dispatch_async(self.workQueue, ^{
//            NSLog(@"[JYClick event:%@]", eventId);
//            [MobClick event:eventId];
//        });
//    }
}

- (void)event:(NSString *)eventId label:(NSString *)labelId {
//    if (eventId.length != 0) {
//        if (labelId.length == 0) {
//            labelId = @"";
//        }
//        dispatch_async(self.workQueue, ^{
//            NSLog(@"[JYClick event:%@ label:%@]", eventId, labelId);
//            [MobClick event:eventId label:labelId];
//        });
//    }
}

- (void)clickFeild:(NSString *)feild special:(BOOL)special name:(NSString *)name key:(NSString *)key value:(NSString *)value {
//    __block NSString *eventId = @"";
//    __block NSString *labelId = @"";
//    dispatch_async(self.workQueue, ^{
//
//        if (feild.length != 0) {
//            if ([feild isEqualToString:@"office.id"]) {
//                eventId = @"office_id";
//            } else {
//                eventId = feild;
//            }
//            labelId = key;
//        } else {
//            if ([name isEqualToString:@"负责人"]) {
//                eventId = @"ower";
//            } else if ([name isEqualToString:@"领域"]) {
//                eventId = @"field";
//            } else if ([name isEqualToString:@"用途"]) {
//                eventId = @"application";
//            }
//            labelId = key;
//        }
//
//        NSLog(@"[JYClick event:%@ label:%@]", eventId, labelId);
//        [MobClick event:eventId label:labelId];
//    });
}

- (dispatch_queue_t)workQueue {
    if (!_workQueue) {
        _workQueue = dispatch_queue_create("myworkerqueue", DISPATCH_QUEUE_SERIAL);
    }
    return _workQueue;
}

@end
