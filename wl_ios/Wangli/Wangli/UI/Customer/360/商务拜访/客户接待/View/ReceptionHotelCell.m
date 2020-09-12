//
//  ReceptionHotelCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ReceptionHotelCell.h"

@interface ReceptionHotelCell ()

@end

@implementation ReceptionHotelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labContent];
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [UILabel new];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B1;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

@end
