//
//  JYHelperMessageCell.m
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "JYHelperMessageCell.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
#import "LocalRemarkHelp.h"

@interface JYHelperMessageCell ()
{
    CGFloat _cellHeight;
}
 
@end
@implementation JYHelperMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self.container.layer setBorderColor:self.contentView.backgroundColor.CGColor];
        self.avatarView.hidden = YES;
    }
    return self;
}

- (void)fillWithData:(JYHelperMessageCellData *)data;
{
    [super fillWithData:data];
    self.customData = data;
    NSInteger tableItemCount = self.customData.dataMo.table.count;
    // 如果没有处理过，才去查询数据库
    if (!self.customData.isDealed.boolValue) {
        self.customData.isDealed = @([LocalRemarkHelp getRemarkByMsgId:data.msgId fromConvType:data.fromId fromDefault:NO]);
    }
    self.redView.hidden = self.customData.isDealed.boolValue;
    [self.labTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(self.customData.isDealed.boolValue?15:27);
    }];

    self.labTitle.text = self.customData.dataMo.title;
    self.labTime.text = self.customData.dataMo.businessDate;
    self.labTips.text = self.customData.dataMo.tips;
    
    // 内容为空
    if (self.customData.dataMo.abstracts.length == 0) {
        self.labContent.text = @"";
        self.labContent.hidden = YES;
        
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labContent);
        }];
    } else {
        self.labContent.hidden = NO;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.customData.dataMo.abstracts];
        // 设置文字间隙
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 0.0;
        NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
        if (self.customData.dataMo.abstractsLink.length > 0) {
            [mutableStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, mutableStr.length)];
            [mutableStr addAttribute:NSForegroundColorAttributeName value:COLOR_LINK range:NSMakeRange(0, mutableStr.length)];
            [mutableStr addAttribute:NSFontAttributeName value:Font_Regular(15) range:NSMakeRange(0, mutableStr.length)];
        }
        self.labContent.attributedText = mutableStr;
        
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labContent.mas_bottom).offset(10);
        }];
        
        __weak typeof(self) weakSelf = self;
        [self.labContent setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSLog(@"click ---- %@", linkText);
            NSMutableDictionary *userInfo = [NSMutableDictionary new];
            [userInfo setObject:STRING(linkText) forKey:@"linkText"];
            [userInfo setObject:STRING(weakSelf.customData.dataMo.abstractsLink) forKey:@"url"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
        }];
    }
    
    self.table.arrData = self.customData.dataMo.table;
    [self.table reloadData];
    [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.customData.dataMo.table.count * 38));
    }];
    
    [self.labTips mas_updateConstraints:^(MASConstraintMaker *make) {
        if (tableItemCount == 0) {
            make.top.equalTo(self.table);
        } else {
            make.top.equalTo(self.table.mas_bottom).offset(10);
        }
    }];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.messageData.direction == MsgDirectionIncoming) {
        CGSize csize = [self.messageData contentSize];
        self.container.mm_left(0)
        .mm_top(0).mm_width(csize.width).mm_height(csize.height);
    }
}

- (UIView *)setupUI {
    _cellHeight = 38;
    [self.container addSubview:self.baseView];
    [self.baseView addSubview:self.redView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.table];
    [self.baseView addSubview:self.labTips];

    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container).offset(10);
        make.left.equalTo(self.container).offset(25);
        make.right.equalTo(self.container).offset(-25);
        make.bottom.equalTo(self.container).offset(-10);
    }];

    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(21);
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@8);
    }];

    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(15);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];

    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(8);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];

    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];

    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(15);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@(0));
        make.bottom.lessThanOrEqualTo(self.baseView.mas_bottom).offset(-15);
    }];

    [self.labTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.table.mas_bottom).offset(10);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];

    return self.baseView;
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.cornerRadius = 5;
        _baseView.clipsToBounds = YES;
    }
    return _baseView;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _redView.layer.mask = [Utils drawContentFrame:_redView.bounds corners:UIRectCornerAllCorners cornerRadius:4];
        _redView.backgroundColor = COLOR_C2;
    }
    return _redView;
}

- (MLLinkLabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[MLLinkLabel alloc] init];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = Font_Regular(17);
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (MLLinkLabel *)labTime {
    if (!_labTime) {
        _labTime = [[MLLinkLabel alloc] init];
        _labTime.textColor = COLOR_B3;
        _labTime.font = Font_Regular(12);
        _labTime.numberOfLines = 0;
    }
    return _labTime;
}

- (MLLinkLabel *)labContent {
    if (!_labContent) {
        _labContent = [[MLLinkLabel alloc] init];
        _labContent.textColor = COLOR_B2;
        _labContent.font = Font_Regular(15);
        _labContent.dataDetectorTypes = MLDataDetectorTypeURL;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (MLLinkLabel *)labTips {
    if (!_labTips) {
        _labTips = [[MLLinkLabel alloc] init];
        _labTips.textColor = COLOR_B2;
        _labTips.font = Font_Regular(12);
        _labTips.dataDetectorTypes = MLDataDetectorTypeURL;
        _labTips.numberOfLines = 0;
    }
    return _labTips;
}

- (HelpListTableView *)table {
    if (!_table) {
        _table = [[HelpListTableView alloc] initWithFrame:CGRectZero];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.layer.borderColor = COLOR_LINE.CGColor;
        _table.layer.borderWidth = 0.5;
        _table.scrollEnabled = NO;
    }
    return _table;
}

@end
