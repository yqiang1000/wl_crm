//
//  Business360TableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessVisitActivityMo.h"
#import "BusinessReceptionMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Business360TableViewCell : UITableViewCell

@property (nonatomic, strong) BusinessVisitActivityMo *model;
@property (nonatomic, strong) BusinessReceptionMo *receptionModel;
- (void)loadData:(BusinessVisitActivityMo *)model;
- (void)loadReceptionData:(BusinessReceptionMo *)receptionModel;

@end

NS_ASSUME_NONNULL_END
