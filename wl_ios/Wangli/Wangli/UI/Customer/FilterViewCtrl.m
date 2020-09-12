
//
//  FilterViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "FilterViewCtrl.h"
#import "FilterCollectionView.h"
#import "FilterSecondView.h"
#import "MemberChooseMo.h"

static CGFloat leftPadding = 25;

@interface FilterViewCtrl () <FilterCollectionViewDelegate, FilterSecondViewDelegate>

@property (nonatomic, strong) UIButton *btnReset;
@property (nonatomic, strong) UIButton *btnOK;
@property (nonatomic, strong) FilterCollectionView *collectionView;

@property (nonatomic, strong) FilterSecondView *secondView;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSIndexPath *headerIndexPath;

@end

@implementation FilterViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviView.hidden = YES;
    self.view.backgroundColor = COLOR_CLEAR;
    [self setUI];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
            self.view.backgroundColor = COLOR_MASK;
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(leftPadding);
                make.width.equalTo(@(SCREEN_WIDTH-leftPadding));
                make.top.equalTo(self.view);
                make.height.equalTo(self.view);
            }];
            [self.view layoutIfNeeded];
        }];
    });
    
    [self loadData];
}

- (void)setUI {
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.btnReset];
    [self.baseView addSubview:self.btnOK];
    [self.baseView addSubview:self.collectionView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_C1;
    [self.baseView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView);
        make.left.right.equalTo(self.baseView);
        make.height.equalTo(@(STATUS_BAR_HEIGHT));
    }];
    
    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCREEN_WIDTH);
        make.width.equalTo(@(SCREEN_WIDTH-leftPadding));
        make.top.bottom.equalTo(self.view);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.btnReset.mas_top);
    }];
    
    [self.btnReset mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-KMagrinBottom);
        make.width.equalTo(self.baseView).multipliedBy(0.5);
        make.height.equalTo(@44);
    }];
    
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView).offset(-KMagrinBottom);
        make.left.equalTo(self.btnReset.mas_right);
        make.height.equalTo(@44);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    point = [_baseView.layer convertPoint:point fromLayer:self.view.layer];
    CGPoint point1 = [_secondView.layer convertPoint:point fromLayer:self.view.layer];
    if ([_baseView.layer containsPoint:point]) {
        return;
    }
    [self dismissView];
}

- (void)dismissView {
    if (_filterViewCtrlDelegate && [_filterViewCtrlDelegate respondsToSelector:@selector(filterViewCtrlDismiss:)] ) {
        [UIView animateWithDuration:0.35 animations:^{
            self.view.backgroundColor = COLOR_CLEAR;
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(SCREEN_WIDTH);
                make.width.equalTo(@(SCREEN_WIDTH-leftPadding));
                make.top.bottom.equalTo(self.view);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_filterViewCtrlDelegate filterViewCtrlDismiss:self];
        }];
    }
}

#pragma mark - FilterCollectionViewDelegate

- (void)filterCollectionView:(FilterCollectionView *)filterCollectionView didSelectIndexPath:(NSIndexPath *)indexPath {
    
    MemberChooseMo *chooseMo = self.arrData[indexPath.section];
    __block BOOL isAdd = YES;
    [self.indexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *inIndexPath = obj;
        
        if (chooseMo.multiSelect) {
            // 多选，如果遍历到了一模一样的，则移除，结束循环；如果没遇到，则设置标志为YES，继续下一个
            if (inIndexPath.section == indexPath.section && inIndexPath.row == indexPath.row) {
                [self.indexPathArr removeObject:obj];
                isAdd = NO;
                *stop = YES;
            } else {
                isAdd = YES;
            }
        } else {
            // 单选 如果遍历到section一样的，则先移除再说，在判断row是否一致，如果一致，则确认是要删除的，结束循环；如果不一致，则设置标志为YES，需要添加，继续下一个
            if (inIndexPath.section == indexPath.section) {
                [self.indexPathArr removeObject:obj];
                if (inIndexPath.item == indexPath.item) {
                    isAdd = NO;
                    *stop = YES;
                } else {
                    isAdd = YES;
                }
            } else {
                isAdd = YES;
            }
        }
    }];
    
    if (isAdd) {
        [self.indexPathArr addObject:indexPath];
    } else {
        [self.indexPathArr removeObject:indexPath];
    }
    self.collectionView.indexPathArr = self.indexPathArr;
    [self.collectionView reloadData];
}

- (void)filterCollectionView:(FilterCollectionView *)filterCollectionView didSelectHeaderView:(FilterHeaderView *)headerView indexPath:(NSIndexPath *)indexPath defaultIndex:(NSInteger)defaultIndex {
    [_secondView removeFromSuperview];
    _secondView = nil;
    [self.baseView addSubview:self.secondView];
    _headerIndexPath = indexPath;
    MemberChooseMo *mo = self.arrData[indexPath.section];
    NSMutableArray *arrTmp = [NSMutableArray new];
    for (int i = 0; i < mo.chooseBeans.count; i++) {
        [arrTmp addObject:STRING(((NSDictionary *)mo.chooseBeans[i])[@"key"])];
    }
    [self.secondView updata:arrTmp selectTag:0 title:mo.name defaultIndex:defaultIndex];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.secondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.baseView);
            make.width.equalTo(@(SCREEN_WIDTH-leftPadding));
            make.top.bottom.equalTo(self.baseView);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - FilterSecondViewDelegate

