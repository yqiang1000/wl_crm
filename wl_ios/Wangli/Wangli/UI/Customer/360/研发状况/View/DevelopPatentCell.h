//
//  DevelopPatentCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevelopPatentMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevelopPatentCell : UITableViewCell

@property (nonatomic, strong) DevelopPatentMo *model;

- (void)loadData:(DevelopPatentMo *)model;

@end

NS_ASSUME_NONNULL_END
