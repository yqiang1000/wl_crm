//
//  PlanNumCell.h
//  Wangli
//
//  Created by yeqiang on 2018/9/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaterialMo.h"

@interface PlanNumCell : UITableViewCell

@property (nonatomic, strong) UILabel *labNumber;
@property (nonatomic, strong) UILabel *labSpec;
@property (nonatomic, strong) UILabel *labFactory;
@property (nonatomic, strong) UILabel *labWeight;
@property (nonatomic, strong) UILabel *labLevel;
@property (nonatomic, strong) UILabel *labQuantity;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MaterialMo *mo;

- (void)loadDataWith:(MaterialMo *)mo;

@end
