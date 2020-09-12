//
//  TrendsTextView.h
//  Wangli
//
//  Created by yeqiang on 2019/1/27.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TrendsTextView;
@protocol TrendsTextViewDelegate <NSObject>
@optional
- (void)trendsTextView:(TrendsTextView *)trendsTextView didSelectUrlStr:(NSString *)urlStr;
@end

@interface TrendsTextView : UITextView

@property (nonatomic, weak) id <TrendsTextViewDelegate> trendsDelegate;
@property (nonatomic, copy) NSString *myNormalText;
@property (nonatomic, copy) NSMutableAttributedString *myAttText;

- (void)loadText:(NSString *)myNormalText;

@end

NS_ASSUME_NONNULL_END
