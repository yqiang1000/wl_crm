//
//  MySwitchCell.h
//  Wangli
//
//  Created by yeqiang on 2019/4/19.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MySwitchCell;
@protocol MySwitchCellDelegate <NSObject>

@optional
- (void)cell:(MySwitchCell *)cell btnClick:(UISwitch *)sender isOn:(BOOL)isOn indexPath:(NSIndexPath *)indexPath;

@end

@interface MySwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UISwitch *btnRight;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <MySwitchCellDelegate> cellDelegate;

// 自适应用
- (void)setLeftText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
