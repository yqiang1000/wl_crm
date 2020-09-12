//
//  CustomTrackDetailViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CustomTrackDetailViewCtrl.h"
#import "MenuTableView.h"
#import "MyTableView.h"
#import "CreateContractViewCtrl.h"
#import "ContractMo.h"
#import "OrderMo.h"
#import "SapInvoiceMo.h"
#import "BillingMo.h"
#import "ReceiptMo.h"
#import "ForeignMo.h"
#import "MonthyStatementMo.h"
#import "TrackOrderViewCtrl.h"
#import "SapInvoiceViewCtrl.h"
#import "BillingViewCtrl.h"
#import "ReceiptTrackingViewCtrl.h"
#import "ForeignViewCtrl.h"
#import "MonthyStatementViewCtrl.h"
#import "CusInfoMo.h"
#import "WebDetailViewCtrl.h"
#import "UIButton+ShortCut.h"

@interface CustomTrackDetailViewCtrl () <MenuTableViewDelegate, MyTableViewDelegate>

@property (nonatomic, strong) MenuTableView *menuTableView;
@property (nonatomic, strong) MyTableView *myTableView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, strong) NSMutableArray *rules;
@property (nonatomic, strong) NSMutableArray *arrMenu;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@property (nonatomic, strong) NSMutableArray *arrRightTitle;
@property (nonatomic, strong) NSMutableArray *arrShowData;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation CustomTrackDetailViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _size = 20;
    self.title = @"交易跟踪";
    self.view.backgroundColor = COLOR_B4;
    [self setUI];
    [self loadData];
    [self menuTableView:self.menuTableView didSelectItem:self.arrMenu[_currentTag][@"title"] indexPath:[NSIndexPath indexPathForRow:_currentTag inSection:0]];
}

- (void)setUI {
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.labTitle];
    [self.view addSubview:self.btnAdd];
    
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(@80);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(17);
        make.centerX.equalTo(self.myTableView);
    }];
    
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(15);
        make.width.equalTo(@70);
        make.height.equalTo(@25);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(49);
        make.left.equalTo(self.menuTableView.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark - MenuTableViewDelegate

- (void)menuTableView:(MenuTableView *)menuTableView didSelectItem:(NSString *)item indexPath:(NSIndexPath *)indexPath {
    _currentTag = indexPath.row;
    self.labTitle.text = item;
    self.btnAdd.hidden = _currentTag == 0 ? NO : YES;
    [Utils showHUDWithStatus:nil];
    NSArray *arrTitles = nil;
    if (indexPath.row == 0) { // 合同
        arrTitles = @[@"合同类型", @"合同日期", @"合同编号", @"操作"];
    } else if (indexPath.row == 1) { // 订单
        arrTitles = @[@"订单编号", @"订单日期", @"订单状态", @"操作"];
    } else if (indexPath.row == 2) { // 发货
        arrTitles = @[@"订单号",@"发货单号", @"发货日期", @"操作"];
    } else if (indexPath.row == 3) { // 发票
        arrTitles = @[@"发票号",@"发票金额", @"金税号", @"状态", @"操作"];
    } else if (indexPath.row == 4) { // 电汇
        arrTitles = @[@"编号", @"类型", @"状态", @"操作"];
    } else if (indexPath.row == 5) { // 外贸
        arrTitles = @[@"跟踪单号",@"合同", @"状态", @"操作"];
    } else if (indexPath.row == 6) { // 对账单
        arrTitles = @[@"编号", @"月份", @"状态", @"操作"];
    }
    self.arrRightTitle = [[NSMutableArray alloc] initWithArray:arrTitles];
    self.myTableView.arrTopTitle = self.arrRightTitle;
    self.myTableView.arrData = nil;
    [self.myTableView initSetting];
    _page = 0;
    [self refreshList:_page];
}

- (void)loadData {
    NSMutableArray *arrTitles = [NSMutableArray new];
    for (NSDictionary *item in self.arrMenu) {
        [arrTitles addObject:STRING(item[@"title"])];
    }
    self.labTitle.text = arrTitles.firstObject;
    self.menuTableView.arrData = arrTitles;
}

#pragma mark - MyTableViewDelegate

- (void)myTableView:(MyTableView *)myTableView selectItemIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrSelectors = @[@"contractTableViewSelectAction:",
                              @"orderTableViewSelectAction:",
                              @"sapInvoiceTableViewSelectAction:",
                              @"billingTableViewSelectAction:",
                              @"receipTrackingTableViewSelectAction:",
                              @"foreignTableViewSelectAction:",
                              @"monthStatemenntTableViewSelectAction:"];
    if (_currentTag < arrSelectors.count) {
        SEL selector = NSSelectorFromString(arrSelectors[_currentTag]);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:indexPath];
        }
    }
}

- (void)myTableViewHeaderRefresh:(MyTableView *)myTableView {
    _page = 0;
    [self refreshList:_page];
}

