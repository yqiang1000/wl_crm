//
//  ListSelectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "ListSelectViewCtrl.h"
#import "EmptyView.h"
#import "SearchTopView.h"

#pragma mark - ListSelectMo

@interface ListSelectMo ()

@end

@implementation ListSelectMo

@end

#pragma mark - ListSelectViewCtrl

@interface ListSelectViewCtrl () <UITableViewDelegate, UITableViewDataSource, SearchTopViewDelegate>
{
    EmptyView *_emptyView;
}

@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectTag;
@property (nonatomic, strong) NSMutableArray *arrIndexPaths;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;

@end

@implementation ListSelectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn setImage:nil forState:UIControlStateNormal];
    self.leftBtn.hidden = NO;
    if (_isMultiple) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.rightBtn.hidden = NO;
    } else {
        self.rightBtn.hidden = YES;
    }
    
    for (NSString *item in self.defaultValues) {
        for (int i = 0; i < self.arrData.count; i++) {
            ListSelectMo *tmpMo = self.arrData[i];
            if (_byText) {
                if ([tmpMo.moKey isEqualToString:item]) {
                    [self.arrIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            } else {
                if ([tmpMo.moId isEqualToString:item]) {
                    [self.arrIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
    }
    // 可搜索
    if (_enableSearch) {
        self.arrSearchResult = [self.arrData mutableCopy];
    }
    
    if (self.arrIndexPaths.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)setUI {
    if (_enableSearch) {
        [self.view addSubview:self.searchView];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.naviView).offset(15);
            make.bottom.equalTo(self.naviView).offset(-8+44);
            make.height.equalTo(@28);
            make.right.equalTo(self.naviView).offset(-15);
        }];
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(_enableSearch?44:0);
        make.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    if (self.arrData.count == 0) {
        _emptyView = [[EmptyView alloc] init];
        [self.tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.tableView);
            make.width.height.equalTo(self.tableView);
        }];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_enableSearch) {
        return self.arrSearchResult.count;
    }
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _enableSearch?0.001:8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 内容
    static NSString *identifier = @"listCell";
    ListselectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListselectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (_enableSearch) {
        ListSelectMo *tmpMo = self.arrSearchResult[indexPath.row];
        cell.labText.text = tmpMo.moText;
        cell.imgArrow.hidden = YES; //![self.arrIndexPaths containsObject:indexPath];
        cell.lineView.hidden = YES; //(indexPath.row == self.arrData.count - 1) ? YES : NO;
        return cell;
    } else {
        ListSelectMo *tmpMo = self.arrData[indexPath.row];
        cell.labText.text = tmpMo.moText;
        cell.imgArrow.hidden = ![self.arrIndexPaths containsObject:indexPath];
        cell.lineView.hidden = (indexPath.row == self.arrData.count - 1) ? YES : NO;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_enableSearch) {
        // 单选
        [self.arrIndexPaths removeAllObjects];
        
        ListSelectMo *tmpMo = self.arrSearchResult[indexPath.row];
        
        if ([self.arrData containsObject:tmpMo]) {
            NSInteger index = [self.arrData indexOfObject:tmpMo];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.arrIndexPaths addObject:newIndexPath];
            if (_listVCdelegate && [_listVCdelegate respondsToSelector:@selector(listSelectViewCtrl:selectIndex:indexPath:selectMo:)]) {
                [_listVCdelegate listSelectViewCtrl:self selectIndex:newIndexPath.row indexPath:self.indexPath selectMo:tmpMo];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if (_isMultiple) {
        // 多选
        if ([self.arrIndexPaths containsObject:indexPath]) {
            [self.arrIndexPaths removeObject:indexPath];
        } else {
            [self.arrIndexPaths addObject:indexPath];
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // 单选
        [self.arrIndexPaths removeAllObjects];
        [self.arrIndexPaths addObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (_listVCdelegate && [_listVCdelegate respondsToSelector:@selector(listSelectViewCtrl:selectIndex:indexPath:selectMo:)]) {
            [_listVCdelegate listSelectViewCtrl:self selectIndex:indexPath.row indexPath:self.indexPath selectMo:self.arrData[indexPath.row]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SearchTopViewDelegate

- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField {
//    [self.searchView.searchTxtField resignFirstResponder];
//    [self pushToSearchVC:NO];
}

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.arrSearchResult = [self.arrData mutableCopy];
    } else {
        [self.arrSearchResult removeAllObjects];
        for (ListSelectMo *tmpMo in self.arrData) {
            if ([tmpMo.moText containsString:textField.text]) {
                [self.arrSearchResult addObject:tmpMo];
            }
        }
    }
    [self.tableView reloadData];
    [textField resignFirstResponder];
}

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView {
//    [self.searchView.searchTxtField resignFirstResponder];
//    [self pushToSearchVC:YES];
}

- (void)clickRightButton:(UIButton *)sender {
    if (self.arrIndexPaths.count == 0) {
        [Utils showToastMessage:@"请至少选择一项"];
        return;
    }
    
    if (_listVCdelegate && [_listVCdelegate respondsToSelector:@selector(listSelectViewCtrl:selectIndexPaths:indexPath:)]) {
        [_listVCdelegate listSelectViewCtrl:self selectIndexPaths:self.arrIndexPaths indexPath:self.indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLeftButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SearchTopView *)searchView {
    if (!_searchView) {
        _searchView = [[SearchTopView alloc] initWithAudio:NO];
        _searchView.delegate = self;
        _searchView.searchTxtField.placeholder = @"请输入国家/地区信息";
    }
    return _searchView;
}


- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)arrIndexPaths {
    if (!_arrIndexPaths) {
        _arrIndexPaths = [NSMutableArray new];
    }
    return _arrIndexPaths;
}

- (NSMutableArray *)arrSearchResult {
    if (!_arrSearchResult) {
        _arrSearchResult = [NSMutableArray new];
    }
    return _arrSearchResult;
}


@end

#pragma mark - ListselectCell

@interface ListselectCell ()

@end

@implementation ListselectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_B4;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.labText];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.imgArrow];
    
    [self.labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.imgArrow.mas_left).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labText);
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    [self.imgArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.labText);
        make.width.equalTo(@10);
    }];
}

#pragma mark - setter and getter

- (UILabel *)labText {
    if (!_labText) {
        _labText = [[UILabel alloc] init];
        _labText.textColor = COLOR_B1;
        _labText.font = FONT_F16;
    }
    return _labText;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [Utils getLineView];
    }
    return _lineView;
}

- (UIImageView *)imgArrow {
    if (!_imgArrow) {
        _imgArrow = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"元素单选"]];
    }
    return _imgArrow;
}

@end
