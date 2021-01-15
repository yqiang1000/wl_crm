//
//  UnfulFilledProjectViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "UnfulFilledProjectViewCtrl.h"
#import "ProjectSelectViewCtrl.h"

@interface UnfulFilledProjectViewCtrl () <ProjectSelectViewCtrlDelegate>

@end

@implementation UnfulFilledProjectViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"未履行工程";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TEXT;
    rowMo0.leftContent = @"工程";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请输入";
    rowMo0.editAble = !self.afterDate;
    rowMo0.key = @"engineering";
    rowMo0.m_obj = STRING(self.itemMo.engineering);
    rowMo0.strValue = STRING(self.itemMo.engineering);
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo01 = [[CommonRowMo alloc] init];
    rowMo01.rowType = K_INPUT_TEXT;
    rowMo01.leftContent = @"未履行原因";
    rowMo01.inputType = K_LONG_TEXT;
    rowMo01.editAble = self.handleDate;
    rowMo01.rightContent = rowMo01.editAble?@"请输入":@"新建时候不允许填写原因";
    rowMo01.nullAble = YES;
    rowMo01.m_obj = STRING(self.itemMo.reasonsNoPerformance);
    rowMo01.strValue = STRING(self.itemMo.reasonsNoPerformance);
    rowMo01.key = @"reasonsNoPerformance";
    [self.arrData addObject:rowMo01];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo1.leftContent = @"合同是否有效";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请选择";
    rowMo1.editAble = self.handleDate;
    rowMo1.defaultValue = self.itemMo.effective;
    rowMo1.strValue = self.itemMo.effective ? @"YES" : @"NO";
    rowMo1.key = @"effective";
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.rowType = K_DATE_SELECT;
    rowMo12.leftContent = @"预计下单时间";
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.pattern = @"yyyy-MM-dd";
    rowMo12.editAble = self.handleDate;
    rowMo12.rightContent = rowMo12.editAble?@"请输入":@"新建时候不允许填写";;
    rowMo12.nullAble = YES;
    rowMo12.key = @"estimatedOrderTime";
    rowMo12.strValue = STRING(self.itemMo.estimatedOrderTime);
    [self.arrData addObject:rowMo12];
}


#pragma mark - ProjectSelectViewCtrlDelegate

- (void)projectSelectViewCtrl:(ProjectSelectViewCtrl *)projectSelectViewCtrl selectedModel:(MarketProjectMo *)model indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.arrData.count) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        rowMo.strValue = model.project;
        rowMo.value = model.project;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)projectSelectViewCtrlDismiss:(ProjectSelectViewCtrl *)projectSelectViewCtrl {
    
}


#pragma mark - event

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
    // 工程
    if ([toDo isEqualToString:@"engineering"] && [selName isEqualToString:@"DefaultInputCellBegin"]) {
        ProjectSelectViewCtrl *vc = [[ProjectSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.indexPath = indexPath;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [self updateParams:params attachementList:attachementList];
}

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [Utils dismissHUD];
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.key isEqualToString:@"engineering"]) {
            self.itemMo.engineering = STRING(rowMo.strValue);
        } else if ([rowMo.key isEqualToString:@"effective"]) {
            self.itemMo.effective = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"reasonsNoPerformance"]) {
            self.itemMo.reasonsNoPerformance = STRING(rowMo.strValue);
        } else if ([rowMo.key isEqualToString:@"estimatedOrderTime"]) {
            self.itemMo.estimatedOrderTime = STRING(rowMo.strValue);
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UnfulfilledProjectMo *)itemMo {
    if (!_itemMo) _itemMo = [[UnfulfilledProjectMo alloc] init];
    return _itemMo;
}


@end
