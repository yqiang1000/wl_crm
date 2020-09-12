//
//  TabOrderCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/20.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMo.h"

@interface TabOrderCell : UITableViewCell

@property (nonatomic, strong) OrderMo *model;

- (void)loadDataWith:(OrderMo *)model;

@end
