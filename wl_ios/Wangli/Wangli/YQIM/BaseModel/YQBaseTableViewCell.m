//
//  YQBaseTableViewCell.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseTableViewCell.h"

@implementation YQBaseTableViewCell

#pragma mark - 初始化

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    return [self dequeueReusableCellWithTableView:tableView reuseIdentifier:reuseIdentifier cellStyle:[self styleForTableViewCell]];
}

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier cellStyle:(UITableViewCellStyle)cellStyle {
    YQBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier ?: NSStringFromClass(self)];
    if (!cell) {
        cell = [[self alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier ?: NSStringFromClass(self)];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 子类重写自定义方法

+ (UITableViewCellStyle )styleForTableViewCell {
    return UITableViewCellStyleDefault;
}

- (void)loadData:(id)model {}

- (void)dealloc {
    Dealloc(self);
}

@end
