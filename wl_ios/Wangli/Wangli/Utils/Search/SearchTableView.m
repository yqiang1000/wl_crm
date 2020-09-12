//
//  SearchTableView.m
//  AbcPen-ipad
//
//  Created by yeqiang on 2017/8/8.
//  Copyright © 2017年 wangchun. All rights reserved.
//

#import "SearchTableView.h"
#import "SearchCell.h"

#define SEARCH_LIST             @"hotSearchList"

@interface SearchTableView () <UITableViewDelegate, UITableViewDataSource, SearchCellDelegate, HotCellDelegate>
{
    SearchHeader *_hotHeader;
    SearchHeader *_hisHeader;
    /** 缓存key */
    NSString *_cacheKey;
}
@end

@implementation SearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_B4;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isHidenHot ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableViewDidScroll:)]) {
        [_searchTableViewDelegate searchTableViewDidScroll:self];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isHidenHot) {
        NSMutableArray *searchList = [[NSUserDefaults standardUserDefaults] objectForKey:_isHidenHot ? _cacheKey : SEARCH_LIST];
        return searchList.count == 0 ? 0.01 : 30;
    } else {
        if (section == 0) {
            NSMutableArray *searchList = [[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey];
            return searchList.count == 0 ? 0.01 : 30;
        } else if (section == 1) {
            return self.hotData.count == 0 ? 0.01 : 30;
        }
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isHidenHot) {
        // 隐藏热门
        if (!_hisHeader) {
            _hisHeader = [[SearchHeader alloc] init];
        }
        _hisHeader.title = GET_LANGUAGE_KEY(@"历史记录");
        [_hisHeader.btnClear addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
        return _hisHeader;
    } else {
        if (section == 0) {
            if (!_hisHeader) {
                _hisHeader = [[SearchHeader alloc] init];
            }
            _hisHeader.title = GET_LANGUAGE_KEY(@"历史记录");
            [_hisHeader.btnClear addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
            return _hisHeader;
        } else {
            if (!_hotHeader) {
                _hotHeader = [[SearchHeader alloc] init];
            }
            _hotHeader.btnClear.hidden = YES;
            _hotHeader.title = GET_LANGUAGE_KEY(@"标签搜索");
            return _hotHeader;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"hotCell";
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey];
    if (_isHidenHot) {
        // 只有搜索
        HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        [cell loadData:arr];
        return cell;
    } else {
        // 有热门和搜索
        HotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[HotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        if (indexPath.section == 0) {
            [cell loadData:arr];
        } else {
            [cell loadData:self.hotData];
        }
        cell.indexPath = indexPath;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey];
//    if (indexPath.row < arr.count) {
//        _searchKey = arr[indexPath.row];
//
//        if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableView:didSelectedHistory:index:)]) {
//            [_searchTableViewDelegate searchTableView:self didSelectedHistory:_searchKey index:indexPath.row];
//        }
//    }
}

#pragma mark - HotCellDelegate

- (void)hotCellDidSelected:(NSUInteger)index message:(NSString *)message indexPath:(NSIndexPath *)indexPath {
    if (_searchTableViewDelegate && [_searchTableViewDelegate respondsToSelector:@selector(searchTableView:didSelectedHot:index:indexPath:)]) {
        [_searchTableViewDelegate searchTableView:self didSelectedHot:message index:index indexPath:indexPath];
    }
}

#pragma mark - publick

- (void)setSearchStyle:(SearchStyle *)searchStyle {
    _searchStyle = searchStyle;
    _cacheKey = _searchStyle.cacheKey;
    _isHidenHot = _searchStyle.isHidenHot;
    [self reloadData];
}

/** 热门搜索 */
- (void)setHotData:(NSMutableArray<NSString *> *)hotData {
    if (hotData) {
        _hotData = hotData;
        [self reloadData];
    }
}

/** 插入搜索记录 */
- (void)insertSearchKey:(NSString *)searchKey {
    
    _searchKey = searchKey;
    
    if (searchKey == nil || searchKey.length == 0) {
        return;
    }
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey];
    if (array.count > 10) {
        array = [array subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:array];
    if (searchList == nil) {
        searchList = [[NSMutableArray alloc] init];
    }
    __block BOOL isHas = NO;
    __block NSInteger index = 0;
    
    [searchList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:searchKey]) {
            isHas = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (isHas) {
        [searchList removeObjectAtIndex:index];
    }
    
    [searchList insertObject:STRING(searchKey) atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:_cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 根据关键字删除搜索记录 */
- (void)deleteHistoryBySearchKey:(NSString *)searchKey {
    
    _searchKey = searchKey;
    
    if (_searchKey == nil || _searchKey.length == 0) {
        return;
    }
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey];
    if (array.count > 10) {
        array = [array subarrayWithRange:NSMakeRange(0, 10)];
    }
    
    NSMutableArray *searchList = [[NSMutableArray alloc] initWithArray:array];
    if (searchList == nil) {
        searchList = [[NSMutableArray alloc] init];
    }
    __block BOOL isHas = NO;
    __block NSInteger index = 0;
    
    [searchList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj;
        if ([str isEqualToString:searchKey]) {
            isHas = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (isHas) {
        [searchList removeObjectAtIndex:index];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchList forKey:_cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 根据索引删除搜索记录 */
- (void)deleteHistoryByIndex:(NSInteger)index {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:_cacheKey]];
    if (index < array.count) {
        [array removeObjectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:_cacheKey];
        [self reloadData];
    }
}

/** 清除所有记录 */
- (void)deleteHistory {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_isHidenHot ? _cacheKey : SEARCH_LIST];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_cacheKey];
    [self reloadData];
}

@end

