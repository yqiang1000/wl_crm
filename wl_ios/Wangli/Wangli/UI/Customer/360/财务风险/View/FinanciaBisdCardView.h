//
//  FinanciaBisdCardView.h
//  Wangli
//
//  Created by yeqiang on 2019/1/27.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FinanciaBisdCardView : UIView

- (void)refreshView:(NSMutableArray *)arrData;

@end

@interface BisdCell : UITableViewCell

@property (nonatomic, strong) UILabel *labCode;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labUnit;
@property (nonatomic, strong) UILabel *labAmount;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CreditMo *model;
- (void)loadData:(CreditMo *)model;

@end

NS_ASSUME_NONNULL_END
