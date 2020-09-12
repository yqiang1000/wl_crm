//
//  RiskTotalCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/17.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskListMo.h"

@interface RiskTotalCell : UICollectionViewCell

@property (nonatomic, strong) RiskListMo *model;

- (void)loadDataWith:(RiskListMo *)model;

@end
