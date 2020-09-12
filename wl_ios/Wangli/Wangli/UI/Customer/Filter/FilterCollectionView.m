//
//  FilterCollectionView.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterCollectionView.h"
#import "FilterCell.h"
#import "MemberChooseMo.h"

static NSString *scortCell = @"scortCell";
static NSString *filterCell = @"filterCell";
static NSString *filterTimeCell = @"filterTimeCell";
static NSString *filterHeaderView = @"filterHeaderView";
static NSString *filterFooterView = @"filterFooterView";

@interface FilterCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterHeaderViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIButton *btnBegin;
@property (nonatomic, strong) UIButton *btnEnd;

@end

@implementation FilterCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        _sourceType = 0;
        _selectTag = 0;
        _flowLayout = (UICollectionViewFlowLayout *)layout;
        [self registerClass:[ScortCell class] forCellWithReuseIdentifier:scortCell];
        [self registerClass:[FilterCell class] forCellWithReuseIdentifier:filterCell];
        [self registerClass:[FilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterHeaderView];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:filterFooterView];
    }
    return self;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_sourceType == 0) {
        return 1;
    } else if (_sourceType == 1) {
        return _arrData.count;
    }
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_sourceType == 0) {
        return self.arrData.count;
    } else if (_sourceType == 1) {
        MemberChooseMo *mo = self.arrData[section];;
        return mo.hidden ? 0 : mo.chooseBeans.count;
    }
    return self.arrData.count;
}

// item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_sourceType == 1) {
        FilterCell *cell = (FilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:filterCell forIndexPath:indexPath];
        
        if (indexPath.section < self.arrData.count) {
            MemberChooseMo *mo = self.arrData[indexPath.section];
            ChooseBeansMo *beanMo = [[ChooseBeansMo alloc] initWithDictionary:(NSDictionary *)mo.chooseBeans[indexPath.row] error:nil];
            cell.labName.text = beanMo.key;
        }
        [cell setCellIsSelected:[self.indexPathArr containsObject:indexPath]];
        return cell;
    }
    
    ScortCell *cell = (ScortCell *)[collectionView dequeueReusableCellWithReuseIdentifier:scortCell forIndexPath:indexPath];
    
    if (indexPath.item < self.arrData.count) {
        NSString *str = self.arrData[indexPath.item];
        cell.labTxt.text = str;
        cell.labTxt.textColor = indexPath.row == _selectTag ? COLOR_C1 : COLOR_B1;
        cell.imgArraw.hidden = indexPath.row == _selectTag ? NO : YES;
    }
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sourceType == 0) {
        return CGSizeMake(SCREEN_WIDTH, 44);
    } else if (_sourceType == 1) {
        return CGSizeMake((SCREEN_WIDTH-25-30-20)*1.0/3, 32);
    }
    return CGSizeMake(SCREEN_WIDTH, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_sourceType == 0) {
        return CGSizeMake(SCREEN_WIDTH,0);;
    } else if (_sourceType == 1) {
        return CGSizeMake(SCREEN_WIDTH-25, 44);
    }
    return CGSizeMake(SCREEN_WIDTH,0);
}

//footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH,0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_sourceType == 0) {
        return 0;
    } else if (_sourceType == 1) {
        return 10;
    }
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_sourceType == 0) {
        return 0;
    } else if (_sourceType == 1) {
        return 10;
    }
    return 0;
}

// header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (_sourceType == 1) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            FilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterHeaderView forIndexPath:indexPath];
            headerView.headerDelegate = self;
            MemberChooseMo *mo = self.arrData[indexPath.section];
            headerView.indexPath = indexPath;
            [headerView setHidenLine:!mo.hidden];
            if (mo.hidden) {
                __block BOOL contains = NO;
                __block NSIndexPath *currentIndexPath = nil;
                [self.indexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSIndexPath *tmpIndexPath = (NSIndexPath *)obj;
                    if (tmpIndexPath.section == indexPath.section) {
                        contains = YES;
                        currentIndexPath = tmpIndexPath;
                        *stop = YES;
                    }
                }];
                
                if (contains) {
                    if (mo.chooseBeans.count > 0) {
                        NSDictionary *dic = (NSDictionary *)mo.chooseBeans[currentIndexPath.row];
                        [headerView rightText:dic[@"key"]];
                    } else {
                        [headerView rightText:@"请选择"];
                    }
                } else {
                    [headerView rightText:@"请选择"];
                }
            } else {
                [headerView rightText:@""];
            }
            [headerView leftText:mo.name];
            return headerView;
        } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:filterFooterView forIndexPath:indexPath];
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
            footerView.backgroundColor = COLOR_B0;
            return footerView;
        }
    } else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:filterFooterView forIndexPath:indexPath];
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
            footerView.backgroundColor = COLOR_B0;
            return footerView;
        } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:filterFooterView forIndexPath:indexPath];
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
            footerView.backgroundColor = COLOR_B0;
            return footerView;
        }
    }
    return nil;
}

