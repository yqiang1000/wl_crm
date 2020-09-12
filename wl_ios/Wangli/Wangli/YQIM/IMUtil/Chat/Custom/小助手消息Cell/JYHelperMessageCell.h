//
//  JYHelperMessageCell.h
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TUIMessageCell.h"
#import "JYHelperMessageCellData.h"
#import "MLLinkLabel.h"
#import "HelpListTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYHelperMessageCell : TUIMessageCell

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *redView;


@property (nonatomic, strong) MLLinkLabel *labTitle;
@property (nonatomic, strong) MLLinkLabel *labTime;
@property (nonatomic, strong) MLLinkLabel *labContent;
@property (nonatomic, strong) MLLinkLabel *labTips;

@property (nonatomic, strong) HelpListTableView *table;

@property JYHelperMessageCellData *customData;

- (void)fillWithData:(JYHelperMessageCellData *)data;

@end

NS_ASSUME_NONNULL_END
