//
//  MyTextViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MyTextViewCell

@class MyTextViewCell;

@protocol MyTextViewCellDelegate <NSObject>
@optional

// 输入回调
- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

// 结束输入
- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath;

@end

@interface MyTextViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) UIButton *btnArrow;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <MyTextViewCellDelegate> cellDelegate;

- (void)setLeftText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
