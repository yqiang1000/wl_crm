//
//  RiskFollowCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/18.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskFollowMo.h"
#import "TrendsFeedMo.h"
#import "TrendsTextView.h"

@interface RiskFollowCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labCreater;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) TrendsTextView *labContent;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) RiskFollowMo *model;
@property (nonatomic, strong) TrendsFeedMo *feedMo;

/** 老的Feed流 */
- (void)loadDataWith:(RiskFollowMo *)model;
/** 新的Feed流 */
- (void)loadDataWithFeedMo:(TrendsFeedMo *)feedMo;

@end
