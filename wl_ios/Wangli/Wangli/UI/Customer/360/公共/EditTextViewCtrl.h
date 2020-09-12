//
//  EditTextViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"


@class EditTextViewCtrl;
@protocol EditTextViewCtrlDelegate <NSObject>
@optional
// 优先级低，会被覆盖
- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath;

// 优先级高
- (void)editVC:(EditTextViewCtrl *)eidtVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath btnRightClick:(UIButton *)sender complete:(void(^)(BOOL updateSucce, NSString *tost))complete;

@end

@interface EditTextViewCtrl : BaseViewCtrl

@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *placeholder;      //占位
@property (nonatomic, copy) NSString *currentText;      //实际内容
@property (nonatomic, assign) NSInteger max_length;     //文字长度
@property (nonatomic, assign) BOOL numberOnly;
@property (nonatomic, assign) UIKeyboardType keyType;

@property (nonatomic, assign) BOOL hidenCount;

@property (nonatomic, weak) id <EditTextViewCtrlDelegate> editVCDelegate;

@end
