
//
//  AttachmentCell.m
//  Wangli
//
//  Created by yeqiang on 2018/5/4.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "AttachmentCell.h"
#import "LeftLabel.h"

@interface AttachmentCell ()
{
    CGFloat _cellHeight;
    CGFloat _cellWidth;
}

@property (nonatomic, strong) LeftLabel *leftLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AttachmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellWidth = _cellHeight = 60;
        self.count = 9;
        _showLine = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cellWidth = _cellHeight = 60;
        self.count = 9;
        _showLine = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labTitle];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.leftLabel];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.labTitle);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@60.0);
        make.top.equalTo(self.contentView).offset(45);
    }];
}

#pragma mark - public

- (void)setCount:(NSInteger)count {
    _count = count;
    self.collectionView.count = _count;
    [self.leftLabel setLeftLength:self.attachments.count totalLength:_count];
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    if (_showLine) {
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@0.5);
        }];
    } else {
        [_lineView removeFromSuperview];
        _lineView = nil;
    }
}

- (void)refreshView {
    self.collectionView.attachments = self.attachments;
    self.collectionView.forbidDelete = self.forbidDelete;
    [self.leftLabel setLeftLength:self.attachments.count totalLength:_count];
    self.leftLabel.hidden = self.forbidDelete;
    [self.collectionView reloadData];
}

#pragma mark - setter getter

- (AttachmentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 10;
        _collectionView = [[AttachmentCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.forbidDelete = _forbidDelete;
        __weak typeof (self) weakSelf = self;
        [_collectionView setCountChange:^(NSInteger x) {
//            weakSelf.attachments = weakSelf.collectionView.attachments;
            [weakSelf.leftLabel setLeftLength:weakSelf.attachments.count totalLength:weakSelf.count];
            if (weakSelf.countChange) {
                weakSelf.countChange(x);
            }
        }];
    
    }
    return _collectionView;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}


- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F16;
        _labTitle.textColor = COLOR_B1;
        _labTitle.text = @"附件";
    }
    return _labTitle;
}

- (LeftLabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[LeftLabel alloc] init];
        [_leftLabel setLeftLength:self.attachments.count totalLength:_count];
    }
    return _leftLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

@end
