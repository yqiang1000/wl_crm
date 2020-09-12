//
//  TreeTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/21.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"

@interface TreeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labIcon;
@property (nonatomic, strong) UILabel *labMsg;

@property (nonatomic, strong) Node *node;
- (void)loadDataWith:(Node *)node;

@end
