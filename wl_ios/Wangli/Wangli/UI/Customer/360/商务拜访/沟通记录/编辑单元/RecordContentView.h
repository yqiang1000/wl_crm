//
//  RecordContentView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordImageView.h"
#import "RecordVoiceView.h"
#import "RecordVideoView.h"
#import "RecordTextView.h"
#import "BusinessVisitActivityMo.h"
#import "BusinessInteligenceMo.h"
#import "HPGrowingTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordContentView : UIView

@property (nonatomic, strong) BusinessVisitActivityMo *model;
@property (nonatomic, strong) IntelligenceItemSet *itemModel;
//@property (nonatomic, strong) UITextView *textView;
//@property (nonatomic, strong) RecordTextView *textView;
@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) RecordVoiceView *voiceView;
@property (nonatomic, strong) RecordImageView *imageView;
@property (nonatomic, strong) RecordVideoView *videoView;

// 外层
- (void)refreshRecordContentView:(BusinessVisitActivityMo *)model;
// 里层
- (void)refreshIntelligenceContentView:(IntelligenceItemSet *)itemModel;


@end

NS_ASSUME_NONNULL_END
