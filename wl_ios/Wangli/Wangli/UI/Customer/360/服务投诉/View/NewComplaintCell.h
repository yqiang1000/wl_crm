//
//  NewComplaintCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProblemDescMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewComplaintCell : UITableViewCell

@property (nonatomic, strong) UILabel *labInvoice;
@property (nonatomic, strong) UILabel *labReceipt;
@property (nonatomic, strong) UILabel *labNotInvoice;
@property (nonatomic, strong) UILabel *labNotReceipt;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ProblemDescMo *model;

- (void)loadDataWith:(ProblemDescMo *)model;

@end

NS_ASSUME_NONNULL_END
