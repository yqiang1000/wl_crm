//
//  CreateFactoryRecruitmentViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/5/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CreateFactoryRecruitmentViewCtrl.h"
#import "ListSelectViewCtrl.h"
#import "EditTextViewCtrl.h"
#import "AttachmentCell.h"
#import "MyCommonCell.h"
#import "WSDatePickerView.h"
#import "QiNiuUploadHelper.h"

@interface CreateFactoryRecruitmentViewCtrl ()
<UITableViewDelegate, UITableViewDataSource, ListSelectViewCtrlDelegate, EditTextViewCtrlDelegate, MyTextViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) UITextView *currentTextView;

@property (nonatomic, strong) DicMo *dicMo;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *attachUrls;

@end

@implementation CreateFactoryRecruitmentViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self setUI];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
    if (_mo) {
        for (QiniuFileMo *tmpMo in _mo.attachments) {
            [self.attachments addObject:STRING(tmpMo.thumbnail)];
            [self.attachUrls addObject:STRING(tmpMo.url)];
        }
        self.dicMo = [[DicMo alloc] initWithDictionary:_mo.type error:nil];
        [self.arrValues replaceObjectAtIndex:0 withObject:STRING(self.dicMo.value)];
        [self.arrValues replaceObjectAtIndex:1 withObject:STRING(_mo.title)];
        [self.arrValues replaceObjectAtIndex:2 withObject:STRING(_mo.infoDate)];
        [self.arrValues replaceObjectAtIndex:3 withObject:STRING(_mo.content)];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrLeft.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 76;
    }
    return indexPath.row == self.arrLeft.count - 1 ? 120 : 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrLeft.count - 1) {
        static NSString *cellId = @"attachmentCell";
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.count = 9;
            cell.attachments = _mo.attachments;
            [cell refreshView];
        }
        return cell;
    } else if (indexPath.row == self.arrLeft.count - 2) {
        // 输入
        static NSString *identifier = @"myTextViewCell";
        MyTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MyTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.placeholder = self.arrRight[indexPath.row];
            cell.cellDelegate = self;
            [cell setLeftText:self.arrLeft[indexPath.row]];
        }
        cell.txtView.text = [Utils showTextRightStr:@"" valueStr:self.arrValues[indexPath.row]].text;
        cell.indexPath = indexPath;
        return cell;
    }
    static NSString *cellId = @"commonCell";
    MyCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setLeftText:self.arrLeft[indexPath.row]];
    ShowTextMo *showTextMo = [Utils showTextRightStr:self.arrRight[indexPath.row] valueStr: self.arrValues[indexPath.row]];
    cell.labRight.textColor = showTextMo.color;
    cell.labRight.text = showTextMo.text;
    cell.labLeft.textColor = COLOR_B1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 类型选择
    if (indexPath.row == 0) {
        [self.currentTextView resignFirstResponder];
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getConfigDicByName:@"hire_type" success:^(id responseObject) {
            [Utils dismissHUD];
            self.selectArr = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
            [_selectShowArr removeAllObjects];
            _selectShowArr = nil;
            for (DicMo *tmpMo in self.selectArr) {
                ListSelectMo *mo = [[ListSelectMo alloc] init];
                mo.moId = tmpMo.id;
                mo.moText = tmpMo.value;
                [self.selectShowArr addObject:mo];
            }
            [self pushToSelectVC:indexPath];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    // 标题
    else if (indexPath.row == 1) {
        [self.currentTextView resignFirstResponder];
        EditTextViewCtrl *vc = [[EditTextViewCtrl alloc] init];
        vc.title = self.arrLeft[indexPath.row];
        vc.max_length = 20;
        vc.placeholder = [NSString stringWithFormat:@"请输入%@", self.arrLeft[indexPath.row]];
        vc.currentText = [self.arrValues[indexPath.row] isEqualToString:@"demo"] ? nil : self.arrValues[indexPath.row];
        vc.indexPath = indexPath;
        vc.editVCDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 日期
    else if (indexPath.row == 2) {
        [self.currentTextView resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
            [minDateFormater setDateFormat:@"yyyy-MM-DD"];
            NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[indexPath.row]];
            __weak typeof(self) weakself = self;
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
                
                NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
                NSLog(@"选择的日期：%@",date);
                [weakself.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:date])];
                [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
            datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
            datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
            datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
            [datepicker show];
        });
    }
    else {
    }
}

