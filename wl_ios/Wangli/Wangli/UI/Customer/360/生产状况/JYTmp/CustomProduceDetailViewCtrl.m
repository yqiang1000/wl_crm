//
//  CustomProduceDetailViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CustomProduceDetailViewCtrl.h"
#import "MenuTableView.h"
#import "MyTableView.h"
#import "ProductInfoMo.h"
#import "CreateProduceViewCtrl.h"
#import "RowMaterialMo.h"
#import "CreateMaterialViewCtrl.h"
#import "CompetitionMo.h"
#import "CreateCompetitiveViewCtrl.h"
#import "EquipmentMo.h"
#import "CreateFactoryEquipmentViewCtrl.h"
#import "PerformanceMo.h"
#import "CreateProductionDynamicsViewCtrl.h"
#import "RecruitmentMo.h"
#import "CreateFactoryRecruitmentViewCtrl.h"
#import "CreateProductionLicenseViewCtrl.h"
#import "UIButton+ShortCut.h"
#import "CreateBondInfoViewCtrl.h"
#import "CreatePurchaseLandViewCtrl.h"

@interface CustomProduceDetailViewCtrl () <MenuTableViewDelegate, MyTableViewDelegate>

@property (nonatomic, strong) MenuTableView *menuTableView;
@property (nonatomic, strong) MyTableView *myTableView;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, strong) NSMutableArray *rules;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSArray *arrMenu;

@property (nonatomic, strong) NSMutableArray *arrRightTitle;
@property (nonatomic, strong) NSMutableArray *arrShowData;
@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation CustomProduceDetailViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    _size = 20;
    self.title = @"生产及品质";
    self.view.backgroundColor = COLOR_B4;
    [self setUI];
    [self loadData];
    [self menuTableView:self.menuTableView didSelectItem:self.arrMenu[_currentTag][@"title"] indexPath:[NSIndexPath indexPathForRow:_currentTag inSection:0]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.updateSuccess) {
//        self.updateSuccess(nil);
//    }
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
    self.labTitle.text = item;
    _currentTag = indexPath.row;
    [Utils showHUDWithStatus:nil];
    NSArray *arrTitles = nil;
    if (indexPath.row == 0) { // 产品信息
        arrTitles = @[@"产品类型",@"工厂",@"成分含量",@"操作"];
        self.btnAdd.hidden = NO;
    } else if (indexPath.row == 1) { // 工厂设备
        arrTitles = @[@"设备类型",@"设备名称", @"品牌名称",@"设备数量", @"操作"];
        self.btnAdd.hidden = NO;
    } else if (indexPath.row == 2) { // 生产动态
        arrTitles = @[@"创建时间", @"设备类型", @"设备名称", @"开机率", @"开机数量", @"复制", @"操作"];
        self.btnAdd.hidden = NO;
    } else if (indexPath.row == 3) { // 原料信息
        arrTitles = @[@"原料类型", @"原料名称", @"年采购量",@"月使用量",@"下月采购量", @"操作"];
        self.btnAdd.hidden = NO;
    } else if (indexPath.row == 4) { // 竞品信息
        arrTitles = @[@"竞品企业", @"竞品品牌", @"吨/月平均", @"操作"];
        self.btnAdd.hidden = NO;
    } else if (indexPath.row == 11) { // 债券信息
        arrTitles = @[@"债券编号", @"债券名称", @"债劵发行日", @"债劵期限", @"操作"];
        self.btnAdd.hidden = YES;
    } else if (indexPath.row == 12) { // 购地信息
        arrTitles = @[@"CRM编号", @"受让人", @"宗地位置", @"签订日期", @"操作"];
        self.btnAdd.hidden = YES;
    }
    else { // 生产招工
        arrTitles = @[@"类型", @"标题", @"日期", @"操作"];
        self.btnAdd.hidden = NO;
    }
//    else if (indexPath.row == 6) { // 生产许可
//        arrTitles = @[@"标题", @"日期", @"操作"];
//    } else if (indexPath.row == 7) { // 采购招标
//        arrTitles = @[@"标题", @"日期", @"操作"];
//    } else if (indexPath.row == 8) { // 进出口信息
//        arrTitles = @[@"标题", @"日期", @"操作"];
//    } else if (indexPath.row == 9) { // 税务
//        arrTitles = @[@"标题", @"日期", @"操作"];
//    } else if (indexPath.row == 10) { // 检查
//        arrTitles = @[@"标题", @"日期", @"操作"];
//    }
    
    self.arrRightTitle = [[NSMutableArray alloc] initWithArray:arrTitles];
    self.myTableView.arrTopTitle = self.arrRightTitle;
    self.myTableView.arrData = nil;
    [self.myTableView initSetting];
    _page = 0;
    [self refreshList:_page];
}

