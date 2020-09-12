//
//  SuggestionViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/4/27.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "SuggestionViewCtrl.h"
#import "MyCommonCell.h"
#import "AttachmentCell.h"
#import "WSDatePickerView.h"
#import "QiNiuUploadHelper.h"
#import "ListSelectViewCtrl.h"
#import "sys/utsname.h"

@interface SuggestionViewCtrl () <UITableViewDelegate, UITableViewDataSource, MyButtonCellDelegate, MyTextViewCellDelegate, ListSelectViewCtrlDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrLeft;
@property (nonatomic, strong) NSArray *arrRight;
@property (nonatomic, strong) NSMutableArray *arrValues;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) UITextView *txtView;
@property (nonatomic, strong) NSMutableArray *arrSelect;
@property (nonatomic, strong) NSMutableArray *selectShowArr;
@property (nonatomic, strong) DicMo *typeDic;

@property (nonatomic, strong) AttachmentCell *attCell;

@end

@implementation SuggestionViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self config];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)config {
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
        ShowTextMo *showTextMo = [Utils showTextRightStr:@"" valueStr:self.arrValues[2]];
        cell.txtView.text = showTextMo.text;
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        static NSString *identifier = @"attachmentCell";
        if (!_attCell) {
            self.attCell = [[AttachmentCell alloc] init];
            self.attCell.count = 9;
            [self.attCell refreshView];
        }
        return _attCell;
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
        cell.labRight.textColor = COLOR_B2;
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.arrSelect.count != 0) {
            [self pushToSelectVC:indexPath];
        } else {
            [Utils showHUDWithStatus:nil];
            [[JYUserApi sharedInstance] getConfigDicByName:@"app_question_feedback" success:^(id responseObject) {
                [Utils dismissHUD];
                self.arrSelect = [DicMo arrayOfModelsFromDictionaries:responseObject error:nil];
                for (DicMo *tmpDic in self.arrSelect) {
                    ListSelectMo *mo = [[ListSelectMo alloc] init];
                    mo.moId = tmpDic.id;
                    mo.moText = tmpDic.value;
                    [self.selectShowArr addObject:mo];
                }
                [self pushToSelectVC:indexPath];
            } failure:^(NSError *error) {
                [Utils dismissHUD];
            }];
        }
    }
    // 反馈时间
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *scrollToDate = [minDateFormater dateFromString:self.arrValues[1]];
        __weak typeof(self) weakself = self;
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",date);
            [weakself.arrValues replaceObjectAtIndex:1 withObject:STRING([Utils saveToValues:date])];
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        datepicker.dateLabelColor = COLOR_B1;//年-月-日-时-分 颜色
        datepicker.datePickerColor = COLOR_B1;//滚轮日期颜色
        datepicker.doneButtonColor = COLOR_C1;//确定按钮的颜色
        datepicker.hideBackgroundYearLabel = YES;//隐藏背景年份文字
        [datepicker show];
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

    if (_attCell.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadFileMulti:_attCell.attachments success:^(id responseObject) {
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
    NSString *comment = self.arrValues[2];
    comment = [comment stringByAppendingString:[NSString stringWithFormat:@"\n应用版本：%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    comment = [comment stringByAppendingString:[NSString stringWithFormat:@"\n系统版本：%@", [[UIDevice currentDevice] systemVersion]]];
    comment = [comment stringByAppendingString:[NSString stringWithFormat:@"\n设备版本：%@", [self deviceVersion]]];
    
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
    NSString *newToken = [deviceToken description];
    if (newToken.length > 0) {
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        comment = [comment stringByAppendingString:[NSString stringWithFormat:@"\n推送token：%@", newToken]];
    }
    
    [param setObject:comment forKey:@"content"];
    
    [param setObject:self.arrValues[1] forKey:@"infoDate"];
    [param setObject:self.arrValues[0] forKey:@"title"];
    [param setObject:STRING(self.typeDic.value) forKey:@"feedTypeValue"];
    [param setObject:STRING(self.typeDic.key) forKey:@"feedTypeKey"];
//    UIDevice
    [param setObject:self.arrValues[0] forKey:@"deviceInfo"];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachments) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [param setObject:arr forKey:@"attachmentList"];
    
    [[JYUserApi sharedInstance] createFeedBackParam:param success:^(id responseObject) {
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

#pragma mark - ListSelectViewCtrlDelegate

- (void)listSelectViewCtrl:(ListSelectViewCtrl *)listSelectViewCtrl selectIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath selectMo:(ListSelectMo *)selectMo {
    self.typeDic = self.arrSelect[index];
    [self.arrValues replaceObjectAtIndex:0 withObject:[Utils saveToValues:selectMo.moText]];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString*)deviceVersion {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
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
        _arrLeft = @[@"问题类别",
                     @"发生时间",
                     
                     @"反馈内容",
                     @"附件",
                     @"提交"];
    }
    return _arrLeft;
}

- (NSArray *)arrRight {
    if (!_arrRight) {
        _arrRight = @[@"请选择问题类别",
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

- (NSMutableArray *)arrSelect {
    if (!_arrSelect) {
        _arrSelect = [NSMutableArray new];
    }
    return _arrSelect;
}

- (NSMutableArray *)selectShowArr {
    if (!_selectShowArr) {
        _selectShowArr = [NSMutableArray new];
    }
    return _selectShowArr;
}

@end