- (void)pushToSelectVC:(NSIndexPath *)indexPath {
    ListSelectViewCtrl *vc = [[ListSelectViewCtrl alloc] init];
    vc.indexPath = indexPath;
    vc.listVCdelegate = self;
    vc.arrData = self.selectShowArr;
    vc.title = self.arrLeft[indexPath.row];
    vc.defaultValues = [[NSMutableArray alloc] initWithObjects:self.arrValues[indexPath.row], nil];
    vc.byText = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.currentTextView resignFirstResponder];
}

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    self.dicMo = self.selectArr[index];
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:self.dicMo.value])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - EditTextViewCtrlDelegate

- (void)editVC:(EditTextViewCtrl *)editVC content:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:STRING([Utils saveToValues:content])];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MyTextViewCellDelegate

// 输入回调
- (void)cell:(MyTextViewCell *)cell textViewDidBeginEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    self.currentTextView = textView;
}

// 结束输入
- (void)cell:(MyTextViewCell *)cell textViewDidEndEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    [self.arrValues replaceObjectAtIndex:indexPath.row withObject:[Utils saveToValues:textView.text]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    if (_currentTextView) {
        [self.arrValues replaceObjectAtIndex:3 withObject:[Utils saveToValues:_currentTextView.text]];
    }
    for (int i = 0; i < self.arrValues.count - 1; i++) {
        if ([self.arrValues[i] isEqualToString:@"demo"]) {
            [Utils showToastMessage:@"请完善信息"];
            return;
        }
    }
    AttachmentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrValues.count-1 inSection:0]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self createRecruitment:responseObject];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self createRecruitment:@[]];
    }
}

- (void)createRecruitment:(NSArray *)attachments {
    [Utils showHUDWithStatus:nil];
//    private Member member;//客户
//    private Dict type;//类型
//    private String typeValue;//类型值
//    private String title;//标题
//    private String content;//内容
//    private Date publishDate;//日期
//
//    private List<Attachment> attachments;//附件
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
    
    [params setObject:@{@"id":STRING(_dicMo.id)} forKey:@"type"];
    [params setObject:STRING(self.dicMo.value) forKey:@"typeValue"];
    
    [params setObject:STRING(self.arrValues[1]) forKey:@"title"];
    [params setObject:STRING(self.arrValues[2]) forKey:@"infoDate"];
    [params setObject:STRING(self.arrValues[3]) forKey:@"content"];
    
    if (_mo) {
        [[JYUserApi sharedInstance] updateRecruitmentId:_mo.id param:params attachments:[Utils filterUrls:attachments arrFile:_mo.attachments] success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"修改成功"];
            RecruitmentMo *tmpMo = [[RecruitmentMo alloc] initWithDictionary:responseObject error:nil];
            if (self.updateSuccess) {
                self.updateSuccess(tmpMo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] createRecruitmentParam:params attachments:attachments success:^(id responseObject) {
            [Utils dismissHUD];
            [Utils showToastMessage:@"创建成功"];
            if (self.updateSuccess) {
                self.updateSuccess(nil);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

#pragma mark - setter getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)arrLeft {
    if (!_arrLeft) {
        
        
        _arrLeft = @[@"类型",
                     @"标题",
                     @"日期",
                     @"内容",
                     @"附件"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择",
                      @"请输入",
                      @"请选择",
                      @"请输入详细内容",
                      @"附件"];
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

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) {
        _selectShowArr = [NSMutableArray new];
    }
    return _selectShowArr;
}

- (NSMutableArray *)attachments {
    if (!_attachments) {
        _attachments = [NSMutableArray new];
    }
    return _attachments;
}

- (NSMutableArray *)attachUrls {
    if (!_attachUrls) {
        _attachUrls = [NSMutableArray new];
    }
    return _attachUrls;
}

@end
