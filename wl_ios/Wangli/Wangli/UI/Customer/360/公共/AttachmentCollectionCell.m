//
//  AttachmentCollectionCell.m
//  Wangli
//
//  Created by yeqiang on 2018/5/30.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AttachmentCollectionCell.h"

@implementation AttachmentCollectionCell

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
        make.width.height.equalTo(@17);
    }];
}

#pragma mark - public

- (void)btnDeleteClick:(UIButton *)sender {
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(cell:deleteIndexPath:)]) {
        [_cellDelegate cell:self deleteIndexPath:self.indexPath];
    }
}

- (void)showImage:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.imgView.image = image;
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:((QiniuFileMo *)image).thumbnail] placeholderImage:[UIImage imageNamed:@"riskImage_empty"]];
    }
}

//- (void)loadDataWith:(CommonItemMo *)model {
//    _mo = model;
//    self.labTitle.text = _mo.text;
//    self.imgIcon.image = [UIImage imageNamed:_mo.imgName];
//}

#pragma mark - setter getter

- (BaseImageView *)imgView {
    if (!_imgView) {
        _imgView = [[BaseImageView alloc] init];
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
