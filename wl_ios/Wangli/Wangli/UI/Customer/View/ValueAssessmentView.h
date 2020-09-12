//
//  ValueAssessmentView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorthBeanMo.h"

NS_ASSUME_NONNULL_BEGIN

@class ValueAssessmentView;
@protocol ValueAssessmentViewDelegate <NSObject>
@optional
- (void)valueAssessmentView:(ValueAssessmentView *)valueAssessmentView didselectTab:(NSInteger)tabIndex;
@end

@interface ValueAssessmentView : UIView

@property (nonatomic, weak) id <ValueAssessmentViewDelegate> valueAssessmentViewDelegate;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *labLevel;
- (void)refreshView:(NSMutableArray *)arrData;
- (void)resetSegmentView:(NSInteger)index;

@end

@interface ValueAssessmentCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) WorthBeanMo *model;
- (void)loadData:(WorthBeanMo *)model;

@end

NS_ASSUME_NONNULL_END
