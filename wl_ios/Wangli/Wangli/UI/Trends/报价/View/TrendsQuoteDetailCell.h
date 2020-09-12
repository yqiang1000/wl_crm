//
//  TrendsQuoteDetailCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendsQuoteMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsQuoteDetailCell : UITableViewCell

@property (nonatomic, strong) TrendsQuoteDetailMo *model;
- (void)loadDataWith:(TrendsQuoteDetailMo *)model;

@end

NS_ASSUME_NONNULL_END
