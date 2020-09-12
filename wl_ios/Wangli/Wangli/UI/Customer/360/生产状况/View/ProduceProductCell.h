//
//  ProduceProductCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceProductMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProduceProductCell : UITableViewCell

@property (nonatomic, strong) ProduceProductMo *model;
- (void)loadData:(ProduceProductMo *)model;

@end

NS_ASSUME_NONNULL_END
