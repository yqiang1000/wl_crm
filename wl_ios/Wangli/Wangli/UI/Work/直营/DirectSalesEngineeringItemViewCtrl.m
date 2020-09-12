//
//  DirectSalesEngineeringItemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/4/26.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "DirectSalesEngineeringItemViewCtrl.h"

@interface DirectSalesEngineeringItemViewCtrl ()

@end

@implementation DirectSalesEngineeringItemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访项目";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TEXT;
    rowMo0.leftContent = @"项目";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请输入";
    rowMo0.editAble = !self.afterDate;
    rowMo0.key = @"project";
    rowMo0.m_obj = STRING(self.itemMo.project);
    rowMo0.strValue = STRING(self.itemMo.project);
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo1.leftContent = @"是否拜访";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请选择";
    rowMo1.editAble = !self.afterDate;
    rowMo1.defaultValue = self.itemMo.visit;
    rowMo1.strValue = self.itemMo.visit ? @"YES" : @"NO";
    rowMo1.key = @"visit";
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"达成结果";
    rowMo2.inputType = K_LONG_TEXT;
    rowMo2.editAble = self.handleDate;
    rowMo2.rightContent = rowMo2.editAble?@"请输入":@"新建时候不允许填写";;
    rowMo2.nullAble = YES;
    rowMo2.m_obj = STRING(self.itemMo.achieveResults);
    rowMo2.strValue = STRING(self.itemMo.achieveResults);
    rowMo2.key = @"achieveResults";
    [self.arrData addObject:rowMo2];
}

#pragma mark - event

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [self updateParams:params attachementList:attachementList];
}

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    [Utils dismissHUD];
    for (CommonRowMo *rowMo in self.arrData) {
        if ([rowMo.key isEqualToString:@"project"]) {
            self.itemMo.project = STRING(rowMo.strValue);
        } else if ([rowMo.key isEqualToString:@"visit"]) {
            self.itemMo.visit = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"achieveResults"]) {
            self.itemMo.achieveResults = STRING(rowMo.strValue);
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (DirectSalesEngineeringItemMo *)itemMo {
    if (!_itemMo) _itemMo = [[DirectSalesEngineeringItemMo alloc] init];
    return _itemMo;
}

@end
