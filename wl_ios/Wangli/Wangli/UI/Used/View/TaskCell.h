//
//  TaskCell.h
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskMo.h"

@interface TaskCell : UITableViewCell

@property (nonatomic, strong) TaskMo *model;

- (void)loadDataWith:(TaskMo *)model;

@end
