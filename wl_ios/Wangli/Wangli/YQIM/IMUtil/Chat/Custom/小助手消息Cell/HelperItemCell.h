//
//  HelperItemCell.h
//  HangGuo
//
//  Created by yeqiang on 2020/2/6.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseTableViewCell.h"
#import "MLLinkLabel.h"
#import "JYMessageDataTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelperItemCell : YQBaseTableViewCell

@property (nonatomic, strong) UILabel *labLeft;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) MLLinkLabel *labRight;

@property (nonatomic, strong) JYMessageDataTableModel *itemMo;

- (void)loadDataWith:(JYMessageDataTableModel *)itemMo;

@end

NS_ASSUME_NONNULL_END
