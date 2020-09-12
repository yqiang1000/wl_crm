//
//  ReplyCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ReplyCell.h"

@interface ReplyCell ()

@property (nonatomic, strong) UILabel *labReply;
@property (nonatomic, strong) UILabel *labContent;

@end

@implementation ReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labReply];
    [self.contentView addSubview:self.labContent];
    
    [self.labReply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labReply.mas_right).offset(5);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    UIView *lineView = [Utils getLineView];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labReply);
        make.right.equalTo(self.labContent);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)loadData:(NSString *)reply content:(NSString *)content {
    self.labReply.text = reply;
    self.labContent.text = content;
    [self layoutIfNeeded];
}

#pragma mark - lazy

- (UILabel *)labReply {
    if (!_labReply) {
        _labReply = [[UILabel alloc] init];
        _labReply.font = FONT_F13;
        _labReply.textColor = COLOR_336699;
    }
    return _labReply;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [[UILabel alloc] init];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B1;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}


@end
