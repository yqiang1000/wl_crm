//
//  RetailPageCell.h
//  Wangli
//
//  Created by yeqiang on 2019/4/22.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RetailPageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *baseView;
// 值
@property (nonatomic, strong) UILabel *labTL;
@property (nonatomic, strong) UILabel *labTR;
@property (nonatomic, strong) UILabel *labBL;
@property (nonatomic, strong) UILabel *labBR;
// 标题
@property (nonatomic, strong) UILabel *labKTL;
@property (nonatomic, strong) UILabel *labKTR;
@property (nonatomic, strong) UILabel *labKBL;
@property (nonatomic, strong) UILabel *labKBR;

@property (nonatomic, strong) UAProgressView *progressView;

- (void)rateProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
