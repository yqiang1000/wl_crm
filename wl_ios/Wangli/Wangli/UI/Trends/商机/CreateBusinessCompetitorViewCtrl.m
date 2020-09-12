
//
//  CreateBusinessCompetitorViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateBusinessCompetitorViewCtrl.h"

@interface CreateBusinessCompetitorViewCtrl ()

@end

@implementation CreateBusinessCompetitorViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加竞争对手";
    self.rightBtn.hidden = YES;
}

- (void)config {
    CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
    rowMo0.rowType = K_INPUT_TITLE;
    rowMo0.leftContent = @"添加竞争对手";
    [self.arrData addObject:rowMo0];
    
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_MEMBER;
    rowMo1.leftContent = @"竞争对手";
    rowMo1.rightContent = @"请选择";
    rowMo1.key = @"member";
    rowMo1.editAble = YES;
    rowMo1.member = self.model.member;
    rowMo1.strValue = self.model.member.orgName;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_TEXT;
    rowMo2.inputType = K_SHORT_TEXT;
    rowMo2.keyBoardType = K_DEFAULT;
    rowMo2.leftContent = @"对手负责人";
    rowMo2.rightContent = @"请输入";
    rowMo2.key = @"principalName";
    rowMo2.editAble = YES;
    rowMo2.value = STRING(self.model.principalName);
    rowMo2.strValue = STRING(self.model.principalName);
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_TEXT;
    rowMo3.inputType = K_SHORT_TEXT;
    rowMo3.keyBoardType = K_INTEGER;
    rowMo3.leftContent = @"电话";
    rowMo3.rightContent = @"请输入";
    rowMo3.editAble = YES;
    rowMo3.key = @"principalTel";
    rowMo3.value = STRING(self.model.principalTel);
    rowMo3.strValue = STRING(self.model.principalTel);
    [self.arrData addObject:rowMo3];
    
    CommonRowMo *rowMo21 = [[CommonRowMo alloc] init];
    rowMo21.rowType = K_INPUT_TEXT;
    rowMo21.inputType = K_SHORT_TEXT;
    rowMo21.keyBoardType = K_DEFAULT;
    rowMo21.leftContent = @"负责人部门";
    rowMo21.rightContent = @"请输入";
    rowMo21.key = @"principalDepartment";
    rowMo21.editAble = YES;
    rowMo21.value = STRING(self.model.principalDepartment);
    rowMo21.strValue = STRING(self.model.principalDepartment);
    [self.arrData addObject:rowMo21];
    
    CommonRowMo *rowMo22 = [[CommonRowMo alloc] init];
    rowMo22.rowType = K_INPUT_TEXT;
    rowMo22.inputType = K_SHORT_TEXT;
    rowMo22.keyBoardType = K_DEFAULT;
    rowMo22.leftContent = @"负责人职位";
    rowMo22.rightContent = @"请输入";
    rowMo22.key = @"principalJob";
    rowMo22.editAble = YES;
    rowMo22.value = STRING(self.model.principalJob);
    rowMo22.strValue = STRING(self.model.principalJob);
    [self.arrData addObject:rowMo22];
    
    CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
    rowMo4.rowType = K_INPUT_TEXT;
    rowMo4.leftContent = @"备注";
    rowMo4.rightContent = @"请输入备注";
    rowMo4.inputType = K_LONG_TEXT;
    rowMo4.key = @"content";
    rowMo4.editAble = YES;
    rowMo4.nullAble = YES;
    rowMo4.value = STRING(self.model.content);
    rowMo4.strValue = STRING(self.model.content);
    [self.arrData addObject:rowMo4];
    
    CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
    rowMo5.rowType = K_INPUT_BUTTON;
    rowMo5.leftContent = @"完成";
    [self.arrData addObject:rowMo5];
    
    [self.tableView reloadData];
}

#pragma mark - event

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    NSLog(@"%@", params);
    
    for (CommonRowMo *tmpMo in self.arrData) {
        if (![tmpMo.rowType isEqualToString:K_INPUT_TITLE] && ![tmpMo.rowType isEqualToString:K_INPUT_BUTTON]) {
            if (!tmpMo.nullAble && ![Utils uploadToValues:tmpMo.strValue]) {
                [Utils showToastMessage:[NSString stringWithFormat:@"请输入%@", tmpMo.leftContent]];
                return;
            }
        }
    }
    CommonRowMo *mo1 = self.arrData[1];
    if (mo1.member) {
        self.model.member = mo1.member;
        self.model.abbreviation = mo1.member.abbreviation;
    }
    
    CommonRowMo *mo2 = self.arrData[2];
    self.model.principalName = mo2.strValue;
    CommonRowMo *mo3 = self.arrData[3];
    self.model.principalTel = mo3.strValue;
    CommonRowMo *mo4 = self.arrData[4];
    self.model.principalDepartment = mo4.strValue;
    CommonRowMo *mo5 = self.arrData[5];
    self.model.principalJob = mo5.strValue;
    CommonRowMo *mo6 = self.arrData[6];
    self.model.content = mo6.strValue;
    
    if (self.updateSuccess) {
        self.updateSuccess(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (TrendsCompetitorMo *)model {
    if (!_model) _model = [[TrendsCompetitorMo alloc] init];
    return _model;
}

@end
