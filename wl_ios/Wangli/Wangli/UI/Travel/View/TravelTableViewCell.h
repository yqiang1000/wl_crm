//
//  TravelTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelTableViewCell : UITableViewCell

@property (nonatomic, strong) TravelMo *model;
- (void)loadData:(TravelMo *)model;

@end

NS_ASSUME_NONNULL_END