- (void)loadData {
    NSMutableArray *arrTitles = [NSMutableArray new];
    for (NSDictionary *dic in self.arrMenu) {
        [arrTitles addObject:STRING(dic[@"title"])];
    }
    self.menuTableView.arrData = arrTitles;
}

#pragma mark - MyTableViewDelegate

- (void)myTableView:(MyTableView *)myTableView selectItemIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrSelectors = @[@"productTableViewSelectAction:",
                              @"equipmentTableViewSelectAction:",
                              @"performanceTableViewSelectAction:",
                              @"rowMaterialTableViewSelectAction:",
                              @"competionTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"recruitmentTableViewSelectAction:",
                              @"bondInfoTableViewSelectAction:",
                              @"purchaseTableViewSelectAction:"];
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
    NSArray *arrSelectors = @[@"getProductList:",
                              @"getEquipmentList:",
                              @"getPerformanceList:",
                              @"getRowMaterial:",
                              @"getCompetitionList:",
                              @"getRecruitmentList:",
                              @"getProductionLicenseList:",
                              @"getPruchaseList:",
                              @"getPortInfoList:",
                              @"getTaxRatingList:",
                              @"getSpotCheckList:",
                              @"getBondInfoList:",
                              @"getPurchaseLandList:",];
    if (_currentTag < arrSelectors.count) {
        SEL selector = NSSelectorFromString(arrSelectors[_currentTag]);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:[NSNumber numberWithInteger:page]];
        }
    }
}

- (void)getProductList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getProductPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        
        NSError *error = nil;
        NSMutableArray *tmpArr = [ProductInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrData removeAllObjects];
            _arrData = nil;
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
        for (ProductInfoMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.categoryValue),
                                          STRING(tmpMo.factory[@"name"]),
                                          STRING(tmpMo.ingredientValue),
                                          @"删除"]];
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

- (void)getFactoryEquipment:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getProductPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        
        NSError *error = nil;
        NSMutableArray *tmpArr = [ProductInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
        if (page == 0) {
            [_arrData removeAllObjects];
            _arrData = nil;
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
        for (ProductInfoMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.category[@"value"]),
                                          STRING(tmpMo.name),
                                          STRING(tmpMo.ingredient[@"value"]),
                                          STRING(tmpMo.yarn[@"value"]),
                                          STRING(tmpMo.dyeingTechnology[@"value"]),
                                          @"删除"]];
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

- (void)getRowMaterial:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getRowMaterialPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [RowMaterialMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        for (RowMaterialMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.typeValue),
                                          STRING(tmpMo.name),
                                          STRING(tmpMo.annualPurchaseVolume),
                                          STRING(tmpMo.monthlyUsage),
                                          STRING(tmpMo.purchaseVolumeNextMonth),
                                          @"删除"]];
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

- (void)getCompetitionList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getCompetitionPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [CompetitionMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        
        for (CompetitionMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.companyName),
                                          STRING(tmpMo.brand[@"value"]),
                                          STRING(tmpMo.salesVolume),
                                          @"删除"]];
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

