//
//  CreateConsulationViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateConsulationViewCtrl.h"

@interface CreateConsulationViewCtrl ()

@end

@implementation CreateConsulationViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)configRowMos {
    NSMutableArray *section0 = [NSMutableArray new];
    
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.leftContent = @"咨询标题";
    rowMo10.rightContent = @"请填写";
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.keyBoardType = K_DEFAULT;
    rowMo10.editAble = YES;
    [section0 addObject:rowMo10];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.leftContent = @"咨询内容";
    rowMo11.rightContent = @"请填写";
    rowMo11.rowType = K_INPUT_TEXT;
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.keyBoardType = K_DEFAULT;
    rowMo11.editAble = YES;
    [section0 addObject:rowMo11];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.leftContent = @"咨询人员";
    rowMo12.rightContent = @"请填写";
    rowMo12.rowType = K_INPUT_TEXT;
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.keyBoardType = K_DEFAULT;
    rowMo12.editAble = YES;
    [section0 addObject:rowMo12];
    
    CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
    rowMo13.leftContent = @"咨询日期";
    rowMo13.rightContent = @"请选择";
    rowMo13.rowType = K_DATE_SELECT;
    rowMo13.pattern = @"yyyy-MM-dd";
    rowMo13.editAble = YES;
    [section0 addObject:rowMo13];
    
    CommonRowMo *rowMo15 = [[CommonRowMo alloc] init];
    rowMo15.leftContent = @"附件";
    rowMo15.rightContent = @"请选择";
    rowMo15.rowType = K_FILE_INPUT;
    rowMo15.editAble = YES;
    [section0 addObject:rowMo15];
    
    self.arrData = section0;
    //        [self.tableView reloadData];
}

- (void)config {
    if (_model) {
        CommonRowMo *rowMo0 = self.arrData[0];
        rowMo0.strValue = _model.title;
        
        CommonRowMo *rowMo1 = self.arrData[1];
        rowMo1.strValue = _model.content;
        
        CommonRowMo *rowMo2 = self.arrData[2];
        rowMo2.strValue = _model.person;
        
        CommonRowMo *rowMo3 = self.arrData[3];
        rowMo3.strValue = _model.date;
//        [self.tableView reloadData];
    }
}


- (void)clickRightButton:(UIButton *)sender {
    
    CommonRowMo *rowMo0 = self.arrData[0];
    self.model.title = rowMo0.strValue;
    
    CommonRowMo *rowMo1 = self.arrData[1];
    self.model.content = rowMo1.strValue;
    
    CommonRowMo *rowMo2 = self.arrData[2];
    self.model.person = rowMo2.strValue;
    
    CommonRowMo *rowMo3 = self.arrData[3];
    self.model.date = rowMo3.strValue;
    
    if (self.updateSuccess) {
        self.updateSuccess(_model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    //    CommonRowMo *rowMo4 = self.arrData[4];
    //    self.model.attachments = rowMo4.value;
}

#pragma mark - lazy

- (ConsulationMo *)model {
    if (!_model) _model = [[ConsulationMo alloc] init];
    return _model;
}

@end
