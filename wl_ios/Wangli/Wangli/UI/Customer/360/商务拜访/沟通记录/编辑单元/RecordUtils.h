//
//  RecordUtils.h
//  Wangli
//
//  Created by yeqiang on 2018/12/27.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordUtils : NSObject

+ (RecordUtils *)shareInstance;

/** 根据当前个数获得高度 */
- (CGFloat)getHeightByCount:(NSInteger)count;

@property (nonatomic, assign) CGFloat record_width;

@end

NS_ASSUME_NONNULL_END
