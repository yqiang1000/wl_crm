//
//  FilterView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView;
@protocol FilterViewDelegate <NSObject>

@optional
- (void)filterView:(FilterView *)filterView selectedIndex:(NSInteger)index selected:(BOOL)selected;

@end

@interface FilterView : UIView

@property (nonatomic, assign, readonly) NSInteger selectTag;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *imgsNormal;
@property (nonatomic, strong) NSArray *imgsSelected;

// default imgWidth = 15.0
@property (nonatomic, assign) CGFloat imgWidth;

//字体
@property (nonatomic, strong) UIFont *font;
//选中线宽
@property (nonatomic, assign) CGFloat lineWidth;
//背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//显示分割线 default YES
@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, weak) id <FilterViewDelegate> delegate;

- (instancetype)initWithTitles:(NSArray *)titles
                    imgsNormal:(NSArray *)imgsNormal
                  imgsSelected:(NSArray *)imgsSelected;

- (void)resetNormalState;
- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)selectIndex:(NSInteger)index;

- (void)changeNormalSelectedIndex:(NSInteger)index isChange:(BOOL)isChange;

@end
