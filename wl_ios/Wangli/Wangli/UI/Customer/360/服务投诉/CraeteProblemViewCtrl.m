//
//  CraeteProblemViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/24.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CraeteProblemViewCtrl.h"

@interface CraeteProblemViewCtrl ()

@end

@implementation CraeteProblemViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [self.tableView reloadData];
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

- (ProblemMo *)model {
    if (!_model) _model = [[ProblemMo alloc] init];
    return _model;
}

@end
