//
//  RecordTextView.h
//  Wangli
//
//  Created by yeqiang on 2019/1/2.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecordTextView;
@protocol RecordTextViewDelegate <NSObject>
@optional
- (void)recordTextViewBeginEdit:(RecordTextView *)recordTextView;

@end

@interface RecordTextView : UIView

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, weak) id <RecordTextViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
