//
//  DealerCell.h
//  Wangli
//
//  Created by yeqiang on 2019/3/20.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DealerCell : UITableViewCell

@property (nonatomic, strong) DealerMo *model;
- (void)loadData:(DealerMo *)model;

@end

NS_ASSUME_NONNULL_END
