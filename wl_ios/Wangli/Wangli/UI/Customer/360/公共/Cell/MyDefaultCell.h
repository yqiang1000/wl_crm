//
//  MyDefaultCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MyDefaultCell

@class MyDefaultCell;
@protocol MyDefaultCellDelegate <NSObject>

@optional
// 是否默认。默认NO
- (void)defaultCell:(MyDefaultCell *)cell isDefault:(BOOL)isDefault;
// 在外部修改状态，会把上面的代理方法覆盖
- (void)defaultCellSwitchTouch:(MyDefaultCell *)cell btnSwitch:(UISwitch *)btnSwitch;

@end

@interface MyDefaultCell : UITableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UISwitch *btnSwitch;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id <MyDefaultCellDelegate> cellDelegate;

// 自适应用
- (void)setLeftText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
