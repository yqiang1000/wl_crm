//
//  DefaultInputCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DefaultInputCell

@class DefaultInputCell;
@protocol DefaultInputCellDelegate <NSObject>

@optional
- (void)cell:(DefaultInputCell *)cell textFieldDidBeginEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

//- (void)cell:(MyTextFieldCell *)cell textFieldShouldReturn:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

- (void)cell:(DefaultInputCell *)cell textFieldDidEndEditing:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

//- (void)cell:(DefaultInputCell *)cell btnClick:(UIButton *)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface DefaultInputCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UITextField *txtRight;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL hidenContent;

@property (nonatomic, weak) id <DefaultInputCellDelegate> cellDelegate;

// 自适应用
- (void)setLeftText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
