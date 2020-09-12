//
//  HelperItemCell.m
//  HangGuo
//
//  Created by yeqiang on 2020/2/6.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "HelperItemCell.h"
#import "JYIMUtils.h"
#import <MLLinkLabel.h>

@interface HelperItemCell ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation HelperItemCell

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
    Dealloc(self);
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

- (void)loadDataWith:(JYMessageDataTableModel *)itemMo {
    _itemMo = itemMo;
    self.labLeft.text = _itemMo.left;
    
    JYDictItemMo *styleMo = [JYIMUtils getIMHelperStyleByStyle:_itemMo.rightStyle];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (styleMo) {
        // 获取颜色
        if (styleMo.value2.length == 7) {
            UIColor *color = [UIColor colorWithHexString:styleMo.value2];
            [attributes setObject:color forKey:NSForegroundColorAttributeName];
        }
        // 是否下划线
        if ([styleMo.code containsString:@"_underline"]) {
            [attributes setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
        }
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:itemMo.right attributes:attributes];
        self.labRight.attributedText = attStr;
    } else {
        self.labRight.text = itemMo.right;
    }

    if (itemMo.rightLink.length > 0) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jyLinkClick)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [self.labRight addGestureRecognizer:_tap];
    } else {
        [self.labRight removeGestureRecognizer:_tap];
    }
    
    // 单击未生效，长按生效
//        MLLink *link = [MLLink linkWithType:MLLinkTypeOther value:self.itemMo.rightLink range:NSMakeRange(0, self.labRight.text.length) linkTextAttributes:attributes activeLinkTextAttributes:attributes];
//
//        [self.labRight addLinks:@[link]];
//        __weak typeof(self) weakSelf = self;
//
//        self.labRight.didClickLinkBlock = ^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSLog(@"click ---- %@", linkText);
//            NSMutableDictionary *userInfo = [NSMutableDictionary new];
//            [userInfo setObject:STRING(linkText) forKey:@"linkText"];
//            [userInfo setObject:STRING(weakSelf.itemMo.rightLink) forKey:@"url"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
//        };
//
//        self.labRight.didLongPressLinkBlock = ^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//            NSLog(@"longclick ---- %@", linkText);
//            NSMutableDictionary *userInfo = [NSMutableDictionary new];
//            [userInfo setObject:STRING(linkText) forKey:@"linkText"];
//            [userInfo setObject:STRING(weakSelf.itemMo.rightLink) forKey:@"url"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
//        };
}

- (void)jyLinkClick {
    NSLog(@"点击 ------ %@" , self.labRight.text);
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:STRING(self.labRight.text) forKey:@"linkText"];
    [userInfo setObject:STRING(self.itemMo.rightLink) forKey:@"url"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
}

#pragma mark - setter getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [UILabel new];
        _labLeft.textColor = COLOR_B2;
        _labLeft.font = Font_Regular(15);
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
        _labRight.font = Font_Regular(15);
        _labRight.dataDetectorTypes = MLDataDetectorTypeURL;
    }
    return _labRight;
}
@end
