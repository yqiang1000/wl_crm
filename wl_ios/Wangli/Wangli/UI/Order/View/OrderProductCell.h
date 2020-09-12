//
//  OrderProductCell.h
//  Wangli
//
//  Created by yeqiang on 2018/5/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductMo.h"

@interface OrderProductCell : UITableViewCell

@property (nonatomic, strong) UILabel *labNumber;
@property (nonatomic, strong) UILabel *labSpePrice;
@property (nonatomic, strong) UILabel *labLevel;
@property (nonatomic, strong) UILabel *labOldPrice;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ProductMo *mo;

- (void)loadDataWith:(ProductMo *)mo order:(BOOL)order;

@end
