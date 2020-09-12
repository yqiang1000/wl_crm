//
//  TrendsContractCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
#import "ContactContractMo.h"
#import "TrendsContractMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsContractCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labYear;
@property (nonatomic, strong) UILabel *labMonth;
@property (nonatomic, strong) UILabel *labTotalSend;
@property (nonatomic, strong) UILabel *labRealSend;
@property (nonatomic, strong) UILabel *labTotalNote;
@property (nonatomic, strong) UILabel *labRealNote;

@property (nonatomic, strong) UAProgressView *progressView;

@property (nonatomic, strong) TrendsContractMo *model;

- (void)loadDataWith:(TrendsContractMo *)model;

@end

NS_ASSUME_NONNULL_END
