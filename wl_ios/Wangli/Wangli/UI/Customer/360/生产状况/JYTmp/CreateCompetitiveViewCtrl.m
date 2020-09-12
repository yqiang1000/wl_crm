//
//  CreateCompetitiveViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateCompetitiveViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "QiNiuUploadHelper.h"
#import "DicMo.h"
#import "WSDatePickerView.h"

@interface CreateCompetitiveViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;

@property (nonatomic, strong) NSArray *arrTypeName;
@property (nonatomic, strong) NSMutableArray *arrTypeValue;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;

@end

@implementation CreateCompetitiveViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    if (_mo) {
        for (QiniuFileMo *tmpMo in _mo.attachments) {
            [self.attachments addObject:STRING(tmpMo.thumbnail)];
            [self.attachUrls addObject:STRING(tmpMo.url)];
        }
        
        [self.arrTypeValue replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@", STRING(_mo.companyType[@"id"])]];
        [self.arrTypeValue replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@", STRING(_mo.brand[@"id"])]];
        
        if (_mo.brandPosition) {
            [self.arrTypeValue replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@", STRING(_mo.brandPosition[@"id"])]];
            [self.arrValues replaceObjectAtIndex:4 withObject:[Utils saveToValues:STRING(_mo.brandPosition[@"value"])]];
        }
        
        [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:STRING(_mo.recordDate)]];
        [self.arrValues replaceObjectAtIndex:1 withObject:[Utils saveToValues:STRING(_mo.companyType[@"value"])]];
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:STRING(_mo.brand[@"value"])]];
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:STRING(_mo.companyName)]];
        
        [self.arrValues replaceObjectAtIndex:5 withObject:[Utils saveToValues:STRING(_mo.spandexNumber)]];
        [self.arrValues replaceObjectAtIndex:6 withObject:[Utils saveToValues:STRING(_mo.name)]];
        [self.arrValues replaceObjectAtIndex:7 withObject:[Utils saveToValues:STRING(_mo.priceVolume)]];
        [self.arrValues replaceObjectAtIndex:8 withObject:[Utils saveToValues:STRING(_mo.spandexBackoffSpeed)]];
        [self.arrValues replaceObjectAtIndex:9 withObject:[Utils saveToValues:STRING(_mo.spandexBackoffTension)]];
        
        [self.arrValues replaceObjectAtIndex:10 withObject:[Utils saveToValues:STRING(_mo.drawRation)]];
        [self.arrValues replaceObjectAtIndex:11 withObject:[Utils saveToValues:STRING(_mo.productUsingCondition)]];
        [self.arrValues replaceObjectAtIndex:12 withObject:[Utils saveToValues:STRING(_mo.airPressure)]];
        [self.arrValues replaceObjectAtIndex:13 withObject:[Utils saveToValues:STRING(_mo.salesVolume)]];
        [self.arrValues replaceObjectAtIndex:14 withObject:[Utils saveToValues:STRING(_mo.payMethod)]];
        
        [self.arrValues replaceObjectAtIndex:15 withObject:[Utils saveToValues:STRING(_mo.accountPeriod)]];
        [self.arrValues replaceObjectAtIndex:16 withObject:[Utils saveToValues:STRING(_mo.features)]];
        [self.arrValues replaceObjectAtIndex:17 withObject:[Utils saveToValues:STRING(_mo.stockQuantity)]];
        [self.arrValues replaceObjectAtIndex:18 withObject:[Utils saveToValues:STRING(_mo.distributionChannelValue)]];
        [self.arrValues replaceObjectAtIndex:19 withObject:[Utils saveToValues:STRING(_mo.serviceMode)]];
        
        [self.arrValues replaceObjectAtIndex:20 withObject:[Utils saveToValues:STRING(_mo.remark)]];
    } else {
        NSString *recordDate = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
        [self.arrValues replaceObjectAtIndex:0 withObject:recordDate];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.arrLeft.count - 1 ? 120 : 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.count = 9;
            cell.attachments = _mo.attachments;
            [cell refreshView];
        }
        return cell;
    }
    static NSString *cellId = @"commonCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 竞企类型 || 竞企品牌 || 竞品定位
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:self.arrTypeName[indexPath.row] success:^(id responseObject) {
            [Utils dismissHUD];
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.value;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    else if (indexPath.row == self.arrLeft.count - 1) {
        // 附件
    }
    else {
        // 手动输入
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 100;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        if (indexPath.row == 7 || indexPath.row == 13) {
            vc.numberOnly = YES;
            vc.keyType = UIKeyboardTypeDecimalPad;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    NSString *str = self.arrTypeValue[indexPath.row];
    if (![str isEqualToString:@"demo"]) {
        vc.defaultValues = [[NSMutableArray alloc] initWithObjects:str, nil];
    }
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    
    DicMo *selectDicMo = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:selectDicMo.value])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.arrTypeValue replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@", selectDicMo.id]];
    
    if (indexPath.row == 2) {
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:selectDicMo.remark]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    
    for (int i = 0; i < 11; i++) {
        if (i == 1 || i == 2 || i == 3 || i == 5 || i == 6 || i == 7 || i == 10) {
            if ([self.arrValues[i] isEqualToString:@"demo"]) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", self.arrLeft[i]]];
                return;
            }
        }
    }
    
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createCompetitive:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createCompetitive:@[]];
    }
}

