//
//  JYSignViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/8/28.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import "JYSignViewCtrl.h"

@interface JYSignViewCtrl ()

@end

@implementation JYSignViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签署意向客户";
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
    rowMo1.leftContent = @"是否签署";
    rowMo1.inputType = K_SHORT_TEXT;
    rowMo1.rightContent = @"请选择";
    rowMo1.editAble = self.handleDate;
    rowMo1.defaultValue = self.itemMo.sign;
    rowMo1.strValue = self.itemMo.sign ? @"YES" : @"NO";
    rowMo1.key = @"sign";
    [self.arrData addObject:rowMo1];
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
        } else if ([rowMo.key isEqualToString:@"sign"]) {
            self.itemMo.sign = rowMo.defaultValue;
        }
    }
    if (self.updateSuccess) self.updateSuccess(self.itemMo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (JYSignIntentionMo *)itemMo {
    if (!_itemMo) _itemMo = [[JYSignIntentionMo alloc] init];
    return _itemMo;
}
@end
