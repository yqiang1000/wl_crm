//
//  MyTextView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/2.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyTextView;

@protocol MyTextViewDelegate <NSObject>

- (void)myTextView:(MyTextView *)textView btnRightSelected:(UIButton *)sender;

- (void)myTextView:(MyTextView *)textView textChanged:(UITextField *)sender;

@end

@interface MyTextView : UIView

@property (weak, nonatomic) id <MyTextViewDelegate> delegate;
@property (strong, nonatomic) UIImageView *imgLeft;
@property (strong, nonatomic) UITextField *txtField;
@property (strong, nonatomic) UIButton *btnRight;

/**
 *  根据标题画界面
 *  @param leftImage 左侧切图
 *  @param placeholder 占位文字
 *  @param returnType 确认按钮类型
 *  @param keyboardType 键盘类型
 *  @param btnType 按钮类型
 */
- (void)setupViewWithLeftImage:(UIImage *)leftImage
                   placeholder:(NSString *)placeholder
                    returnType:(UIReturnKeyType)returnType
                  keyboardType:(UIKeyboardType)keyboardType
                       btnType:(MyBtnType)btnType;

@end
