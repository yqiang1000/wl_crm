//
//  DefaultHeaderCell.m
//  Wangli
//
//  Created by yeqiang on 2019/1/6.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DefaultHeaderCell.h"

@interface DefaultHeaderCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation DefaultHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@17.5);
        make.width.equalTo(@3.0);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.contentView addSubview:self.labLeft];
    [self.labLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.lineView.mas_right).offset(7);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
}

- (void)setIsHidenLine:(BOOL)isHidenLine {
    self.lineView.hidden = isHidenLine;
}

#pragma mark - setter getter

- (UILabel *)labLeft {
    if (!_labLeft) {
        _labLeft = [[UILabel alloc] init];
        _labLeft.textColor = COLOR_B1;
        _labLeft.font = FONT_F16;
    }
    return _labLeft;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 17.5)];
        _lineView.backgroundColor = COLOR_C1;
        _lineView.layer.mask = [Utils drawContentFrame:_lineView.bounds corners:UIRectCornerAllCorners cornerRadius:1.5];
    }
    return _lineView;
}

@end
