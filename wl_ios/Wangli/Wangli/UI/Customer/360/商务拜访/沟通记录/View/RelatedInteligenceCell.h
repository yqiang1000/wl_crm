//
//  RelatedInteligenceCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/18.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessInteligenceMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RelatedInteligenceCell : UITableViewCell

@property (nonatomic, strong) IntelligenceItemSet *model;
- (void)loadData:(IntelligenceItemSet *)model;

@end

NS_ASSUME_NONNULL_END
