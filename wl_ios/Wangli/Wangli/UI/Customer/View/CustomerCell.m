//
//  CustomerCell.m
//  Wangli
//
//  Created by yeqiang on 2018/4/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "CustomerCell.h"

@interface CustomerCell ()

@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation CustomerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgIcon];
    [self.contentView addSubview:self.labTitle];
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
//        make.top.equalTo(self.imgIcon.mas_bottom).offset(12);
    }];
}

#pragma mark - public

- (void)loadDataWith:(NSArray *)model touchEnable:(BOOL)touchEnable {
    
    NSString *imgName = model[1];
    UIImage *orgImage = [UIImage imageNamed:imgName];
    self.imgIcon.image = touchEnable ? orgImage : [Utils grayscaleImageForImage:orgImage];
    
    NSString *string = model[0];
    if ([string isKindOfClass:[NSString class]]) {
        //查找字符串是否包含“心”
        if ([string containsString:@"("]) {
            NSRange range1 = [string rangeOfString:@"("];
            NSRange range2 = [string rangeOfString:@")"];
            if (range1.location != NSNotFound && range2.location != NSNotFound) {
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
                [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_EC675D range:NSMakeRange(range1.location+1, range2.location-range1.location-1)];
                self.labTitle.attributedText = attrStr;
            }
        } else {
            self.labTitle.text = model[0];
        }
    }
}

#pragma mark - setter getter

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
    }
    return _imgIcon;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F13;
        _labTitle.textColor = COLOR_B2;
    }
    return _labTitle;
}

@end