- (void)getEquipmentList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    
    [[JYUserApi sharedInstance] getEquipmentPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [EquipmentMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
//        @[@"设备类型",@"设备名称",@"设备数量",@"操作"]
        for (EquipmentMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.type[@"value"]),
                                          STRING(tmpMo.name),
                                          STRING(tmpMo.brands),
                                          STRING(tmpMo.quantity),
                                          @"删除"]];
        }
        self.myTableView.arrTopTitle = self.arrRightTitle;
        self.myTableView.arrData = self.arrShowData;
        [self.myTableView initSetting];
        NSLog(@"%@", error);
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
    
    [[JYUserApi sharedInstance] getEquipmentTotalCountByMemberId:TheCustomer.customerMo.id success:^(id responseObject) {
        NSString *number = responseObject[@"sumEquipmentTotal"];
        [self.arrRightTitle replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"设备数量(%@)", number]];
        self.myTableView.arrTopTitle = self.arrRightTitle;
        [self.myTableView initSetting];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getPerformanceList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    
    [[JYUserApi sharedInstance] getPerformancePage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [PerformanceMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        for (PerformanceMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.recordDate),
                                          STRING(tmpMo.equipment[@"type"][@"value"]),
                                          STRING(tmpMo.equipment[@"name"]),
                                          [NSString stringWithFormat:@"%.0f%%", [tmpMo.bootedRatio floatValue]],
                                          STRING(tmpMo.bootedQuantity),
                                          @"复制",
                                          @"删除"]];
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

- (void)getRecruitmentList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getRecruitmentPage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getProductionLicenseList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getLicensePage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getPruchaseList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getPruchasePage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getPortInfoList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getPortInfoPage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getTaxRatingList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getTaxRatingPage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getSpotCheckList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getSpotCheckPage:page size:_size rules:self.rules success:^(id responseObject) {
        [self commonNetworkResponse:responseObject page:page];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)getBondInfoList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getBondPage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [BondInfoMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        
        for (BondInfoMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.bondNum),
                                          STRING(tmpMo.bondName),
                                          STRING(tmpMo.bondTimeLimit),
                                          STRING(tmpMo.publishTimeStr),
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

- (void)getPurchaseLandList:(NSNumber *)pageNum {
    NSInteger page = [pageNum integerValue];
    [[JYUserApi sharedInstance] getPurchasePage:page size:_size rules:self.rules success:^(id responseObject) {
        [Utils dismissHUD];
        [self.myTableView endRefresh];
        NSError *error = nil;
        NSMutableArray *tmpArr = [PurchaseLandMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
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
        //        @[@"设备类型", @"设备名称", @"开机率", @"开机数量", @"操作"]
        for (PurchaseLandMo *tmpMo in tmpArr) {
            [self.arrShowData addObject:@[STRING(tmpMo.purchaseLandNumber),
                                          STRING(tmpMo.assignee),
                                          STRING(tmpMo.location),
                                          STRING(tmpMo.signedDateStr),
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

- (void)commonNetworkResponse:(id)responseObject page:(NSInteger)page {
    [Utils dismissHUD];
    [self.myTableView endRefresh];
    NSError *error = nil;
    NSMutableArray *tmpArr = [RecruitmentMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
    if (page == 0) {
        [_arrShowData removeAllObjects];
        _arrShowData = nil;
        self.arrData = tmpArr;
    } else {
        if (tmpArr.count > 0) {
            _page = page;
            [self.arrData addObjectsFromArray:tmpArr];
        }
    }
//    @[@"类型", @"标题", @"日期", @"操作"]
    for (RecruitmentMo *tmpMo in tmpArr) {
        [self.arrShowData addObject:@[STRING(tmpMo.type[@"value"]),
                                      STRING(tmpMo.title),
                                      STRING(tmpMo.infoDate),
                                      @"删除"]];
    }
    self.myTableView.arrTopTitle = self.arrRightTitle;
    self.myTableView.arrData = self.arrShowData;
    NSLog(@"%@", error);
    [self.myTableView initSetting];
}

#pragma mark - event

- (void)btnAddClick:(UIButton *)sender {
    BaseViewCtrl *vc = nil;
    NSDictionary *item = self.arrMenu[_currentTag];
    Class class = NSClassFromString(item[@"ctrlName"]);
    NSLog(@"%@", item[@"ctrlName"]);
    NSLog(@"%@", item[@"ctrlTitle"]);
    if (_currentTag < 6) {
        vc = [[class alloc] init];
    } else {
        CreateProductionLicenseViewCtrl *tmpVc = [[CreateProductionLicenseViewCtrl alloc] init];
        tmpVc.type = (ProduceViewCtrlType)_currentTag-6;
        vc = tmpVc;
    }
    if (vc) {
        vc.title = item[@"ctrlTitle"];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(id obj) {
            weakself.page = 0;
            [weakself refreshList:weakself.page];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - selectEvent

- (void)productTableViewSelectAction:(NSIndexPath *)indexPath {
    ProductInfoMo *productMo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
        [self commonDeleteConfirm:^{
            [[JYUserApi sharedInstance] deleteProductById:productMo.id success:^(id responseObject) {
                [self deleteIndexPath:indexPath Result:nil];
            } failure:^(NSError *error) {
                [self deleteIndexPath:indexPath Result:error];
            }];
        } cancel:nil];
    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailProductById:productMo.id success:^(id responseObject) {
            [Utils dismissHUD];
            ProductInfoMo *tmpMo = [[ProductInfoMo alloc] initWithDictionary:responseObject error:nil];
            CreateProduceViewCtrl *vc = [[CreateProduceViewCtrl alloc] init];
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
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)rowMaterialTableViewSelectAction:(NSIndexPath *)indexPath {
    RowMaterialMo *mo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
        [self commonDeleteConfirm:^{
            [[JYUserApi sharedInstance] deleteRowMaterialById:mo.id success:^(id responseObject) {
                [self deleteIndexPath:indexPath Result:nil];
            } failure:^(NSError *error) {
                [self deleteIndexPath:indexPath Result:error];
            }];
        } cancel:nil];
    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailRowMaterialById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            RowMaterialMo *tmpMo = [[RowMaterialMo alloc] initWithDictionary:responseObject error:nil];
            CreateMaterialViewCtrl *vc = [[CreateMaterialViewCtrl alloc] init];
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
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)competionTableViewSelectAction:(NSIndexPath *)indexPath {
    CompetitionMo *mo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
        [self commonDeleteConfirm:^{
            [[JYUserApi sharedInstance] deleteCompetitionById:mo.id success:^(id responseObject) {
                [self deleteIndexPath:indexPath Result:nil];
            } failure:^(NSError *error) {
                [self deleteIndexPath:indexPath Result:error];
            }];
        } cancel:nil];
    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailCompetitionById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            CompetitionMo *tmpMo = [[CompetitionMo alloc] initWithDictionary:responseObject error:nil];
            CreateCompetitiveViewCtrl *vc = [[CreateCompetitiveViewCtrl alloc] init];
            vc.mo = tmpMo;
            NSDictionary *item = self.arrMenu[_currentTag];
            vc.title = item[@"title"];
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj){
                weakself.page = 0;
                [weakself refreshList:weakself.page];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)equipmentTableViewSelectAction:(NSIndexPath *)indexPath {
    CompetitionMo *mo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
        [self commonDeleteConfirm:^{
            [[JYUserApi sharedInstance] deleteEquipmentById:mo.id success:^(id responseObject) {
                [self deleteIndexPath:indexPath Result:nil];
            } failure:^(NSError *error) {
                [self deleteIndexPath:indexPath Result:error];
            }];
        } cancel:nil];
    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailEquipmentById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            EquipmentMo *tmpMo = [[EquipmentMo alloc] initWithDictionary:responseObject error:nil];
            CreateFactoryEquipmentViewCtrl *vc = [[CreateFactoryEquipmentViewCtrl alloc] init];
            vc.mo = tmpMo;
            NSDictionary *item = self.arrMenu[_currentTag];
            vc.title = item[@"title"];
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj){
                weakself.page = 0;
                [weakself refreshList:weakself.page];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)performanceTableViewSelectAction:(NSIndexPath *)indexPath {
    PerformanceMo *mo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
        [self commonDeleteConfirm:^{
            [[JYUserApi sharedInstance] deletePerformanceById:mo.id success:^(id responseObject) {
                [self deleteIndexPath:indexPath Result:nil];
            } failure:^(NSError *error) {
                [self deleteIndexPath:indexPath Result:error];
            }];
        } cancel:nil];
    }
    else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailPerformanceById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            PerformanceMo *tmpMo = [[PerformanceMo alloc] initWithDictionary:responseObject error:nil];
            CreateProductionDynamicsViewCtrl *vc = [[CreateProductionDynamicsViewCtrl alloc] init];
            vc.mo = tmpMo;
            NSDictionary *item = self.arrMenu[_currentTag];
            
            if (indexPath.row == 5) { // 复制
                vc.title = item[@"ctrlTitle"];
                vc.enableSave = YES;
            } else { // 详情修改
                vc.title = item[@"title"];
            }
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj){
                weakself.page = 0;
                [weakself refreshList:weakself.page];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)bondInfoTableViewSelectAction:(NSIndexPath *)indexPath {
    BondInfoMo *mo = self.arrData[indexPath.section];
//    if (indexPath.row == self.arrRightTitle.count - 1) {
//        [self commonDeleteConfirm:^{
//            [[JYUserApi sharedInstance] deletePerformanceById:mo.id success:^(id responseObject) {
//                [self deleteIndexPath:indexPath Result:nil];
//            } failure:^(NSError *error) {
//                [self deleteIndexPath:indexPath Result:error];
//            }];
//        } cancel:nil];
//    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailBondById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            BondInfoMo *tmpMo = [[BondInfoMo alloc] initWithDictionary:responseObject error:nil];
            CreateBondInfoViewCtrl *vc = [[CreateBondInfoViewCtrl alloc] init];
            vc.bondInfoMo = tmpMo;
            NSDictionary *item = self.arrMenu[_currentTag];
            vc.title = item[@"title"];
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj) {
                weakself.page = 0;
                [weakself refreshList:weakself.page];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
//    }
}

- (void)purchaseTableViewSelectAction:(NSIndexPath *)indexPath {
    PurchaseLandMo *mo = self.arrData[indexPath.section];
//    if (indexPath.row == self.arrRightTitle.count - 1) {
//        [self commonDeleteConfirm:^{
//            [[JYUserApi sharedInstance] deletePerformanceById:mo.id success:^(id responseObject) {
//                [self deleteIndexPath:indexPath Result:nil];
//            } failure:^(NSError *error) {
//                [self deleteIndexPath:indexPath Result:error];
//            }];
//        } cancel:nil];
//    } else {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailPurchaseById:mo.id success:^(id responseObject) {
            [Utils dismissHUD];
            PurchaseLandMo *tmpMo = [[PurchaseLandMo alloc] initWithDictionary:responseObject error:nil];
            CreatePurchaseLandViewCtrl *vc = [[CreatePurchaseLandViewCtrl alloc] init];
            vc.purchaseMo = tmpMo;
            NSDictionary *item = self.arrMenu[_currentTag];
            vc.title = item[@"title"];
            __weak typeof(self) weakself = self;
            vc.updateSuccess = ^(id obj){
                weakself.page = 0;
                [weakself refreshList:weakself.page];
            };
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
//    }
}

// 工厂招工 _currentTag = 5;往后，都调用这个
- (void)recruitmentTableViewSelectAction:(NSIndexPath *)indexPath {
    RecruitmentMo *mo = self.arrData[indexPath.section];
    if (indexPath.row == self.arrRightTitle.count - 1) {
//        kLicenseType        = 6,    // 生产许可
//        kPruchaseType,              // 采购招标
//        kPortInfoType,              // 进出口信息
//        kTaxRatingType,             // 税务评级
//        kSpotCheckType,             // 抽查检查
        if (_currentTag == 5) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deleteRecruitmentById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        } else if (_currentTag == 6) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deleteLicenseById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        } else if (_currentTag == 7) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deletePruchaseById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        } else if (_currentTag == 8) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deletePortInfoById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        } else if (_currentTag == 9) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deleteTaxRatingById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        } else if (_currentTag == 10) {
            [self commonDeleteConfirm:^{
                [[JYUserApi sharedInstance] deleteSpotCheckById:mo.id success:^(id responseObject) {
                    [self deleteIndexPath:indexPath Result:nil];
                } failure:^(NSError *error) {
                    [self deleteIndexPath:indexPath Result:error];
                }];
            } cancel:nil];
        }
    } else {
        // 工厂招工
        if (_currentTag == 5) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailRecruitmentById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                RecruitmentMo *tmpMo = [[RecruitmentMo alloc] initWithDictionary:responseObject error:nil];
                CreateFactoryRecruitmentViewCtrl *vc = [[CreateFactoryRecruitmentViewCtrl alloc] init];
                vc.mo = tmpMo;
                NSDictionary *item = self.arrMenu[_currentTag];
                vc.title = item[@"title"];
                __weak typeof(self) weakself = self;
                vc.updateSuccess = ^(id obj){
                    weakself.page = 0;
                    [weakself refreshList:weakself.page];
                };
                [self.navigationController pushViewController:vc animated:YES];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
                [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            }];
        }
        // 生产许可
        else if (_currentTag == 6) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailLicenseById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self commonPushToEditVC:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
        // 采购招标
        else if (_currentTag == 7) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailPruchaseById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self commonPushToEditVC:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
        // 进出口信息
        else if (_currentTag == 8) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailPortInfoById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self commonPushToEditVC:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
        // 税务评级
        else if (_currentTag == 9) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailTaxRatingById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self commonPushToEditVC:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
        // 检查抽查
        else if (_currentTag == 10) {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] detailSpotCheckById:mo.id success:^(id responseObject) {
                [Utils dismissHUD];
                [self commonPushToEditVC:responseObject];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
    }
}

- (void)commonPushToEditVC:(id)responseObject {
    RecruitmentMo *tmpMo = [[RecruitmentMo alloc] initWithDictionary:responseObject error:nil];
    CreateProductionLicenseViewCtrl *vc = [[CreateProductionLicenseViewCtrl alloc] init];
    vc.mo = tmpMo;
    vc.type = (ProduceViewCtrlType)_currentTag-6;
    NSDictionary *item = self.arrMenu[_currentTag];
    vc.title = item[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteIndexPath:(NSIndexPath *)indexPath Result:(NSError *)error {
    if (error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    } else {
        [Utils dismissHUD];
        [Utils showToastMessage:@"删除成功"];
        [self.arrData removeObjectAtIndex:indexPath.section];
        [self.arrShowData removeObjectAtIndex:indexPath.section];
        self.myTableView.arrData = self.arrShowData;
        [self.myTableView initSetting];
    }
}

// 通用的弹框方法
- (void)commonDeleteConfirm:(void (^)(void))confirm
                     cancel:(void (^)(void))cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"提示") message:GET_LANGUAGE_KEY(@"确定删删除该条信息？") preferredStyle:UIAlertControllerStyleAlert];
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

- (NSArray *)arrMenu {
    if (!_arrMenu) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"360ProduceList" ofType:@"plist"];
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
