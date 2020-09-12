
//
//  TrendsMoreCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsMoreCell.h"

@interface TrendsMoreCell ()

@end

@implementation TrendsMoreCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labText];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.top.left.equalTo(self.contentView);
    }];
}

- (void)loadData:(NSString *)text {
    self.labText.text = STRING(text);
}

#pragma mark - lazy

- (UILabel *)labText {
    if (!_labText) {
        _labText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 53, 32)];
        _labText.textAlignment = NSTextAlignmentCenter;
        _labText.textColor = COLOR_B1;
        _labText.font = FONT_F12;
    }
    return _labText;
}

@end