- (void)myTableViewFooterRefresh:(MyTableView *)myTableView {
    [self refreshList:_page+1];
}

#pragma mark - listPage

- (void)refreshList:(NSInteger)page {
    NSArray *arrSelectors = @[@"getContractList:",
                              @"getOrderList:",
                              @"getSapInvoiceList:",
                              @"getSalesBillingList:",
                              @"getReceiptTrackingList:",
                              @"getForeignList:",
                              @"getMonthyStatementList:"];
    if (_currentTag < arrSelectors.count) {
        SEL selector = NSSelectorFromString(arrSelectors[_currentTag]);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:[NSNumber numberWithInteger:page]];
        }
    }
}

- (void)getContractList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getContractPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [ContractMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (ContractMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.type[@"value"]),
                                          STRING(tmpMo.infoDate),
                                          STRING(tmpMo.number),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getOrderList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getOrderPage:page size:_size rules:self.rules specialConditions:nil success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [OrderMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (OrderMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.crmNumber),
                                          STRING(tmpMo.createdDate),
                                          STRING(tmpMo.statusDesp),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getSapInvoiceList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getSapInvoicePage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [SapInvoiceMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (SapInvoiceMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.orderSapNumber),
                                          STRING(tmpMo.invoiceNumber),
                                          STRING(tmpMo.deliveryDate),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getSalesBillingList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getSalesBillingPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [BillingMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (BillingMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.number),
                                          STRING(tmpMo.price),
                                          STRING(tmpMo.goldenTaxNumber),
                                          STRING(tmpMo.statusDesp),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getReceiptTrackingList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getReceiptTrackingPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [ReceiptMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (ReceiptMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.number),
                                          STRING(tmpMo.ztext),
                                          STRING(tmpMo.ztype),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getForeignList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getForeignPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [ForeignMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (ForeignMo *tmpMo in tmpArr) {
            NSDictionary *dic = [tmpMo.salesContracts firstObject];
            [self.arrShowData addObject:@[STRING(tmpMo.number),
                                          STRING(dic[@"number"]),
                                          STRING([Utils foreignState:tmpMo.status]),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getMonthyStatementList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getMonthyStatementPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [MonthyStatementMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrShowData removeAllObjects];
            _arrShowData = nil;
            self.arrData = tmpArr;
        } else {
            if (tmpArr.count > 0) {
                _page = page;
                [self.arrData addObjectsFromArray:tmpArr];
            } else {
                [self.myTableView nomoreData];
            }
        }
        for (MonthyStatementMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.accountNumber),
                                          STRING(tmpMo.yearMonth),
                                          STRING(tmpMo.status[@"value"]),
                                          @"详情"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        NSLog(@"%@", error);
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    BaseViewCtrl *vc = nil;
    NSDictionary *item = self.arrMenu[_currentTag];
    Class class = NSClassFromString(item[@"ctrlName"]);
    vc = [[class alloc] init];
    vc.title = item[@"ctrlTitle"];
    __weak typeof(self) weakself = self;
    vc.updateSuccess = ^(id obj) {
        weakself.page = 0;
        [weakself refreshList:weakself.page];
    };
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickLeftButton:(UIButton *)sender {
    [super clickLeftButton:sender];
    [Utils dismissHUD];
}

#pragma mark - selectEvent

- (void)contractTableViewSelectAction:(NSIndexPath *)indexPath {
    ContractMo *mo = self.arrData[indexPath.section];
    [[JYUserApi sharedInstance] detailContractById:mo.id success:^(id responseObject) {
        NSError *error = nil;
        ContractMo *tmpMo = [[ContractMo alloc] initWithDictionary:responseObject error:&error];
        CreateContractViewCtrl *vc = [[CreateContractViewCtrl alloc] init];
        vc.mo = tmpMo;
        NSDictionary *item = self.arrMenu[_currentTag];
        vc.title = item[@"title"];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(id obj) {
            weakself.page = 0;
            [weakself refreshList:weakself.page];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)orderTableViewSelectAction:(NSIndexPath *)indexPath {
    OrderMo *mo = self.arrData[indexPath.section];
    NSString *urlStr = [NSString stringWithFormat:@"%@orderID=%ld&token=%@", ORDER_DETAIL_URL, mo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"订单详情";
    vc.hidesBottomBarWhenPushed = YES;
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)sapInvoiceTableViewSelectAction:(NSIndexPath *)indexPath {
    SapInvoiceMo *mo = self.arrData[indexPath.section];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] detailSapInvoiceById:mo.id success:^(id responseObject) {
        [self detailInfo:responseObject error:nil modelId:mo.id];
    } failure:^(NSError *error) {
        [self detailInfo:nil error:error modelId:mo.id];
    }];
}

- (void)billingTableViewSelectAction:(NSIndexPath *)indexPath {
    BillingMo *mo = self.arrData[indexPath.section];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] detailSalesBillingById:mo.id success:^(id responseObject) {
        [self detailInfo:responseObject error:nil modelId:mo.id];
    } failure:^(NSError *error) {
        [self detailInfo:nil error:error modelId:mo.id];
    }];
}

- (void)receipTrackingTableViewSelectAction:(NSIndexPath *)indexPath {
    ReceiptMo *mo = self.arrData[indexPath.section];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] detailReceiptTrackingById:mo.id success:^(id responseObject) {
        [self detailInfo:responseObject error:nil modelId:mo.id];
    } failure:^(NSError *error) {
        [self detailInfo:nil error:error modelId:mo.id];
    }];
}

- (void)foreignTableViewSelectAction:(NSIndexPath *)indexPath {
    ForeignMo *mo = self.arrData[indexPath.section];
    NSString *urlStr = [NSString stringWithFormat:@"%@id=%ld&token=%@", FOREIGN_URL, mo.id, [Utils token]];
    WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
    vc.urlStr = urlStr;
    vc.titleStr = @"外贸物流详情";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)monthStatemenntTableViewSelectAction:(NSIndexPath *)indexPath {
    MonthyStatementMo *mo = self.arrData[indexPath.section];
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] detailMonthyStatementById:mo.id success:^(id responseObject) {
        [self detailInfo:responseObject error:nil modelId:mo.id];
    } failure:^(NSError *error) {
        [self detailInfo:nil error:error modelId:mo.id];
    }];
}

- (void)detailInfo:(id)responseObject error:(NSError *)error modelId:(NSInteger)modelId {
    [Utils dismissHUD];
    if (error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    } else {
        [Utils dismissHUD];
        NSError *error = nil;
        NSMutableArray *arr = [CusInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        SapInvoiceViewCtrl *vc = [[SapInvoiceViewCtrl alloc] init];
        vc.mo = [arr firstObject];
        NSDictionary *item = self.arrMenu[_currentTag];
        vc.title = item[@"title"];
        vc.type = _currentTag;
        vc.modelId = modelId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 通用的弹框方法
- (void)commonDeleteConfirm:(void (^)(void))confirm
                     cancel:(void (^)(void))cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"提示") message:GET_LANGUAGE_KEY(@"确定删除该条信息？") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) cancel();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"继续") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Utils showHUDWithStatus:nil];
        if (confirm) confirm();
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - setter getter

- (MenuTableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[MenuTableView alloc] initWithFrame:CGRectZero];
        _menuTableView.menuDelegate = self;
        _menuTableView.selectIndex = _currentTag;
    }
    return _menuTableView;
}

- (MyTableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[MyTableView alloc] initWithFrame:CGRectZero];
        _myTableView.myViewDelegate = self;
        NSDictionary *dic = self.arrMenu[_currentTag];
        self.labTitle.text = dic[@"title"];
        [_myTableView initSetting];
    }
    return _myTableView;
}

- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.font = FONT_F15;
        _labTitle.textColor = COLOR_B1;
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _labTitle;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [[UIButton alloc] init];//70 25
        _btnAdd.titleLabel.font = FONT_F13;
        [_btnAdd setTitle:@"新纪录" forState:UIControlStateNormal];
        [_btnAdd setImage:[UIImage imageNamed:@"c_produce_new_record"] forState:UIControlStateNormal];
        [_btnAdd setTitleColor:COLOR_B1 forState:UIControlStateNormal];
        [_btnAdd setBackgroundColor:COLOR_B0];
        _btnAdd.layer.cornerRadius = 4;
        _btnAdd.clipsToBounds = YES;
        _btnAdd.layer.borderColor = COLOR_LINE.CGColor;
        _btnAdd.layer.borderWidth = 0.5;
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd imageLeftWithTitleFix:5];
    }
    return _btnAdd;
}

- (NSMutableArray *)arrMenu {
    if (!_arrMenu) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"360TrackList" ofType:@"plist"];
        NSArray *titleArr = [[NSArray alloc] initWithContentsOfFile:path];
        _arrMenu = [[NSMutableArray alloc] initWithArray:titleArr];
    }
    return _arrMenu;
}

- (NSMutableArray *)rules {
    if (!_rules) {
        _rules = [[NSMutableArray alloc] init];
        [_rules addObject:@{@"field":@"member.id",
                            @"option":@"EQ",
                            @"values":@[@(TheCustomer.customerMo.id)]}];
    }
    return _rules;
}


- (NSMutableArray *)arrData {
    if (!_arrData) {
        _arrData = [NSMutableArray new];
    }
    return _arrData;
}

- (NSMutableArray *)arrRightTitle {
    if (!_arrRightTitle) {
        _arrRightTitle = [NSMutableArray new];
    }
    return _arrRightTitle;
}

- (NSMutableArray *)arrShowData {
    if (!_arrShowData) {
        _arrShowData = [NSMutableArray new];
    }
    return _arrShowData;
}

@end
