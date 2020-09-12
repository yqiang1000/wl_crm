//
//  ContactTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ContactTableView.h"
#import "MyCommonCell.h"

@interface ContactTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *contactPeopleDict;
@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation ContactTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _showIndex = YES;
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
    return _showHeader ? self.keys.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showHeader) {
        NSString *key = self.keys[section];
        NSArray *arr = [self.contactPeopleDict objectForKey:key];
        return arr.count;
    } else {
        return self.arrData.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _hideAllHeader ? 0.0001 : 32;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"contactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    id mo = nil;
    if (_showHeader) {
        NSString *key = self.keys[indexPath.section];
        NSArray *arr = [self.contactPeopleDict objectForKey:key];
        mo = [arr objectAtIndex:indexPath.row];
        if (indexPath.row == arr.count - 1 ) {
            cell.lineView.hidden = YES;
        }
    } else {
        mo = self.arrData[indexPath.row];
        if (indexPath.row == self.arrData.count - 1 ) {
            cell.lineView.hidden = YES;
        }
    }
    [cell loadDataWith:mo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_contactDelegate && [_contactDelegate respondsToSelector:@selector(contactTableView:didSelectIndexPath:userMo:)]) {
        id mo = nil;
        if (_showHeader) {
            NSString *key = self.keys[indexPath.section];
            mo = [[self.contactPeopleDict objectForKey:key] objectAtIndex:indexPath.row];
        } else {
            mo = self.arrData[indexPath.row];
        }
        [_contactDelegate contactTableView:self didSelectIndexPath:indexPath userMo:mo];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_hideAllHeader) {
        return [UIView new];
    }
    static NSString *headerId = @"contentHeaderId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:YES];
    }
    if (_showHeader) {
        header.labLeft.text = self.keys[section];
    } else {
        header.labLeft.text = _headerText;
        header.labLeft.textColor = COLOR_B2;
    }
    return header;
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_showIndex) {
        NSMutableArray *array = [self.keys mutableCopy];
        return array;
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _canDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_showHeader) {
//        NSString *key = self.keys[indexPath.section];
//        NSMutableArray *arrUsers = [self.contactPeopleDict objectForKey:key];
//        JYUserMo *model = [arrUsers objectAtIndex:indexPath.row];
//        // 从数据源中删除
//        [self.arrData removeObject:model];
//        [arrUsers removeObject:model];
//        [self.contactPeopleDict setObject:arrUsers forKey:key];
//        // 从列表中删除
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else {
//        // 从数据源中删除
//        [self.arrData removeObjectAtIndex:indexPath.row];
//        // 从列表中删除
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
    if (_contactDelegate && [_contactDelegate respondsToSelector:@selector(contactTableView:didDeleteIndexPath:userMo:)]) {
        ContactMo *mo = nil;
        if (_showHeader) {
            NSString *key = self.keys[indexPath.section];
            mo = [[self.contactPeopleDict objectForKey:key] objectAtIndex:indexPath.row];
        } else {
            mo = self.arrData[indexPath.row];
        }
        [_contactDelegate contactTableView:self didDeleteIndexPath:indexPath userMo:mo];
    }
}

#pragma mark - public

- (void)setArrData:(NSMutableArray *)arrData {
    if (_arrData != arrData) {
        _arrData = arrData;
    }
    if (_showHeader) {
        [Utils getOrderAddressBook:^(NSDictionary *addressBookDict, NSArray *nameKeys) {
            self.contactPeopleDict = [[NSMutableDictionary alloc] initWithDictionary:addressBookDict];
            self.keys = [[NSMutableArray alloc] initWithArray:nameKeys];
            [self reloadData];
        } arrPerson:self.arrData];
    } else {
        [self reloadData];
    }
}

- (void)setShowIndex:(BOOL)showIndex {
    _showIndex = showIndex;
}

//- (void)refreshContactTableView {
//    [self reloadData];
//}

#pragma mark - setter getter

//- (NSMutableArray *)arrData {
//    if (!_arrData) {
//        _arrData = [NSMutableArray new];
//
//        NSArray *names =  @[@"张俊丽",
//                            @"李明乐"];
//        NSArray *mobiles =  @[@"13958044706",
//                              @"15858192818"];
//
//        for (int i = 0; i < names.count; i++) {
//            JYUserMo *mo1 = [[JYUserMo alloc] init];
//            mo1.nickName = names[i];
//            mo1.orgStr = mobiles[i];
//            mo1.partStr = @"采购部";
//            mo1.jobStr = @"采购员";
//            mo1.icon = @"http://img.jiuyisoft.com/cava1.jpg";
//            [_arrData addObject:mo1];
//        }
//    }
//    return _arrData;
//}

- (NSMutableDictionary *)contactPeopleDict {
    if (!_contactPeopleDict) {
        _contactPeopleDict = [NSMutableDictionary new];
    }
    return _contactPeopleDict;
}

- (NSMutableArray *)keys {
    if (!_keys) {
        _keys = [NSMutableArray new];
    }
    return _keys;
}

@end
