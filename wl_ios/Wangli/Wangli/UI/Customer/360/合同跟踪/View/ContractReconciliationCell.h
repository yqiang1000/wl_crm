//
//  ContractReconciliationCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractReconciliationCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;

@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;

@property (nonatomic, strong) UILabel *labInvoice;
@property (nonatomic, strong) UILabel *labReceipt;
@property (nonatomic, strong) UILabel *labNotInvoice;
@property (nonatomic, strong) UILabel *labNotReceipt;

@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) DealPlanMo *model;

- (void)loadDataWith:(NSString *)model;

@end

NS_ASSUME_NONNULL_END
