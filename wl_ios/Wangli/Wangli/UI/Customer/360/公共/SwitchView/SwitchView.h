//
//  SwitchView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchMo.h"

NS_ASSUME_NONNULL_BEGIN

@class SwitchView;

@protocol SwitchViewDelegate <NSObject>
/**
 *  选中标题
 *  switchView: switchView
 *  title: 标题
 *  index: 位置
 *  state: 返回上一次状态
 */
@optional
- (void)switchView:(SwitchView *)switchView selectIndex:(NSInteger)index title:(NSString *)title switchState:(SwitchState)state;

@end

@interface SwitchView : UIView

@property (nonatomic, weak) id <SwitchViewDelegate> delegate;

/** 初始化默认 SCREEN_WIDTH * 49　*/
- (instancetype)initWithTitles:(NSArray *)titles
                     imgNormal:(NSArray *)imgNormal
                     imgSelect:(NSArray *)imgSelect;

/** 初始化 frame　*/
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    imgNormal:(NSArray *)imgNormal
                    imgSelect:(NSArray *)imgSelect;

/** 设置滚动条位置 */
- (void)selectIndex:(NSInteger)index;

/** 设置滚动条是否隐藏属性 */
- (void)updateSelectViewHiden:(BOOL)hiden;

/**
 *  更新标题
 *  title: 标题
 *  index: 位置
 *  state: 状态
 */
- (void)updateTitle:(NSString *)title index:(NSInteger)index switchState:(SwitchState)state;

/**
 *  更新所有标题
 *  titles: 标题
 */
- (void)updateTitles:(NSArray *)titles;

/** 设置滚动条宽度(默认屏幕宽平分) */
- (void)updateSelectViewWidth:(CGFloat)width;

/** 设置字体大小 */
- (void)updateFont:(UIFont *)font;

/** 设置未选中字体颜色 */
- (void)updateNormalColor:(UIColor *)color;

/** 设置选中字体颜色 */
- (void)updateSelectColor:(UIColor *)color;

/** 设置完成之后刷新 */
- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
