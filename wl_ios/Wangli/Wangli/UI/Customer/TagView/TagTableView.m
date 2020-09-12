//
//  TagTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/9/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TagTableView.h"
#import <TTGTagCollectionView/TTGTagCollectionView.h>

#pragma mark - TagTableView

@interface TagTableView () <UITableViewDelegate, UITableViewDataSource, TagCellDelegate>

@property (nonatomic, strong) TagHeaderView *headerView0;
@property (nonatomic, strong) TagHeaderView *headerView1;

@end

@implementation TagTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (!_headerView0) {
            _headerView0 = [[TagHeaderView alloc] init];
            _headerView0.title = @"已选标签";
        }
        return _headerView0;
    } else {
        if (!_headerView1) {
            _headerView1 = [[TagHeaderView alloc] init];
            _headerView1.title = @"常用标签";
        }
        return _headerView1;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tagCell";
    TagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.cellDelegate = self;
    }
    cell.indexPath = indexPath;
    if (indexPath.section == 0) {
        [cell loadData:self.data0 showX:YES];
    } else {
        [cell loadData:self.data showX:NO];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagTableViewDidScrollView:)]) {
        [_tagDelegate tagTableViewDidScrollView:self];
    }
}

#pragma mark - TagCellDelegate

- (void)tagCell:(TagCell *)tagCell didSelectIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(tagTableView:didSelectIndexPath:)]) {
        [_tagDelegate tagTableView:self didSelectIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
    }
}

#pragma mark - lazy

- (NSMutableArray<TagMo *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSMutableArray<TagMo *> *)data0 {
    if (!_data0) {
        _data0 = [NSMutableArray new];
    }
    return _data0;
}

@end

#pragma mark - TagCell

@interface TagCell () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>

@property (nonatomic, strong) TTGTagCollectionView *ttCollection;

@end

@implementation TagCell

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
    return self.viewData[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(tagCell:didSelectIndexPath:index:)]) {
        [_cellDelegate tagCell:self didSelectIndexPath:self.indexPath index:index];
    }
    
//    TagMo *tmpMo = self.data[index];
//    tmpMo.isSelect = !tmpMo.isSelect;
//
//    UILabel *lab = (UILabel *)self.viewData[index];
//    lab.textColor = tmpMo.isSelect?COLOR_0089D1:COLOR_B1;
//    lab.backgroundColor = tmpMo.isSelect?COLOR_B4:COLOR_F4F4F4;
//
//    [tagCollectionView reload];
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.data.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    return self.viewData[index];
}

- (void)loadData:(NSArray<TagMo *> *)data showX:(BOOL)showX {
    [self.viewData removeAllObjects];
    [self.data removeAllObjects];
    for (NSInteger i = 0; i < data.count; i++) {
        TagMo *tmpMo = data[i];
        [self.data addObject:tmpMo];
        NSString *text = showX ? [NSString stringWithFormat:@"%@ X" , tmpMo.desp] : tmpMo.desp;
        [self.viewData addObject:[self newLabelWithText:text font:FONT_F13 textColor:showX?COLOR_0089D1:COLOR_B1 backgroundColor:showX?COLOR_B4:COLOR_F4F4F4]];
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

- (NSMutableArray<TagMo *> *)data {
    if (!_data) {
        _data = [NSMutableArray new];
    }
    return _data;
}

- (NSMutableArray<UIView *> *)viewData {
    if (!_viewData) {
        _viewData = [NSMutableArray new];
    }
    return _viewData;
}


@end


#pragma mark - TagHeaderView

@interface TagHeaderView ()

@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation TagHeaderView

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
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.lessThanOrEqualTo(self).offset(-15);
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
        _labTitle.textColor = COLOR_B2;
        _labTitle.font = FONT_F14;
    }
    return _labTitle;
}

@end