- (void)createCompetitive:(NSArray *)attachmentsList {
    [Utils showHUDWithStatus:nil];
//private Member member;//客户
//private Dict companyType;//竞品类型
//private String companyTypeValue;//竞争类型值
//private Dict industryRank;//行业地位
//private String industryRankValue;//行业地位
//private String companyName;//竞企名称
//private Dict brand;//竞品品牌
//private String brandValue;//竞品品牌
//private Dict brandPosition;//品牌定位
//private String brandPositionValue;//品牌定位
//private BigDecimal salesVolume;//吨/月平均
//private String features;//功能特色
//private String marketStrategy;//营销策略
//private String serviceMode;//服务方式
//private String background;//竞品背景
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    //客户
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    //@"记录时间",
    if ([Utils uploadToValues:self.arrValues[0]])
        [params setObject:STRING(self.arrValues[0]) forKey:@"recordDate"];
    //@"竞企类型",
    if ([Utils uploadToValues:self.arrTypeValue[1]])
        [params setObject:@{@"id":STRING(self.arrTypeValue[1])} forKey:@"companyType"];
    //@"竞企品牌",
    if ([Utils uploadToValues:self.arrTypeValue[2]])
        [params setObject:@{@"id":STRING(self.arrTypeValue[2])} forKey:@"brand"];
    //@"竞企名称",
    if ([Utils uploadToValues:self.arrValues[3]])
        [params setObject:STRING(self.arrValues[3]) forKey:@"companyName"];
    //@"品牌定位",
    if ([Utils uploadToValues:self.arrTypeValue[4]])
        [params setObject:@{@"id":STRING(self.arrTypeValue[4])} forKey:@"brandPosition"];
    
    //@"现供货氨纶批号",
    if ([Utils uploadToValues:self.arrValues[5]])
        [params setObject:STRING(self.arrValues[5]) forKey:@"spandexNumber"];
    //@"竞品名称",
    if ([Utils uploadToValues:self.arrValues[6]])
        [params setObject:STRING(self.arrValues[6]) forKey:@"name"];
    //@"价格(元/吨)",
    if ([Utils uploadToValues:self.arrValues[7]])
        [params setObject:STRING(self.arrValues[7]) forKey:@"priceVolume"];
    //@"氨纶退绕速度",
    if ([Utils uploadToValues:self.arrValues[8]])
        [params setObject:STRING(self.arrValues[8]) forKey:@"spandexBackoffSpeed"];
    //@"氨纶退绕张力",
    if ([Utils uploadToValues:self.arrValues[9]])
        [params setObject:STRING(self.arrValues[9]) forKey:@"spandexBackoffTension"];
    
    //@"牵伸比",
    if ([Utils uploadToValues:self.arrValues[10]])
        [params setObject:STRING(self.arrValues[10]) forKey:@"drawRation"];
    //@"产品使用情况",
    if ([Utils uploadToValues:self.arrValues[11]])
        [params setObject:STRING(self.arrValues[11]) forKey:@"productUsingCondition"];
    //@"气压(空包类)",
    if ([Utils uploadToValues:self.arrValues[12]])
        [params setObject:STRING(self.arrValues[12]) forKey:@"airPressure"];
    //@"吨/月平均",
    if ([Utils uploadToValues:self.arrValues[13]])
        [params setObject:STRING(self.arrValues[13]) forKey:@"salesVolume"];
    //@"付款方式",
    if ([Utils uploadToValues:self.arrValues[14]])
        [params setObject:STRING(self.arrValues[14]) forKey:@"payMethod"];
    
    //@"账期",
    if ([Utils uploadToValues:self.arrValues[15]])
        [params setObject:STRING(self.arrValues[15]) forKey:@"accountPeriod"];
    //@"功能特色",
    if ([Utils uploadToValues:self.arrValues[16]])
        [params setObject:STRING(self.arrValues[16]) forKey:@"features"];
    //@"客户库存(顿)",
    if ([Utils uploadToValues:self.arrValues[17]])
        [params setObject:STRING(self.arrValues[17]) forKey:@"stockQuantity"];
    //@"营销策略",
    if ([Utils uploadToValues:self.arrValues[18]])
        [params setObject:STRING(self.arrValues[18]) forKey:@"distributionChannelValue"];
    //@"服务方式",
    if ([Utils uploadToValues:self.arrValues[19]])
        [params setObject:STRING(self.arrValues[19]) forKey:@"serviceMode"];
    
    //@"备注",
    if ([Utils uploadToValues:self.arrValues[20]])
        [params setObject:STRING(self.arrValues[20]) forKey:@"remark"];
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateCompetitionId:_mo.id param:params attachments:[Utils filterUrls:attachmentsList arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            CompetitionMo *tmpMo = [[CompetitionMo alloc] initWithDictionary:responseObject error:nil];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createCompetitionParam:params attachments:attachmentsList success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"创建成功"];
            if (self.updateSuccess) {
                self.updateSuccess(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
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

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"记录时间",
                     @"竞企类型",
                     @"竞企品牌",
                     @"竞企名称",
                     @"品牌定位",
                     
                     @"现供货氨纶批号",
                     @"竞品名称",
                     @"价格(元/吨)",
                     @"氨纶退绕速度",
                     @"氨纶退绕张力",
                     
                     @"牵伸比",
                     @"产品使用情况",
                     @"气压(空包类)",
                     @"吨/月平均",
                     @"付款方式",
                     
                     @"账期",
                     @"功能特色",
                     @"客户库存(顿)",
                     @"营销策略",
                     @"服务方式",
                     
                     @"备注",
                     @"附件"];
    }
    return _arrLeft;
}
//.除了竞企类型，行业地位，竞企名称外，其他都未非必填(请注明必填字段)
- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"自动带出",
                      @"请选择(必填)",
                      @"请选择(必填)",
                      @"请输入(必填)",
                      @"请选择",
                      
                      @"请输入(必填)",
                      @"请输入(必填)",
                      @"请输入(必填)",
                      @"请输入",
                      @"请输入",
                      
                      @"请输入(必填)",
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      
                      @"请输入",
                      @"请输入",
                      @"请输入",
                      @"请选择",
                      @"请输入",
                      
                      @"请输入",
                      @"附件"];
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
    }
    return _arrValues;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) {
        _selectShowArr = [NSMutableArray new];
    }
    return _selectShowArr;
}

- (NSArray *)arrTypeName {
    if (!_arrTypeName) {
//         竞企类型:competing_companies_type
//         行业地位：industry_status
//         竞品品牌：competing_goods_brand
//         品牌定位：brand_position
        _arrTypeName = @[@"demo",
                         @"competing_companies_type",
                         @"competing_goods_brand",
                         @"demo",
                         @"brand_position",
                         
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         @"demo",
                         
                         @"demo",
                         @"demo"];
    }
    return _arrTypeName;
}

- (NSMutableArray *)arrTypeValue {
    if (!_arrTypeValue) {
        _arrTypeValue = [NSMutableArray new];
        for (int i = 0; i < self.arrTypeName.count; i++) {
            [_arrTypeValue addObject:@"demo"];
        }
    }
    return _arrTypeValue;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}

- (NSMutableArray *)attachUrls {
    if (!_attachUrls) {
        _attachUrls = [NSMutableArray new];
    }
    return _attachUrls;
}

@end
