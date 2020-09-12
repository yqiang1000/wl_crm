//
//  RiskTopView.h
//  Wangli
//
//  Created by yeqiang on 2018/7/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RiskTopView;

@protocol RiskTopViewDelegate <NSObject>

@optional
- (void)riskTopView:(RiskTopView *)riskTopView selectIndex:(NSInteger)index;

@end

@interface RiskTopView : UIView

@property (nonatomic, weak) id <RiskTopViewDelegate> delegate;

@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;

//选项，颜色
- (instancetype)initWithItems:(NSArray *)items
                    imgSelect:(NSArray *)imgSelect
                    imgNormal:(NSArray *)imgNormal
                  colorSelect:(UIColor *)colorSelect
                  colorNormal:(UIColor *)colorNormal;

/** 更新标题：btn为selected状态，如果选中：图片常规-蓝，选中-灰；为选中：图片常规-灰，选中-蓝 */
- (void)updateIndex:(NSInteger)index selected:(BOOL)selected;

/** 设置滚动条位置 */
- (void)selectIndex:(NSInteger)index;

/** 设置btn为：文字常规-灰，选中-蓝；图片常规-灰，选中-蓝 */
- (void)resetNormalState:(NSInteger)index;

/** 设置btn0为：文字-蓝，图片-蓝 */
- (void)btn0Select;

/** 设置btn0为：文字-灰，图片-灰 */
- (void)btn0Normal;

/** 更新标题 */
- (void)updateTitle:(NSString *)title index:(NSInteger)index;

@end
