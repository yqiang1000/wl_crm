//
//  TrendsOrderCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsOrderMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsOrderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;
@property (nonatomic, strong) UILabel *labProduct;
@property (nonatomic, strong) UILabel *labCode;
@property (nonatomic, strong) UILabel *labNum;
@property (nonatomic, strong) UILabel *labState;

@property (nonatomic, strong) TrendsOrderMo *model;

- (void)loadDataWith:(TrendsOrderMo *)model;

@end

NS_ASSUME_NONNULL_END
