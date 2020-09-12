//
//  TabMineCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/25.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabMineCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) UIView *lineView;

// 自适应用
- (void)setLeftText:(NSString *)text;

@end
