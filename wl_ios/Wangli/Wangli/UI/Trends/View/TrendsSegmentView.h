//
//  TrendsSegmentView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/23.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendFeedItemMo.h"

NS_ASSUME_NONNULL_BEGIN

@class TrendsSegmentView;
@protocol TrendsSegmentViewDelegate <NSObject>
@optional
- (void)trendsSegmentView:(TrendsSegmentView *)trendsSegmentView didSelectIndex:(NSInteger)index title:(NSString *)title;
- (void)trendsSegmentView:(TrendsSegmentView *)trendsSegmentView didClick:(UIButton *)sender;

@end

@interface TrendsSegmentView : UIView

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UIButton *btnArrow;

@property (nonatomic, weak) id <TrendsSegmentViewDelegate> trendsSegmentViewDelegate;
/** showBtn 是否显示按钮，默认NO */
- (instancetype)initWithFrame:(CGRect)frame showBtn:(BOOL)showBtn;

/** 刷新标题 */
- (void)refreshTitles:(NSMutableArray *)titles;

/** 滚动到某个位置 */
- (void)selectIndex:(NSInteger)index;

/** 重置按钮 */
- (void)resetBtnStateNormal;

@end

NS_ASSUME_NONNULL_END
