//
//  MyTextFieldCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MyTextFieldCell

@class MyTextFieldCell;
@protocol MyTextFieldCellDelegate <NSObject>

@optional
- (void)cell:(MyTextFieldCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

//- (void)cell:(MyTextFieldCell *)cell textFieldShouldReturn:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

- (void)cell:(MyTextFieldCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

- (void)cell:(MyTextFieldCell *)cell btnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface MyTextFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UITextField *txtRight;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL hidenContent;

@property (nonatomic, weak) id <MyTextFieldCellDelegate> cellDelegate;

// 自适应用
- (void)setLeftText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
