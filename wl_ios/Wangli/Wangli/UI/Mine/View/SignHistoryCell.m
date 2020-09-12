
//
//  SignHistoryCell.m
//  Wangli
//
//  Created by yeqiang on 2019/3/21.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SignHistoryCell.h"
#import "JGGImageView.h"

@interface SignHistoryCell ()
{
    CGFloat _jggWidth;
}

@property (nonatomic, strong) UILabel *labSign;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UIImageView *imgLocal;
@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labNote;
@property (nonatomic, strong) JGGImageView *imgContent;

@end

@implementation SignHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _jggWidth = (SCREEN_WIDTH - 50)/3.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labSign];
    [self.contentView addSubview:self.labTime];
    [self.contentView addSubview:self.imgLocal];
    [self.contentView addSubview:self.labAddress];
    [self.contentView addSubview:self.labNote];
    [self.contentView addSubview:self.imgContent];
    [self.contentView addSubview:self.lineView];
    
    [self.labSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labSign);
        make.left.equalTo(self.labSign.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.imgLocal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labSign.mas_bottom).offset(10);
        make.left.equalTo(self.labSign);
        make.width.equalTo(@11.0);
        make.height.equalTo(@14.0);
    }];
    
    [self.labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgLocal);
        make.left.equalTo(self.imgLocal.mas_right).offset(5);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.labNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labAddress.mas_bottom).offset(10);
        make.top.greaterThanOrEqualTo(self.imgLocal.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.imgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labNote.mas_bottom).offset(10);
        make.left.equalTo(self.labSign);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

- (void)loadData:(SignInMo *)model {
    if (_model != model) _model = model;
    self.labTime.text = _model.signInDate;
    self.labAddress.text = _model.address.length==0?@"未识别你的位置，请修改地址":_model.address;
    if (_model.signType) {
        self.labSign.text = [NSString stringWithFormat:@"%@日期", STRING(_model.signType[@"value"])];
    } else {
        self.labSign.text = @"签到日期";
    }
    
    self.labNote.text = [NSString stringWithFormat:@"备注：%@", _model.remark.length == 0 ?@"无" : _model.remark];

    self.imgContent.hidden = NO;
    self.imgContent.arrImgs = [[NSMutableArray alloc] initWithArray:_model.attachments];
    [self.imgContent reloadData];
    
    if (_model.hasImgUrl) {
        // 行数
        NSInteger x = _model.arrImgs.count / 3;
        NSInteger y = _model.arrImgs.count % 3;
        x = x + (y == 0 ? 0 : 1);
        NSInteger jggHeight = x * (_jggWidth + 10) - 10;
        [self.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(jggHeight));
            make.top.equalTo(self.labNote.mas_bottom).offset(10);
        }];
    } else {
        self.imgContent.hidden = YES;
        [self.imgContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.0);
            make.top.equalTo(self.labNote.mas_bottom);
        }];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - setter and getter

- (UILabel *)labSign {
    if (!_labSign) {
        _labSign = [[UILabel alloc] init];
        _labSign.textColor = COLOR_B2;
        _labSign.font = FONT_F13;
        _labSign.text = @"日期";
    }
    return _labSign;
}

- (UILabel *)labTime {
    if (!_labTime) {
        _labTime = [[UILabel alloc] init];
        _labTime.textColor = COLOR_B1;
        _labTime.font = FONT_F13;
    }
    return _labTime;
}

- (UIImageView *)imgLocal {
    if (!_imgLocal) {
        _imgLocal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m_location"]];
    }
    return _imgLocal;
}

- (UILabel *)labAddress {
    if (!_labAddress) {
        _labAddress = [[UILabel alloc] init];
        _labAddress.textColor = COLOR_B2;
        _labAddress.font = FONT_F13;
        _labAddress.numberOfLines = 0;
    }
    return _labAddress;;
}


- (UILabel *)labNote {
    if (!_labNote) {
        _labNote = [[UILabel alloc] init];
        _labNote.textColor = COLOR_B2;
        _labNote.font = FONT_F13;
        _labNote.numberOfLines = 0;
    }
    return _labNote;;
}

- (UIView *)lineView {
    if (!_lineView) _lineView = [Utils getLineView];
    return _lineView;
}

- (JGGImageView *)imgContent {
    if (!_imgContent) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(_jggWidth, _jggWidth);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _imgContent = [[JGGImageView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return _imgContent;
}


@end
