//
//  MarketEngineerItemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/4/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "MarketEngineerItemViewCtrl.h"

@interface MarketEngineerItemViewCtrl ()

@end

@implementation MarketEngineerItemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"走访客户";
    self.forbidEdit = self.afterDate;
    self.rightBtn.hidden = self.afterDate;
}

- (void)configRowMos {
    [self.arrData removeAllObjects];
    self.arrData = nil;
    
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_MEMBER;
    rowMo0.leftContent = @"客户";
    rowMo0.inputType = K_SHORT_TEXT;
    rowMo0.rightContent = @"请输入";
    rowMo0.editAble = !self.afterDate;
    rowMo0.key = @"member";
    NSError *error = nil;
    CustomerMo *memberMo = [[CustomerMo alloc] initWithDictionary:self.itemMo.member error:&error];
    rowMo0.m_obj = memberMo;
    rowMo0.strValue = self.itemMo.member[@"orgName"];
    rowMo0.member = memberMo;
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
    rowMo2.leftContent = @"处理事项";
    rowMo2.inputType = K_LONG_TEXT;
    rowMo2.rightContent = @"请输入";
    rowMo2.editAble = !self.afterDate;
    rowMo2.nullAble = YES;
    rowMo2.m_obj = STRING(self.itemMo.handlingMatters);
    rowMo2.strValue = STRING(self.itemMo.handlingMatters);
    rowMo2.key = @"handlingMatters";
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
        if ([rowMo.key isEqualToString:@"member"]) {
            CustomerMo *member = (CustomerMo *)rowMo.member;
            NSMutableDictionary *memberDic = [NSMutableDictionary new];
            [memberDic setObject:@(member.id) forKey:@"id"];
            [memberDic setObject:STRING(member.orgName) forKey:@"orgName"];
            self.itemMo.member = memberDic;
        } else if ([rowMo.key isEqualToString:@"visit"]) {
            self.itemMo.visit = rowMo.defaultValue;
        } else if ([rowMo.key isEqualToString:@"handlingMatters"]) {
            self.itemMo.handlingMatters = STRING(rowMo.strValue);
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (MarketEngineeringItemMo *)itemMo {
    if (!_itemMo) _itemMo = [[MarketEngineeringItemMo alloc] init];
    return _itemMo;
}

@end
