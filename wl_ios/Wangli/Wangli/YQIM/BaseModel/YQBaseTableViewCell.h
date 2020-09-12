//
//  YQBaseTableViewCell.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQBaseTableViewCell : UITableViewCell

/// cell获取实例
/// @param tableView tableView
/// @param reuseIdentifier reuseIdentifier
+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

/// cell获取实例
/// @param tableView tableView
/// @param reuseIdentifier reuseIdentifier
+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(UITableViewCellStyle)cellStyle;

+ (UITableViewCellStyle )styleForTableViewCell;

- (void)loadData:(id)model;

@end

NS_ASSUME_NONNULL_END
