
//
//  TrackTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrackTableView.h"
#import "RiskTotalCollectionView.h"
#import "RiskListMo.h"
#import "TrackViewCell.h"

@interface TrackTableView () <UITableViewDelegate, UITableViewDataSource, RiskTotalCollectionViewDelegate>

@property (nonatomic, strong) RiskTotalCollectionView *collectionView;

@end

@implementation TrackTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.backgroundColor = COLOR_B0;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.arrListData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// 48
// 163
// 15
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        
    } else if (indexPath.section == 1) {
        // 如果只有1条数据
        if (self.arrListData.count == 1) {
            return 48+163+15;
        }
        // 多条数据
        if (indexPath.row == 0) {
            return 48+163;
        } else {
            if (indexPath.row == self.arrListData.count - 1) {
                return 163+15;
            } else {
                return 163;
            }
        }
    }
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"trackCellHeader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.collectionView];
        self.collectionView.arrData = self.arrTopList;
        [self.collectionView reloadData];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(cell.contentView);
        }];
        [cell layoutIfNeeded];
        return cell;
    }
    else {
        static NSString *identifier = @"trackCell";
        TrackViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TrackViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        // 0 底部有边距
        NSInteger type = 0;
        if (indexPath.row == self.arrListData.count-1) {
            type = 0;
        } else {
            type = 1;
        }
        NSInteger cornerType = 0;// 0:无圆角。1:上两角 2:下边两角 3:四圆角
        // 如果只有1条数据
        if (self.arrListData.count == 1) {
            cornerType = 3;
        } else {
            if (indexPath.row == 0) {
                cornerType = 1;
            } else if (indexPath.row == self.arrListData.count - 1) {
                cornerType = 2;
            } else {
                cornerType = 0;
            }
        }
        
        [cell loadData:self.arrListData[indexPath.row] type:type cornerType:cornerType hidenTitle:indexPath.row == 0 ? NO : YES];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    if (_trackDelegate && [_trackDelegate respondsToSelector:@selector(trackTableView:didSelectIndexPath:)]) {
        [_trackDelegate trackTableView:self didSelectIndexPath:indexPath];
    }
}

#pragma mark - RiskTotalCollectionViewDelegate

- (void)riskTotalCollectionView:(RiskTotalCollectionView *)riskTotalCollectionView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (_trackDelegate && [_trackDelegate respondsToSelector:@selector(trackTableView:topCellDidSelectIndexPath:)]) {
        [_trackDelegate trackTableView:self topCellDidSelectIndexPath:indexPath];
    }
}

#pragma mark - event

#pragma mark - setter getter

- (RiskTotalCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _collectionView = [[RiskTotalCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = COLOR_B0;
        _collectionView.viewDelegate = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)arrTopList {
    if (!_arrTopList) {
        _arrTopList = [NSMutableArray new];
    }
    return _arrTopList;
}

- (NSMutableArray *)arrListData {
    if (!_arrListData) {
        _arrListData = [NSMutableArray new];
//        for (int i = 0 ; i < 10; i++) {
//            [_arrListData addObject:@"demo"];
//        }
    }
    return _arrListData;
}

@end
