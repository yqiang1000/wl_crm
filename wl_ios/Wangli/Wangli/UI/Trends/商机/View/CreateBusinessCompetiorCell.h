//
//  CreateBusinessCompetiorCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsCompetitorMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateBusinessCompetiorCell : UITableViewCell

@property (nonatomic, strong) UILabel *labMember;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labRemark;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) TrendsCompetitorMo *model;
- (void)loadDataWith:(TrendsCompetitorMo *)model;

@end

NS_ASSUME_NONNULL_END
