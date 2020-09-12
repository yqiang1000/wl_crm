//
//  CreateHelpListViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/3/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateHelpListViewCtrl.h"
#import "CommonRowMo.h"
#import "MyCommonCell.h"
#import "ListSelectViewCtrl.h"
#import "JYUserMoSelectViewCtrl.h"

@interface CreateHelpListViewCtrl () <UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, JYUserMoSelectViewCtrlDelegate, MyTextViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *currentTextView;

@end

@implementation CreateHelpListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增协作人";
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self config];
    [self setUI];
}

- (void)config {
    CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
    rowMo1.rowType = K_INPUT_OPERATOR;
    rowMo1.leftContent = @"协助人";
    rowMo1.rightContent = @"请选择";
    rowMo1.key = @"operators";
    rowMo1.editAble = YES;
    rowMo1.nullAble = YES;
    [self.arrData addObject:rowMo1];
    
    CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
    rowMo2.rowType = K_INPUT_SELECT;
    rowMo2.leftContent = @"协助角色";
    rowMo2.rightContent = @"请选择";
    rowMo2.key = @"assistRole";
    rowMo2.editAble = YES;
    rowMo2.nullAble = YES;
    [self.arrData addObject:rowMo2];
    
    CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
    rowMo3.rowType = K_INPUT_TEXT;
    rowMo3.inputType = K_LONG_TEXT;
    rowMo3.keyBoardType = K_DEFAULT;
    rowMo3.leftContent = @"参与原因";
    rowMo3.rightContent = @"请输入";
    rowMo3.key = @"assistReason";
    rowMo3.editAble = YES;
    rowMo3.nullAble = YES;
    [self.arrData addObject:rowMo3];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    return rowMo.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    if ([rowMo.inputType isEqualToString:K_LONG_TEXT]) {
        // 备注输入框
        static NSString *cellId = @"contentCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.cellDelegate = self;
        }
        [cell setLeftText:rowMo.leftContent];
        cell.placeholder = rowMo.rightContent;
        cell.txtView.keyboardType = rowMo.iosKeyBoardType;
        cell.txtView.editable = rowMo.editAble;
        cell.indexPath = indexPath;
        cell.txtView.text = [Utils showTextRightStr:@"" valueStr:rowMo.strValue].text;
        return cell;
    } else {
        static NSString *cellId = @"MyCommonCell";
        MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell setLeftText:rowMo.leftContent];
        ShowTextMo *showTextMo = [Utils showTextRightStr:rowMo.rightContent valueStr:rowMo.strValue];
        cell.labRight.textColor = rowMo.editAble ? showTextMo.color : COLOR_B2;
        cell.labRight.text = showTextMo.text;
        cell.labLeft.textColor = COLOR_B1;
        cell.lineView.hidden = (indexPath.row == self.arrData.count - 1) ? YES : NO;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentTextView) [_currentTextView resignFirstResponder];
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    // 协助人
    if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
        JYUserMoSelectViewCtrl *vc = [[JYUserMoSelectViewCtrl alloc] init];
        vc.VcDelegate = self;
        vc.isMultiple = YES;
        vc.indexPath = indexPath;
        NSMutableArray *arr = rowMo.m_objs;
        NSMutableArray *opers = [NSMutableArray new];
        for (JYUserMo *tmpMo in arr) {
            [opers addObject:[NSString stringWithFormat:@"%ld", (long)tmpMo.id]];
        }
        if (opers.count > 0) vc.defaultValues = opers;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
        NSArray *arr = @[@"AR", @"FR", @"SR", @"销售支持"];
        NSMutableArray *showArr = [NSMutableArray new];
        for (int i = 0; i < arr.count; i++) {
            NSString *str = arr[i];
            ListSelectMo *mo = [[ListSelectMo alloc] init];
            mo.moId = [NSString stringWithFormat:@"%d", i];
            mo.moText = str;
            mo.moKey = str;
            [showArr addObject:mo];
        }
        ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
        vc.indexPath = indexPath;
        vc.listVCdelegate = self;
        vc.arrData = showArr;
        vc.title = [NSString stringWithFormat:@"请选择%@", rowMo.leftContent];
        vc.byText = YES;
        if (rowMo.strValue.length > 0) vc.defaultValues = [[NSMutableArray alloc] initWithObjects:STRING(rowMo.strValue), nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([rowMo.key isEqualToString:@"assistReason"]) {
        
    }
}


#pragma mark - JYUserMoSelectViewCtrlDelegate

- (void)jyUserMoSelectViewCtrl:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl selectedData:(NSArray *)selectedData indexPath:(NSIndexPath *)indexPath {
    
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    NSString *str = @"";
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < selectedData.count; i++) {
        JYUserMo *tmpMo = selectedData[i];
        [arr addObject:tmpMo];
        str = [str stringByAppendingString:STRING(tmpMo.name)];
        if (i < selectedData.count-1) {
            str = [str stringByAppendingString:@","];
        }
    }
    if (arr.count > 0) {
        rowMo.m_objs = arr;
        rowMo.strValue = str;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)jyUserMoSelectViewCtrlDismiss:(JYUserMoSelectViewCtrl *)jyUserMoSelectViewCtrl {
    jyUserMoSelectViewCtrl = nil;
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = selectMo.moText;
    rowMo.m_obj = selectMo.moText;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyTextViewCellDelegate

// 输入回调
- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    _currentTextView = textView;
}

// 结束输入
- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    CommonRowMo *rowMo = self.arrData[indexPath.row];
    rowMo.strValue = [Utils saveToValues:textView.text];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_currentTextView) [_currentTextView resignFirstResponder];
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        if (rowMo.strValue.length == 0) {
            [Utils showToastMessage:[NSString stringWithFormat:@"请完善%@信息", rowMo.leftContent]];
            return;
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *rowMo = self.arrData[i];
        if ([rowMo.rowType isEqualToString:K_INPUT_OPERATOR]) {
            NSMutableArray *arr = rowMo.m_objs;
            NSMutableArray *opers = [NSMutableArray new];
            for (JYUserMo *tmpMo in arr) {
                [opers addObject:@{@"id":@(tmpMo.id)}];
            }
            if (opers.count > 0) [param setObject:opers forKey:rowMo.key];
        } else if ([rowMo.rowType isEqualToString:K_INPUT_SELECT]) {
            [param setObject:rowMo.strValue forKey:rowMo.key];
        } else if ([rowMo.rowType isEqualToString:K_INPUT_TEXT]) {
            [param setObject:rowMo.strValue forKey:rowMo.key];
        }
    }
    
    [param setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    
    [Utils showHUDWithStatus:nil];
    [[JYUserApi sharedInstance] createMemberAssistParam:param success:^(id responseObject) {
        [Utils dismissHUD];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_B0;
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return _tableView;
}

- (NSMutableArray *)arrData {
    if (!_arrData) _arrData = [NSMutableArray new];
    return _arrData;
}

@end
