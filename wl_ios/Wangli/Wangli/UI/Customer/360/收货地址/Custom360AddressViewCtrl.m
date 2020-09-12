//
//  Custom360AddressViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/13.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Custom360AddressViewCtrl.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UIButton+ShortCut.h"
#import "CreateAddressViewCtrl.h"
#import "AddressMo.h"
#import "AddressCell.h"
#import "MyCommonCell.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
#import "EmptyView.h"
#import "UIButton+ShortCut.h"

@interface Custom360AddressViewCtrl () <AddressCellDelegate, AMapSearchDelegate>
{
    EmptyView *_emptyView;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotation;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) NSMutableArray<AddressMo *> *arrData;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy) NSString *addressStr;
@property (nonatomic, strong) UIButton *btnDaohang;

@end

@implementation Custom360AddressViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.zoomLevel = 16;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self.view addSubview:self.btnAdd];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(44+KMagrinBottom));
    }];
    
    [self.view addSubview:self.btnDaohang];
    [self.btnDaohang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_mapView).offset(-4);
        make.right.equalTo(_mapView).offset(-9);
        make.width.height.equalTo(@50);
    }];
    
    self.selectIndex = -1;
    
    [self addTableView];
    self.tableView.backgroundColor = COLOR_B0;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mapView.mas_bottom);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.btnAdd.mas_top);
    }];
    
    [self getList];
    self.headerRefresh = YES;
}

- (void)getList {
    [[JYUserApi sharedInstance] getAddressPageByCustomerId:TheCustomer.customerMo.id success:^(id responseObject) {
        [self tableViewEndRefresh];
        self.arrData = [AddressMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:nil];
        self.selectIndex = -1;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self tableViewEndRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {[_emptyView removeFromSuperview];
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
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"addcell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.cellDelegate = self;
    }
    [cell laodDataWith:self.arrData[indexPath.row]];
    if (indexPath.row == _selectIndex) {
        [cell refreshView:YES];
    } else {
        [cell refreshView:NO];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerId = @"headerId";
    MyCommonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[MyCommonHeaderView alloc] initWithReuseIdentifier:headerId isHidenLine:NO];
        header.contentView.backgroundColor = COLOR_B0;
    }
    header.labLeft.text = [NSString stringWithFormat:@"发货地址列表(%ld)", self.arrData.count];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _selectIndex = indexPath.row;
    [cell refreshView:YES];
    
    
    //发起输入提示搜索
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    //关键字
    tipsRequest.keywords = cell.mo.address;
    //城市
    tipsRequest.city = cell.mo.cityName;
    _addressStr = cell.mo.address;
    //执行搜索
    [self.searchAPI AMapInputTipsSearch:tipsRequest];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell refreshView:NO];
}

#pragma mark - AddressCellDelegate

- (void)addressCellBtnEditClick:(AddressCell *)cell {
    CreateAddressViewCtrl *vc = [[CreateAddressViewCtrl alloc] init];
    vc.mo = cell.mo;
    __weak typeof(self) weakSelf = self;
    vc.addSuccessBlock = ^(AddressMo *mo) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressCellBtnDeleteClick:(AddressCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"确认删除该地址信息吗？") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] deleteAddressAddressId:cell.mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"删除成功"];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self.arrData removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - AMapSearchDelegate

/**
 * @brief 输入提示查询回调函数
 * @param request  发起的请求，具体字段参考 AMapInputTipsSearchRequest 。
 * @param response 响应结果，具体字段参考 AMapInputTipsSearchResponse 。
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (_pointAnnotation) {
        [_mapView removeAnnotation:_pointAnnotation];
    }
    if (response.count > 0) {
        AMapTip *tip = [response.tips firstObject];
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        _pointAnnotation.coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        _pointAnnotation.title = tip.name;
        _pointAnnotation.subtitle = tip.address;
        [_mapView addAnnotation:_pointAnnotation];
        _mapView.centerCoordinate = _pointAnnotation.coordinate;
    }
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    CreateAddressViewCtrl *vc = [[CreateAddressViewCtrl alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.addSuccessBlock = ^(AddressMo *mo) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnDaohangClick:(UIButton *)sender {
    if (_selectIndex == -1) {
        return;
    }
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    __weak typeof(self) weakself = self;
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) items:canOpen?@[@"苹果地图", @"高德地图"]:@[@"苹果地图"] defaultItem:-1 itemClick:^(NSInteger index) {
        if (index == 0) {
            [weakself openGaoDeIOSMap:_pointAnnotation.coordinate];
        } else if (index == 1) {
            [weakself openGaoDe:_pointAnnotation.coordinate];
        }
    } cancelClick:^(BottomView *obj) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [bottomView show];
}

- (void)tableViewHeaderRefreshAction {
    [self getList];
}

- (void)openGaoDe:(CLLocationCoordinate2D)coor2 {
    //起点
    CLLocationCoordinate2D coor = _mapView.userLocation.coordinate;
    
    //目的地的位置
//    CLLocationCoordinate2D coor2 =location2.coordinate;
    //    导航 URL：iosamap://navi?sourceApplication=%@&poiname=%@&lat=%lf&lon=%lf&dev=0&style=0",@"ABC"
    //    路径规划 URL：iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=A&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=0
    // -- 不能直接让用户进入导航，应该给用户更多的选择，所以先进行路径规划
    
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",coor.latitude,coor.longitude, coor2.latitude,coor2.longitude,_addressStr,@"1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) // -- 使用 canOpenURL:[NSURL URLWithString:@"iosamap://"] 判断不明白为什么为否。
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else{

    }
    
}

-(void)openGaoDeIOSMap:(CLLocationCoordinate2D)coor2 {
    //起点
    CLLocationCoordinate2D coor = _mapView.userLocation.coordinate;
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];
    currentLocation.name = @"我的位置";
    
    //目的地的位置
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor2 addressDictionary:nil]];
    
    toLocation.name = _addressStr;
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil, nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

#pragma mark - setter getter

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];
        [_btnAdd setBackgroundColor:COLOR_B4];
        _btnAdd.titleLabel.font = FONT_F16;
        [_btnAdd setTitleColor:COLOR_C1 forState:UIControlStateNormal];
        [_btnAdd setTitle:@"添加收货地址" forState:UIControlStateNormal];
        [_btnAdd setImage:[UIImage imageNamed:@"client_add"] forState:UIControlStateNormal];
        [_btnAdd imageLeftWithTitleFix:5];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [Utils getLineView];
        [_btnAdd addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_btnAdd);
            make.height.equalTo(@0.5);
        }];
    }
    return _btnAdd;
}

- (NSMutableArray<AddressMo *> *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

- (UIButton *)btnDaohang {
    if (!_btnDaohang) {
        _btnDaohang = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_btnDaohang setBackgroundImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateNormal];
        [_btnDaohang setImage:[UIImage imageNamed:@"导航"] forState:UIControlStateNormal];
        [_btnDaohang setTitle:@"导航" forState:UIControlStateNormal];
        _btnDaohang.titleLabel.font = FONT_F11;
        [_btnDaohang imageTopWithTitleFix:4];
        [_btnDaohang setTitleColor:COLOR_1893D5 forState:UIControlStateNormal];
        [_btnDaohang addTarget:self action:@selector(btnDaohangClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDaohang;
}

@end
