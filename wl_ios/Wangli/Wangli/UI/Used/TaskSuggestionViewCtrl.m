//
//  TaskSuggestionViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TaskSuggestionViewCtrl.h"
#import "MyCommonCell.h"
#import "AttachmentCell.h"
#import "WSDatePickerView.h"
#import "QiNiuUploadHelper.h"

@interface TaskSuggestionViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate, MyTextViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) UITextView *txtView;

@end

@implementation TaskSuggestionViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务反馈";
    [self config];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    [self.arrValues replaceObjectAtIndex:0 withObject:STRING(_mo.title)];
    NSString *str = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    [self.arrValues replaceObjectAtIndex:1 withObject:str];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 76;
        } else if (indexPath.row == 1) {
            return 120;
        } else if (indexPath.row == 2) {
            return 94;
        }
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section * 2 + indexPath.row;
    if (indexPath.section == 1 && indexPath.row == 0) {
        static NSString *identifier = @"myTextViewCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setLeftText:self.arrLeft[index]];
            cell.placeholder = self.arrRight[index];
            cell.cellDelegate = self;
        }
        cell.indexPath = indexPath;
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[index]];
        cell.txtView.text = showTextMo.text;
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        static NSString *identifier = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.count = 9;
        }
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        static NSString *identifier = @"myButtonCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.cellDelegate = self;
            [cell.btnSave setTitle:self.arrLeft[index] forState:UIControlStateNormal];
        }
        return cell;
    }
    
    static NSString *identifier = @"suggestCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.labLeft.textColor = COLOR_B1;
        cell.labLeft.font = FONT_F17;
        cell.labRight.font = FONT_F17;
    }
    [cell setLeftText:self.arrLeft[index]];
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[index] valueStr:self.arrValues[index]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = COLOR_B0;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 反馈时间
    if (indexPath.section == 0 && indexPath.row == 1) {
//        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
//        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
//        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[1]];
//        __weak typeof(self) weakself = self;
//        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
//            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
//            NSLog(@"选择的日期：%@",date);
//            [weakself.arrValues replaceObjectAtIndex:1 withObject:STRING([Utils saveToValues:date])];
//            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }];
//        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
//        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
//        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
//        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
//        [datepicker show];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_txtView resignFirstResponder];
}

#pragma mark - MyButtonCellDelegate

- (void)cell:(MyButtonCell *)cell btnClick:(UIButton *)sender {
    if (_txtView) {
        [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:_txtView.text]];
    }
    for (int i = 0; i < self.arrValues.count - 2; i++) {
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善内容"];
            return;
        }
    }
    AttachmentCell *attachmentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (attachmentCell.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:attachmentCell.collectionView.attachments success:^(id responseObject) {
            [self createTaskComment:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createTaskComment:@[]];
    }
}

- (void)createTaskComment:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:self.arrValues[2] forKey:@"content"];
    [param setObject:@(_mo.id) forKey:@"fkId"];
    [[JYUserApi sharedInstance] createTaskComment:param attachments:attachments success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - MyTextViewCellDelegate

- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    _txtView = textView;
}

- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:2 withObject:[Utils saveToValues:textView.text]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_B0;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        _arrLeft = @[@"任务名称",
                     @"发生时间",
                     
                     @"反馈内容",
                     @"附件",
                     @"提交"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"任务名称",
                      @"请选择",
                      
                      @"请输入反馈内容",
                      @"附件",
                      @"提交"];
    }
    return _arrRight;
}

- (NSMutableArray *)arrValues {
    if (!_arrValues) {
        _arrValues = [NSMutableArray new];
        for (int i = 0; i < self.arrLeft.count; i++) {
            [_arrValues addObject:@"demo"];
        }
    }
    return _arrValues;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}

@end
