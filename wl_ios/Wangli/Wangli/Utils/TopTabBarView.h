//
//  TopTabBarView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopTabBarView;

@protocol TopTabBarViewDelegate <NSObject>

@optional
- (void)topTabBarView:(TopTabBarView *)topTabBarView selectIndex:(NSInteger)index;

@end

@interface TopTabBarView : UIView

@property (nonatomic, weak) id <TopTabBarViewDelegate> delegate;
//字体
@property (nonatomic, strong) UIFont *labFont;
//选中线宽
@property (nonatomic, assign) CGFloat lineWidth;
//背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//显示分割线 default YES
@property (nonatomic, assign) BOOL showLine;
//选项，颜色
- (instancetype)initWithItems:(NSArray *)items
                  colorSelect:(UIColor *)colorSelect
                  colorNormal:(UIColor *)colorNormal;
//更新标题
- (void)updateTitle:(NSArray *)items;
//设置选中位置
- (void)selectIndex:(NSInteger)index;

@end
