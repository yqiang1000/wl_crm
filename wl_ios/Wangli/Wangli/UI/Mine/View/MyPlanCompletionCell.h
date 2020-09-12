//
//  MyPlanCompletionCell.h
//  Wangli
//
//  Created by yeqiang on 2018/5/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DealPlanMo.h"
#import "UAProgressView.h"

@interface MyPlanCompletionCell : UITableViewCell

@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labDay;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labMsg;
@property (nonatomic, strong) UILabel *labTotalSend;
@property (nonatomic, strong) UILabel *labRealSend;
@property (nonatomic, strong) UAProgressView *progressView;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) DealPlanMo *model;

- (void)loadDataWith:(id)model;

@end
