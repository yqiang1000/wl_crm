//
//  PlanCollectionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/7/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealPlanCollectionMo.h"
#import "UAProgressView.h"

@interface PlanCollectionCell : UITableViewCell

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;
@property (nonatomic, strong) UILabel *labTotalSend;
@property (nonatomic, strong) UILabel *labRealSend;
@property (nonatomic, strong) UILabel *labTotalNote;
@property (nonatomic, strong) UILabel *labRealNote;

@property (nonatomic, strong) UAProgressView *progressView;

@property (nonatomic, strong) UIImageView *imgArrow;

@property (nonatomic, strong) DealPlanCollectionMo *model;

- (void)loadDataWith:(DealPlanCollectionMo *)model orgName:(NSString *)orgName;

@end
