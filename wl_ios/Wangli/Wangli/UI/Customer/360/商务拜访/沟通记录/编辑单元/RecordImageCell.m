//
//  RecordImageCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "RecordImageCell.h"

@implementation RecordImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_B0;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.btnDelete];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.imgView).offset(2);
        make.right.equalTo(self.imgView).offset(-2);
        make.width.height.equalTo(@15.0);
    }];
}

#pragma mark - public

- (void)btnDeleteClick:(UIButton *)sender {
    if (_recordImageCellDelegate && [_recordImageCellDelegate respondsToSelector:@selector(recordImageCell:deleteIndexPath:)]) {
        [_recordImageCellDelegate recordImageCell:self deleteIndexPath:self.indexPath];
    }
}

- (void)showImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.imgView.image = image;
    } else if ([image isKindOfClass:[QiniuFileMo class]]) {
        QiniuFileMo *tmpImage = (QiniuFileMo *)image;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:tmpImage.thumbnail] placeholderImage:[UIImage imageNamed:@"riskImage_empty"]];
    }
    self.btnDelete.hidden = self.unDelete;
}

#pragma mark - setter getter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        _btnDelete = [[UIButton alloc] init];
        [_btnDelete setImage:[UIImage imageNamed:@"upload_close"] forState:UIControlStateNormal];
        [_btnDelete addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDelete;
}

@end
