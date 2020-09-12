//
//  CreateMaterialViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateMaterialViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "QiNiuUploadHelper.h"

@interface CreateMaterialViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;

@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;
@property (nonatomic, strong) DicMo *selectDicMo;

@end

@implementation CreateMaterialViewCtrl

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
//        self.selectDicMo = [[DicMo alloc] initWithDictionary:_mo.type error:nil];
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.typeValue)];
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.name)];
        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.annualPurchaseVolume)];
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.monthlyUsage)];
        [self.arrValues replaceObjectAtIndex:4 withObject:STRING(_mo.purchaseVolumeNextMonth)];
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
//    if (indexPath.row == 0) {
//        [Utils showHUDWithStatus:nil];
//        [[JYUserApi sharedInstance] getConfigDicByName:@"raw_material_type" success:^(id responseObject) {
//            [Utils dismissHUD];
//            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
//            [_selectShowArr removeAllObjects];
//            _selectShowArr = nil;
//            for (DicMo *tmpMo in self.selectArr) {
//                ListSelectMo *mo = [[ListSelectMo alloc] init];
//                mo.moId = tmpMo.id;
//                mo.moText = tmpMo.value;
//                [self.selectShowArr addObject:mo];
//            }
//            [self pushToSelectVC:indexPath];
//        } failure:^(NSError *error) {
//            [Utils dismissHUD];
//        }];
//    }
    if (indexPath.row == self.arrLeft.count - 1) {
    }
    else {
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 100;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        if (indexPath.row != 1 && indexPath.row != 0) {
            vc.keyType = UIKeyboardTypeDecimalPad;
            vc.numberOnly = YES;
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
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:_arrValues[indexPath.row], nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {

    self.selectDicMo = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:self.selectDicMo.value])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    for (int i = 0; i < 2; i++) {
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@", self.arrLeft[i]]];
            return;
        }
    }
    
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        [Utils showHUDWithStatus:nil];
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createRowMaterial:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createRowMaterial:@[]];
    }
}

- (void)createRowMaterial:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setObject:@{@"id":_selectDicMo.id} forKey:@"type"];
    // 客户
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    // 原料类型
    [params setObject:STRING(self.arrValues[0]) forKey:@"typeValue"];
    // 原料名称
    [params setObject:STRING(self.arrValues[1]) forKey:@"name"];
    // 年采购
    if ([Utils uploadToValues:self.arrValues[2]])
    [params setObject:STRING(self.arrValues[2]) forKey:@"annualPurchaseVolume"];
    // 月使用
    if ([Utils uploadToValues:self.arrValues[3]])
    [params setObject:STRING(self.arrValues[3]) forKey:@"monthlyUsage"];
    // 下月采购
    if ([Utils uploadToValues:self.arrValues[4]])
    [params setObject:STRING(self.arrValues[4]) forKey:@"purchaseVolumeNextMonth"];
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateRowMaterialId:_mo.id param:params attachments:[Utils filterUrls:attachments arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            RowMaterialMo *tmpMo = [[RowMaterialMo alloc] initWithDictionary:responseObject error:nil];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createRowMaterialParam:params attachments:attachments success:^(id responseObject) {
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
        _arrLeft = @[@"氨纶搭配 原料类型",
                     @"原料名称",
                     @"年采购量(吨)",
                     @"月使用量(吨)",
                     @"下月采购量(吨)",
                     
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请输入(必填)",
                      @"请输入(必填)",
                      @"请输入",
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
