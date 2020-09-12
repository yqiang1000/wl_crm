//
//  JYVisitViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/8/28.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYVisitViewCtrl.h"

@interface JYVisitViewCtrl ()

@end

@implementation JYVisitViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访意向客户";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TEXT;
    rowMo0.leftContent = @"客户";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请输入";
    rowMo0.editAble = !self.afterDate;
    rowMo0.key = @"member";
    rowMo0.m_obj = STRING(self.itemMo.member);
    rowMo0.strValue = STRING(self.itemMo.member);
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_TOGGLEBUTTON;
    rowMo1.leftContent = @"是否拜访";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请选择";
    rowMo1.editAble = self.handleDate;
    rowMo1.defaultValue = self.itemMo.visit;
    rowMo1.strValue = self.itemMo.visit ? @"YES" : @"NO";
    rowMo1.key = @"visit";
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.leftContent = @"现经营品牌";
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.rightContent = @"请输入";
    rowMo2.editAble = !self.afterDate;
    rowMo2.nullAble = YES;
    rowMo2.m_obj = STRING(self.itemMo.managementBrand);
    rowMo2.strValue = STRING(self.itemMo.managementBrand);
    rowMo2.key = @"managementBrand";
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_TEXT;
    rowMo3.leftContent = @"年销量";
    rowMo3.inputType = K_SHORT_TEXT;
    rowMo3.rightContent = @"请输入";
    rowMo3.editAble = !self.afterDate;
    rowMo3.nullAble = YES;
    rowMo3.value = [Utils getPriceFrom:self.itemMo.annualSalesVolume];
    rowMo3.strValue = [Utils getPriceFrom:self.itemMo.annualSalesVolume];
    rowMo3.key = @"annualSalesVolume";
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_TEXT;
    rowMo4.leftContent = @"合作意向";
    rowMo4.inputType = K_SHORT_TEXT;
    rowMo4.rightContent = @"请输入";
    rowMo4.editAble = self.handleDate;
    rowMo4.nullAble = YES;
    rowMo4.m_obj = STRING(self.itemMo.cooperationIntention);
    rowMo4.strValue = STRING(self.itemMo.cooperationIntention);
    rowMo4.key = @"cooperationIntention";
    [self.arrData addObject:rowMo4];
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
        if ([rowMo.key isEqualToString:@"member"]) {
            self.itemMo.member = STRING(rowMo.strValue);
        } else if ([rowMo.key isEqualToString:@"visit"]) {
            self.itemMo.visit = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"managementBrand"]) {
            self.itemMo.managementBrand = STRING(rowMo.strValue);
        } else if ([rowMo.key isEqualToString:@"annualSalesVolume"]) {
            self.itemMo.annualSalesVolume = [rowMo.strValue floatValue];
        } else if ([rowMo.key isEqualToString:@"cooperationIntention"]) {
            self.itemMo.cooperationIntention = STRING(rowMo.strValue);
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (JYVisitIntentionMo *)itemMo {
    if (!_itemMo) _itemMo = [[JYVisitIntentionMo alloc] init];
    return _itemMo;
}

@end
