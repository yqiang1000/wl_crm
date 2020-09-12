//
//  MyButtonCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - MyButtonCell

@class MyButtonCell;

@protocol MyButtonCellDelegate <NSObject>
@optional
// 保存
- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender;

@end

@interface MyButtonCell : UITableViewCell

// cellHeight default 94.0
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <MyButtonCellDelegate> cellDelegate;

@end

NS_ASSUME_NONNULL_END
