//
//  DevelopTechnicolCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevelopTechnicalMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DevelopTechnicolCell : UITableViewCell

@property (nonatomic, strong) DevelopTechnicalMo *model;

- (void)loadData:(DevelopTechnicalMo *)model;

@end

NS_ASSUME_NONNULL_END
