//
//  TrackDetailView.m
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrackDetailView.h"
#import "TrackDetailCell.h"
//#import "AttachmentCell.h"

@interface TrackDetailView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@implementation TrackDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.lineView];
    [self addSubview:self.labTitle];
    [self addSubview:self.tableView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@18);
        make.width.equalTo(@3);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineView);
        make.left.equalTo(self.lineView.mas_right).offset(7);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-15);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.mo.data.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 38;
    } else {
        return _showAttachments ? 120 : 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellId = @"TrackDetailCell";
        TrackDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[TrackDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        CusInfoDetailMo *tmpMo = self.mo.data[indexPath.row];
        [cell loadData:tmpMo];
        return cell;
    } else {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.contentView.layer.borderColor = COLOR_LINE.CGColor;
            cell.contentView.layer.borderWidth = 0.5;
            cell.count = 9;
            cell.labTitle.text = @"追加影像";
            cell.labTitle.textColor = COLOR_B2;
            cell.labTitle.font = FONT_F12;
            cell.attachments = _mo.attachments;
            cell.countChange = self.countChange;
            [cell refreshView];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y < 0) {
//        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    }
//}

#pragma mark - public

- (void)refreshView {
    self.labTitle.text = self.mo.title;
    [self.tableView reloadData];
}

#pragma mark - setter getter

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_C1;
        _lineView.layer.cornerRadius = 1.5;
        _lineView.clipsToBounds = YES;
    }
    return _lineView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = FONT_F14;
        _labTitle.textColor = COLOR_B1;
    }
    return _labTitle;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = COLOR_B4;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}

- (void)setMo:(CusInfoMo *)mo {
    _mo = mo;
    for (QiniuFileMo *tmpMo in _mo.attachments) {
        [self.attachments addObject:STRING(tmpMo.url)];
    }
}

@end
