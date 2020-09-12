//
//  SearchCell.m
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/7.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import "SearchCell.h"
#import <TTGTagCollectionView/TTGTagCollectionView.h>

#pragma mark - SearchCell

@interface SearchCell ()

@property (nonatomic, strong) UILabel *labTxt;

@property (nonatomic, strong) UIButton *btnDele;

@end

@implementation SearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_B4;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labTxt];
    [self.contentView addSubview:self.btnDele];
    
    UIView *lineView = [Utils getLineView];
    [self.contentView addSubview:lineView];
    
    [self.labTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(19);
        make.right.equalTo(self.btnDele.mas_left).offset(-10);
    }];
    
    [self.btnDele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTxt);
        make.width.equalTo(@49);
        make.height.equalTo(_btnDele.mas_width);
        make.right.equalTo(self.contentView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labTxt);
        make.right.top.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - public

- (void)loadData:(NSString *)text {
    self.labTxt.text = text;
}

- (void)btnDeleteClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchCellDidDelete:)]) {
        [_delegate searchCellDidDelete:self];
    }
}

#pragma mark - setter and getter

- (UILabel *)labTxt {
    if (!_labTxt) {
        _labTxt = [[UILabel alloc] init];
        _labTxt.textColor = COLOR_B2;
        _labTxt.font = FONT_F13;
    }
    return _labTxt;
}

- (UIButton *)btnDele {
    if (!_btnDele) {
        _btnDele = [[UIButton alloc] init];
        _btnDele.hidden = YES;
        [_btnDele setImage:[UIImage imageNamed:@"搜索-phone-删除单条小叉"] forState:UIControlStateNormal];
        [_btnDele addTarget:self action:@selector(btnDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDele setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _btnDele;
}

@end

#pragma mark - HotCell

@interface HotCell () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>

@property (nonatomic, strong) TTGTagCollectionView *ttCollection;

@end

@implementation HotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.contentView.backgroundColor = COLOR_B4;
    
    [self.contentView addSubview:self.ttCollection];
    [self.ttCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    return self.data[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(hotCellDidSelected:message:indexPath:)]) {
        [_delegate hotCellDidSelected:index message:((UILabel *)tagView).text indexPath:self.indexPath];
    }
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.data.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    return self.data[index];
}

- (void)loadData:(NSArray *)data {
    [self.data removeAllObjects];
    for (NSInteger i = 0; i < data.count; i++) {
        [self.data addObject:[self newLabelWithText:data[i] font:FONT_F13 textColor:COLOR_B1 backgroundColor:COLOR_B0]];
    }
    [self.ttCollection reload];
}

- (UILabel *)newLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroudColor {
    UILabel *label = [UILabel new];
    
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text.length < 11 ? text : [text substringToIndex:10];
    label.textColor = textColor;
    label.backgroundColor = backgroudColor;
    [label sizeToFit];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = COLOR_LINE.CGColor;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4.0f;
    
    [self expandSizeForView:label extraWidth:32 extraHeight:20];
    
    return label;
}

- (void)expandSizeForView:(UIView *)view extraWidth:(CGFloat)extraWidth extraHeight:(CGFloat)extraHeight {
    CGRect frame = view.frame;
    frame.size.width += extraWidth;
    frame.size.height += extraHeight;
    view.frame = frame;
}

#pragma mark - event


#pragma mark - setter and getter

- (TTGTagCollectionView *)ttCollection {
    if (!_ttCollection) {
        _ttCollection = [[TTGTagCollectionView alloc] initWithFrame:CGRectZero];
        _ttCollection.delegate = self;
        _ttCollection.dataSource = self;
        _ttCollection.horizontalSpacing = 10.0;
        _ttCollection.verticalSpacing = 10.0;
        _ttCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //UIEdgeInsetsMake(5, 14, 5, 14);
    }
    return _ttCollection;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

@end


#pragma mark - SearchHeader

@interface SearchHeader ()

@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation SearchHeader

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    [self addSubview:self.labTitle];
    [self addSubview:self.btnClear];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(18);
    }];
    
    [self.btnClear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.labTitle.text = title;
}

#pragma mark - setter and getter

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = COLOR_B3;
        _labTitle.font = FONT_F13;
    }
    return _labTitle;
}

- (UIButton *)btnClear {
    if (!_btnClear) {
        _btnClear = [[UIButton alloc] init];
        [_btnClear setImage:[UIImage imageNamed:@"delete_01"] forState:UIControlStateNormal];
    }
    return _btnClear;
}

@end

#pragma mark - SearchFooter

@interface SearchFooter ()

@property (nonatomic, copy) NSString *title;

@end

@implementation SearchFooter


- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.btnBottom];
    
    //    UIView *lineView = [Utils getLineView];
    //    [self addSubview:lineView];
    
    [self.btnBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(18);
        make.centerX.equalTo(self);
    }];
    
    //    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.mas_left).offset(15);
    //        make.bottom.right.equalTo(self);
    //        make.height.equalTo(@0.5);
    //    }];
}

#pragma mark - setter and getter

- (UIButton *)btnBottom {
    if (!_btnBottom) {
        _btnBottom = [[UIButton alloc] init];
        [_btnBottom setTitle:_title forState:UIControlStateNormal];
        [_btnBottom setTitleColor:COLOR_B2 forState:UIControlStateNormal];
        _btnBottom.titleLabel.font = FONT_F13;
        [_btnBottom setBackgroundColor:[UIColor clearColor]];
    }
    return _btnBottom;
}

@end


