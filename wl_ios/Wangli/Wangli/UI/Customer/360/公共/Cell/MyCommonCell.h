//
//  MyCommonCell.h
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactMo.h"
#import "LongCommonCell.h"
#import "MyDefaultCell.h"
#import "ContactCell.h"
#import "MyTextFieldCell.h"
#import "MyTextViewCell.h"
#import "MyButtonCell.h"
#import "DefaultInputCell.h"
#import "DefaultHeaderCell.h"
#import "MySwitchCell.h"

#pragma mark - MyCommonCell

@interface MyCommonCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UILabel *labRight;
@property (nonatomic, strong) UIImageView *imgArrow;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL hidenContent;
// 自适应用
- (void)setLeftText:(NSString *)text;

@end
