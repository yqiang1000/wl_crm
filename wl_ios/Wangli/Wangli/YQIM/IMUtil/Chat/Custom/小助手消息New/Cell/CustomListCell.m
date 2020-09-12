//
//  CustomListCell.m
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "CustomListCell.h"
#import "LocalRemarkHelp.h"

@interface CustomListCell ()

{
    CGFloat _cellHeight;
}

@end

@implementation CustomListCell

- (UIView *)setupUI
{
    _cellHeight = 38;
    [self.container addSubview:self.baseView];
    [self.baseView addSubview:self.redView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.labTime];
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.tableView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(21);
        make.left.equalTo(self.baseView).offset(15);
        make.height.width.equalTo(@8);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(16);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(8);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTime.mas_bottom).offset(12);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.bottom.lessThanOrEqualTo(self.baseView).offset(-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labContent.mas_bottom).offset(15);
        make.left.equalTo(self.baseView).offset(15);
        make.right.equalTo(self.baseView).offset(-15);
        make.height.equalTo(@(0));
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-15);
    }];
    return self.baseView;
}


- (void)fillWithData:(NewHelpeMessageCellData *)data {
    [super fillWithData:data];
    self.customData = data;
    // 如果没有处理过，才去查询数据库
    if (!self.customData.isDealed.boolValue) {
        self.customData.isDealed = @([LocalRemarkHelp getRemarkByMsgId:data.msgId fromConvType:data.dataMo.FormatType fromDefault:NO]);
    }
    self.redView.hidden = self.customData.isDealed.boolValue;
    [self.labTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView).offset(self.customData.isDealed.boolValue?15:27);
    }];
    
    self.labTitle.text = self.customData.dataMo.Title;
    self.labTime.text = self.customData.dataMo.BusinessDate;
    self.labContent.attributedText = [YQNewChatUtils pieceStringByArray:self.customData.dataMo.Contents];
    __weak typeof(self) weakself = self;
    [self.labContent setDidLongPressLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        //        NSLog(@"click ---- %@", linkText);
        __strong typeof(self) strongself = weakself;
        NSMutableDictionary *userInfo = [NSMutableDictionary new];
        [userInfo setObject:STRING(linkText) forKey:@"linkText"];
        [userInfo setObject:STRING(strongself.customData.dataMo.MoreInfo.url) forKey:@"url"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CELL_LINK_SELECT object:nil userInfo:userInfo];
    }];
    
    self.tableView.arrData = self.customData.dataMo.Cells;
    [self.tableView reloadData];
    if (self.customData.dataMo.Cells.count == 0) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_cellHeight*self.customData.dataMo.Cells.count));
            make.top.equalTo(self.labContent.mas_bottom);
        }];
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_cellHeight*self.customData.dataMo.Cells.count));
            make.top.equalTo(self.labContent.mas_bottom).offset(15);
        }];
    }
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

#pragma mark - setter getter

- (MLLinkLabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[MLLinkLabel alloc] init];
        _labTitle.textColor = COLOR_B1;
        _labTitle.font = FONT_F17;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (MLLinkLabel *)labTime {
    if (!_labTime) {
        _labTime = [[MLLinkLabel alloc] init];
        _labTime.textColor = COLOR_B3;
        _labTime.font = FONT_F12;
        _labTime.numberOfLines = 0;
    }
    return _labTime;
}

- (MLLinkLabel *)labContent {
    if (!_labContent) {
        _labContent = [[MLLinkLabel alloc] init];
        _labContent.textColor = COLOR_B2;
        _labContent.font = FONT_F15;
        _labContent.dataDetectorTypes = MLDataDetectorTypeURL;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (NewHelpListTableView *)tableView {
    if (!_tableView) {
        _tableView = [[NewHelpListTableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.borderColor = COLOR_LINE.CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}



@end