//- (void)btnMoreClick:(UIButton *)sender {
//    // 查看更多
//    if (_userListViewDelegate && [_userListViewDelegate respondsToSelector:@selector(userListViewShowMore:)]) {
//        [_userListViewDelegate userListViewShowMore:self];
//    }
//}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sourceType == 0) {
        if (_selectTag != indexPath.item) {
            _selectTag = indexPath.item;
            [self reloadData];
        }
        
        if ([_filterCollectionViewDelegate respondsToSelector:@selector(filterCollectionView:didSelectIndexPath:)]) {
            [_filterCollectionViewDelegate filterCollectionView:self didSelectIndexPath:indexPath];
        }
    } else if (_sourceType == 1) {
        
//        __block BOOL isAdd = YES;
//        [self.indexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSIndexPath *inIndexPath = obj;
//            if (inIndexPath.section == indexPath.section) {
//                [self.indexPathArr removeObject:obj];
//                if (inIndexPath.item == indexPath.item) {
//                    isAdd = NO;
//                } else {
//                    isAdd = YES;
//                }
//            } else {
//                isAdd = YES;
//            }
//        }];
//
//        if (isAdd) {
//            [self.indexPathArr addObject:indexPath];
//        } else {
//            [self.indexPathArr removeObject:indexPath];
//        }
//        [self reloadData];
        if ([_filterCollectionViewDelegate respondsToSelector:@selector(filterCollectionView:didSelectIndexPath:)]) {
            [_filterCollectionViewDelegate filterCollectionView:self didSelectIndexPath:indexPath];
        }
    } else if (_sourceType == 2) {
        if (_selectTag != indexPath.item) {
            _selectTag = indexPath.item;
            [self.indexPathArr removeAllObjects];
            [self.indexPathArr addObject:indexPath];
            [self reloadData];
        }
        
        if ([_filterCollectionViewDelegate respondsToSelector:@selector(filterCollectionView:didSelectIndexPath:)]) {
            [_filterCollectionViewDelegate filterCollectionView:self didSelectIndexPath:indexPath];
        }
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ScortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scortCell forIndexPath:indexPath];
//    cell.labTxt.textColor = COLOR_B1;
//}

#pragma mark - FilterHeaderViewDelegate

- (void)filterHeaderViewSelected:(FilterHeaderView *)filterHeaderView indexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", indexPath.section);
    NSLog(@"%ld", indexPath.item);
    if (_filterCollectionViewDelegate && [_filterCollectionViewDelegate respondsToSelector:@selector(filterCollectionView:didSelectHeaderView:indexPath:defaultIndex:)]) {
        NSInteger defaultIndex = -1;
        for (NSIndexPath *defaultIndexPath in self.indexPathArr) {
            if (defaultIndexPath.section == indexPath.section) {
                defaultIndex = defaultIndexPath.row;
                break;
            }
        }
        [_filterCollectionViewDelegate filterCollectionView:self didSelectHeaderView:filterHeaderView indexPath:indexPath defaultIndex:defaultIndex];
    }
}

#pragma mark - event


#pragma mark - public

- (void)setSourceType:(NSInteger)sourceType {
    _sourceType = sourceType;
    if (_sourceType == 2) {
        UIEdgeInsets edg = _flowLayout.sectionInset;
        edg.bottom = 12;
        edg.top = 12;
        _flowLayout.sectionInset = edg;
        [self reloadData];
    }
}

#pragma mark - setter getter

- (NSArray *)arrData {
    if (!_arrData) {
        _arrData = [NSArray new];
    }
    return _arrData;
}

- (NSMutableArray *)indexPathArr {
    if (!_indexPathArr) {
        _indexPathArr = [NSMutableArray new];
    }
    return _indexPathArr;
}

@end

