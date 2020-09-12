//
//  NewHelpListCell.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "NewHelpListCell.h"

@implementation NewHelpListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUI {
    [self.contentView addSubview:self.labLeft];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.labRight];
    [self.contentView addSubview:self.bottomLine];
    
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.equalTo(@80);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labLeft.mas_right);
        make.width.equalTo(@0.5);
        make.height.equalTo(self.contentView);
    }];
    
    [self.labRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(12);
        make.centerY.equalTo(self.contentView);
        make.top.right.equalTo(self.contentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)loadDataWith:(CustomItemMo *)itemMo {
    _itemMo = itemMo;
    self.labLeft.text = itemMo.leftContent;
    self.labRight.text = itemMo.rightContent;
    
    if (itemMo.rightColor.length == 7) {
        self.labRight.textColor = COLOR_HEX([itemMo.rightColor substringFromIndex:1]);
    }
    if (itemMo.rightUrl.length != 0) {
        [self.labRight addLinkWithType:MLLinkTypeURL value:nil range:NSMakeRange(0, self.labRight.text.length)];
        __weak typeof(self) weakSelf = self;
        
        [self.labRight setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSLog(@"click ---- %@", linkText);
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            [userInfo setObject:STRING(linkText) forKey:@"linkText"];
            [userInfo setObject:STRING(weakSelf.itemMo.rightUrl) forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
        }];
    }
}

#pragma mark - setter getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [UILabel new];
        _labLeft.textColor = COLOR_B2;
        _labLeft.font = FONT_F15;
    }
    return _labLeft;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [Utils getLineView];
    }
    return _bottomLine;
}

- (MLLinkLabel *)labRight {
    if (!_labRight) {
        _labRight = [[MLLinkLabel alloc] init];
        _labRight.textColor = COLOR_B1;
        _labRight.font = FONT_F15;
        _labRight.dataDetectorTypes = MLDataDetectorTypeURL;
    }
    return _labRight;
}
@end
