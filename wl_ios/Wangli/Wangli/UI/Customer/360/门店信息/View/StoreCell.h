//
//  StoreCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) StoreMo *model;
- (void)loadData:(StoreMo *)model;

@end

NS_ASSUME_NONNULL_END
