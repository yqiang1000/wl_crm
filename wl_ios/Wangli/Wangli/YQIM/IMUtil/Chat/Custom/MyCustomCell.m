//
//  MyCustomCell.m
//  TUIKitDemo
//
//  Created by annidyfeng on 2019/6/10.
//  Copyright © 2019年 Tencent. All rights reserved.
//
/** 腾讯云IM Demo自定义气泡视图
 *  用于显示聊天气泡中的文本信息数据
 *
 */
#import "MyCustomCell.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"

@implementation MyCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _myTextLabel = [[UILabel alloc] init];
        _myTextLabel.numberOfLines = 0;
        _myTextLabel.font = [UIFont systemFontOfSize:15];
        [self.container addSubview:_myTextLabel];

        _myLinkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _myLinkLabel.text = @"查看详情>>";
        _myLinkLabel.font = [UIFont systemFontOfSize:15];
        _myLinkLabel.textColor = [UIColor blueColor];
        [self.container addSubview:_myLinkLabel];

        self.container.backgroundColor = [UIColor whiteColor];
        [self.container.layer setMasksToBounds:YES];
        [self.container.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.container.layer setBorderWidth:1];
        [self.container.layer setCornerRadius:5];
    }
    return self;
}

- (void)fillWithData:(MyCustomCellData *)data;
{
    [super fillWithData:data];
    self.customData = data;
    self.myTextLabel.text = data.text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myTextLabel.mm_top(10).mm_left(10).mm_flexToRight(10).mm_flexToBottom(50);
    self.myLinkLabel.mm_sizeToFit().mm_left(10).mm_bottom(10);
}
@end
