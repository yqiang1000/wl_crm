//
//  MenuTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/19.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *labTitle;

- (void)loadDataWith:(BOOL)cellSelect;

@end