- (void)filterSecondViewCancel:(FilterSecondView *)filterSecondView {
    [UIView animateWithDuration:0.35 animations:^{
        [self.secondView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_right);
            make.width.equalTo(@(SCREEN_WIDTH-leftPadding));
            make.top.bottom.equalTo(self.baseView);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_secondView removeFromSuperview];
        _secondView = nil;
    }];
}

- (void)filterSecondView:(FilterSecondView *)filterSecondView select:(NSInteger)index {
    MemberChooseMo *mo = self.arrData[_headerIndexPath.section];
    mo.selectTag = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:_headerIndexPath.section];
    
    __block BOOL isAdd = YES;
    [self.indexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *inIndexPath = obj;
        if (inIndexPath.section == indexPath.section) {
            [self.indexPathArr removeObject:obj];
            if (inIndexPath.item == indexPath.item) {
                isAdd = NO;
            } else {
                isAdd = YES;
            }
        } else {
            isAdd = YES;
        }
    }];
    
    if (isAdd) {
        [self.indexPathArr addObject:indexPath];
    } else {
        [self.indexPathArr removeObject:indexPath];
    }
    self.collectionView.indexPathArr = self.indexPathArr;
    for (int i = 0; i < self.indexPathArr.count; i++) {
        [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:((NSIndexPath *)self.indexPathArr[i]).section]];
    }
}

- (void)loadData {
    self.collectionView.arrData = self.arrData;
}

- (void)btnClick:(UIButton *)sender {
    
    if (sender.tag == 101) {
        // 重置
        [_indexPathArr removeAllObjects];
        self.collectionView.indexPathArr = nil;
        [self.collectionView reloadData];
        if (_filterViewCtrlDelegate && [_filterViewCtrlDelegate respondsToSelector:@selector(filterView:btnReSetClick:)]) {
            [_filterViewCtrlDelegate filterView:self btnReSetClick:self.indexPathArr];
        }
    } else {
        // 确定
        if (_filterViewCtrlDelegate && [_filterViewCtrlDelegate respondsToSelector:@selector(filterView:btnOKClick:)]) {
            [_filterViewCtrlDelegate filterView:self btnOKClick:self.indexPathArr];
            [self dismissView];
        }
    }
    
//    BaseViewCtrl *vc = [[BaseViewCtrl alloc] init];
//    vc.view.backgroundColor = COLOR_C1;
//    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - public

- (void)refreshCollectionView {
    self.collectionView.indexPathArr = self.indexPathArr;
    [self.collectionView reloadData];
}

#pragma mark - setter getter

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-leftPadding, SCREEN_HEIGHT)];
        _baseView.backgroundColor = COLOR_B4;
    }
    return _baseView;
}

- (UIButton *)btnReset {
    if (!_btnReset) {
        _btnReset = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, (SCREEN_WIDTH-leftPadding)/2.0, 44)];
        [_btnReset addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnReset.tag = 101;
        _btnReset.backgroundColor = COLOR_B4;
        [_btnReset setTitle:@"重置" forState:UIControlStateNormal];
        [_btnReset setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        _btnReset.layer.borderWidth = 0.5;
        _btnReset.layer.borderColor = COLOR_LINE.CGColor;
    }
    return _btnReset;
}

- (UIButton *)btnOK {
    if (!_btnOK) {
        _btnOK = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-leftPadding), SCREEN_HEIGHT-44, (SCREEN_WIDTH-leftPadding)/2.0, 44)];
        [_btnOK addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnOK.backgroundColor = COLOR_C1;
        _btnOK.tag = 102;
        [_btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [_btnOK setTitleColor:COLOR_B4 forState:UIControlStateNormal];
        _btnOK.layer.borderWidth = 0.5;
        _btnOK.layer.borderColor = COLOR_C1.CGColor;
    }
    return _btnOK;
}

- (FilterCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[FilterCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = COLOR_B4;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 20, 15);
        _collectionView.filterCollectionViewDelegate = self;
        _collectionView.sourceType = 1;
        _collectionView.indexPathArr = self.indexPathArr;
    }
    return _collectionView;
}

- (FilterSecondView *)secondView {
    if (!_secondView) {
        _secondView = [[FilterSecondView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_baseView.frame), 0, CGRectGetWidth(_baseView.frame), CGRectGetHeight(_baseView.frame))];
        _secondView.delegate = self;
    }
    return _secondView;
}

- (NSMutableArray *)indexPathArr {
    if (!_indexPathArr) {
        _indexPathArr = [NSMutableArray new];
    }
    return _indexPathArr;
}

- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [[NSMutableArray alloc] initWithCapacity:8];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_CHOOSE];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0; i < arr.count; i++) {
            MemberChooseMo *mo = [[MemberChooseMo alloc] initWithDictionary:arr[i] error:nil];
            [_arrData addObject:mo];
        }
    }
    return _arrData;
}

@end
