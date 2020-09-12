//
//  CreateProblemDescViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateProblemDescViewCtrl.h"

@interface CreateProblemDescViewCtrl ()

@end

@implementation CreateProblemDescViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configRowMos {
    NSMutableArray *section0 = [NSMutableArray new];
    CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
    rowMo10.leftContent = @"客诉类型";
    rowMo10.rightContent = @"请填写";
    rowMo10.rowType = K_INPUT_TEXT;
    rowMo10.inputType = K_SHORT_TEXT;
    rowMo10.keyBoardType = K_DEFAULT;
    rowMo10.editAble = YES;
    [section0 addObject:rowMo10];
    
    CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
    rowMo11.leftContent = @"具体类型";
    rowMo11.rightContent = @"请填写";
    rowMo11.rowType = K_INPUT_TEXT;
    rowMo11.inputType = K_SHORT_TEXT;
    rowMo11.keyBoardType = K_DEFAULT;
    rowMo11.editAble = YES;
    [section0 addObject:rowMo11];
    
    CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
    rowMo12.leftContent = @"投诉数量";
    rowMo12.rightContent = @"请填写";
    rowMo12.rowType = K_INPUT_TEXT;
    rowMo12.inputType = K_SHORT_TEXT;
    rowMo12.keyBoardType = K_INTEGER;
    rowMo12.editAble = YES;
    [section0 addObject:rowMo12];
    
    CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
    rowMo13.leftContent = @"描述";
    rowMo13.rightContent = @"请选择";
    rowMo13.rowType = K_INPUT_TEXT;
    rowMo13.inputType = K_SHORT_TEXT;
    rowMo13.keyBoardType = K_DEFAULT;
    rowMo13.editAble = YES;
    [section0 addObject:rowMo13];
    self.arrData = section0;
}

- (void)config {
    if (_model) {
        CommonRowMo *rowMo0 = self.arrData[0];
        rowMo0.strValue = _model.consulationType;
        
        CommonRowMo *rowMo1 = self.arrData[1];
        rowMo1.strValue = _model.detailType;
        
        CommonRowMo *rowMo2 = self.arrData[2];
        rowMo2.strValue = _model.count;
        
        CommonRowMo *rowMo3 = self.arrData[3];
        rowMo3.strValue = _model.desc;
        [self.tableView reloadData];
    }
}


- (void)clickRightButton:(UIButton *)sender {
    [self hidenKeyboard];
    CommonRowMo *rowMo0 = self.arrData[0];
    self.model.consulationType = rowMo0.strValue;
    
    CommonRowMo *rowMo1 = self.arrData[1];
    self.model.detailType = rowMo1.strValue;
    
    CommonRowMo *rowMo2 = self.arrData[2];
    self.model.count = rowMo2.strValue;
    
    CommonRowMo *rowMo3 = self.arrData[3];
    self.model.desc = rowMo3.strValue;
    
    if (self.updateSuccess) {
        self.updateSuccess(_model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    //    CommonRowMo *rowMo4 = self.arrData[4];
    //    self.model.attachments = rowMo4.value;
}

#pragma mark - lazy

- (ProblemDescMo *)model {
    if (!_model) _model = [[ProblemDescMo alloc] init];
    return _model;
}

@end
