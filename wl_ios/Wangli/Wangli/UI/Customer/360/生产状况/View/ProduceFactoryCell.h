//
//  ProduceFactoryCell.h
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProduceFactoryMo.h"
#import "ProduceCapacityMo.h"
#import "ProduceIQCMo.h"
#import "DevelopLaboratoryMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProduceFactoryCell : UITableViewCell

@property (nonatomic, strong) JSONModel *model;
- (void)loadData:(JSONModel *)model;

@end

NS_ASSUME_NONNULL_END
