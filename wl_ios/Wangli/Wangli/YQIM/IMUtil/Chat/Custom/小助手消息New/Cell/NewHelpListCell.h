//
//  NewHelpListCell.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewHelpListCell : YQBaseTableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) MLLinkLabel *labRight;

@property (nonatomic, strong) CustomItemMo *itemMo;

- (void)loadDataWith:(CustomItemMo *)itemMo;

@end

NS_ASSUME_NONNULL_END
