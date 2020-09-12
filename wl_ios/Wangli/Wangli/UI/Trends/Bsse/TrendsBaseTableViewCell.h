//
//  TrendsBaseTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TrendsBaseMo.h"
#import "TrendsBusinessMo.h"
#import "TrendMarketActivityMo.h"
#import "TrendsReceiptMo.h"
#import "TrendsQuoteMo.h"
#import "TrendsSampleMo.h"
#import "ClueMo.h"


NS_ASSUME_NONNULL_BEGIN

@interface TrendsBaseTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labContent;
@property (nonatomic, strong) UILabel *labPerson;
@property (nonatomic, strong) UILabel *labDate;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *labState;

@property (nonatomic, strong) TrendsBaseMo *model;
- (void)loadDataWith:(TrendsBaseMo *)model;

@end

NS_ASSUME_NONNULL_END
