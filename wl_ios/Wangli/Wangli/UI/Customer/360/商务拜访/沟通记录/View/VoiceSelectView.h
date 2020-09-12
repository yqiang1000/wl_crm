//
//  VoiceSelectView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/19.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VoiceDefaultType    = 0,
    VoiceChineseType,
    VoiceEnglishType,
    VoiceKoreanType
} VoiceChangeType;

@interface VoiceSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                   changeType:(VoiceChangeType)changeType
                    itemClick:(void (^)(VoiceChangeType type))itemClick
                  cancelClick:(void (^)(VoiceSelectView *obj))cancelClick;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
