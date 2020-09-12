//
//  DropDownButton.h
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DropDownButton;
@protocol DropDownButtonDelegate <NSObject>
@optional
/** 开始编辑回调 */
- (void)dropDownButtonBeginEdit:(DropDownButton *)dropDownButton;
- (void)dropDownButton:(DropDownButton *)dropDownButton didSelectIndex:(NSIndexPath *)indexPath;
@required
- (NSArray *)listForDropDownButton:(DropDownButton *)dropDownButton;

@end

@interface DropDownButton : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *list;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id <DropDownButtonDelegate> btnDelegate;

/**
 *  初始化DropDownButton
 *  @param frame 结构
 *  @param title 标题
 *  @param list  下拉列表
 *  @return DropDownButton实例
 */
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title List:(NSArray *)list;

/** 收缩列表 */
- (void)startPackUpAnimation;

@end

NS_ASSUME_NONNULL_END
