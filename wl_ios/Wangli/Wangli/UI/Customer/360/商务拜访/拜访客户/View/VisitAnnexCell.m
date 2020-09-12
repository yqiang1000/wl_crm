//
//  VisitAnnexCell.m
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "VisitAnnexCell.h"

@implementation VisitAnnexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.labTitle];
    [self.baseView addSubview:self.labContent];
    [self.baseView addSubview:self.btnCreate];
    [self.baseView addSubview:self.collectionView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.btnCreate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.width.height.equalTo(@45.0);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(17);
        make.left.equalTo(self.baseView).offset(16);
        make.right.lessThanOrEqualTo(self.btnCreate.mas_left);
    }];
    
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(10);
        make.left.equalTo(self.labTitle);
        make.right.lessThanOrEqualTo(self.btnCreate).offset(-15);
        make.bottom.lessThanOrEqualTo(self.baseView).offset(-17);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).offset(15);
        make.left.equalTo(self.labTitle);
        make.height.equalTo(@0.0);
        make.right.lessThanOrEqualTo(self.btnCreate).offset(-15);
        make.bottom.lessThanOrEqualTo(self.baseView).offset(-17);
    }];
}

#pragma mark - public

- (void)loadData:(VisitNoteMo *)model {
    if (_model != model) {
        _model = model;
    }
    self.labTitle.text = _model.title;
    [self.btnCreate setImage:[UIImage imageNamed:_model.model.images.count==0?@"add_business":@"编辑"] forState:UIControlStateNormal];
    if (_model.model.images.count == 0) {
        self.labContent.text = @"暂无记录";
        self.collectionView.hidden = YES;
        self.labContent.hidden = NO;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
        }];
    } else {
        self.collectionView.hidden = NO;
        self.labContent.hidden = YES;
        self.labContent.text = @"";
        self.collectionView.count = 9;
        self.collectionView.attachments = _model.model.images;
        [self.collectionView reloadData];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60.0);
        }];
    }
    [self.baseView layoutIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark - event

- (void)btnCreateClick:(UIButton *)sender {
    if (_visitAnnexCellDelegate && [_visitAnnexCellDelegate respondsToSelector:@selector(visitAnnexCell:btnActionIndexPath:)]) {
        [_visitAnnexCellDelegate visitAnnexCell:self btnActionIndexPath:self.indexPath];
    }
}

#pragma mark - lazy

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_000000;
        _labTitle.numberOfLines = 0;
    }
    return _labTitle;
}

- (UILabel *)labContent {
    if (!_labContent) {
        _labContent = [[UILabel alloc] init];
        _labContent.font = FONT_F13;
        _labContent.textColor = COLOR_B2;
        _labContent.numberOfLines = 0;
    }
    return _labContent;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = COLOR_B4;
        _baseView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.35].CGColor;
        _baseView.layer.shadowOffset = CGSizeMake(0,2);
        _baseView.layer.shadowOpacity = 1;
        _baseView.layer.shadowRadius = 8;
        _baseView.layer.borderWidth = 0.5;
        _baseView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:0.5].CGColor;
        _baseView.layer.cornerRadius = 5;
    }
    return _baseView;
}

- (UIButton *)btnCreate {
    if (!_btnCreate) {
        _btnCreate = [[UIButton alloc] init];
        [_btnCreate setImage:[UIImage imageNamed:@"add_business"] forState:UIControlStateNormal];
        [_btnCreate addTarget:self action:@selector(btnCreateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnCreate;
}

- (AttachmentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 10;
        _collectionView = [[AttachmentCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.forbidDelete = YES;
//        __weak typeof (self) weakSelf = self;
//        [_collectionView setCountChange:^(NSInteger x) {
//            weakSelf.model.imgaes = weakSelf.collectionView.arrImgs;
////            [weakSelf.leftLabel setLeftLength:weakSelf.arrImgs.count totalLength:weakSelf.count];
//            if (weakSelf.countChange) {
//                weakSelf.countChange(x);
//            }
//        }];
    }
    return _collectionView;
}

@end
