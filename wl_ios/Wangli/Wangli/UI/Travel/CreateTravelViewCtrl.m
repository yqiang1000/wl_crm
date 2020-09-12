//
//  CreateTravelViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateTravelViewCtrl.h"
#import "TravelArriveCityViewCtrl.h"

@interface CreateTravelViewCtrl ()

@property (nonatomic, copy) NSString *linkUrl;

@end

@implementation CreateTravelViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userselectType = 1;
    if (self.isUpdate) [self.rightBtn setTitle:@"更新" forState:UIControlStateNormal];
    if (self.detailId > 0) [self getTravelDetail];
}

// 获取详情，判断是否可以编辑
- (void)getTravelDetail {
    [[JYUserApi sharedInstance] getObjDetailByDynamicId:self.dynamicId detailId:self.detailId param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.travelMo = [[TravelMo alloc] initWithDictionary:responseObject error:&error];
        if (!self.forbidEdit) {
            if ([self.travelMo.operator[@"id"] integerValue] != TheUser.userMo.id) {
                self.forbidEdit = YES;
            }
        }
        self.rightBtn.hidden = self.forbidEdit;
    } failure:^(NSError *error) {
    }];
}

- (void)configRowMos {
    if (self.isUpdate) {
        [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId detailId:self.detailId param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self getInvoiceStandard];
        } failure:^(NSError *error) {
            [self getInvoiceStandard];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self getInvoiceStandard];
        } failure:^(NSError *error) {
            [self getInvoiceStandard];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)specialConfig {
    // 不可修改时，设置当前客户或者后台返回的客户，
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 文件
        if ([tmpMo.rowType isEqualToString:K_FILE_INPUT]) {
            for (QiniuFileMo *fileMo in tmpMo.attachments) {
                [self.attachments addObject:STRING(fileMo.thumbnail)];
                [self.attachUrls addObject:STRING(fileMo.url)];
            }
        }
        if ([tmpMo.key isEqualToString:@"cohabitOperator"]) {
            if ([tmpMo.strValue isEqualToString:@"无"] || tmpMo.strValue.length == 0) {
                JYUserMo *mo = [[JYUserMo alloc] init];
                mo.name = self.isUpdate ? @"无" : @"";
                mo.id = self.isUpdate ? 0 : -1;
                tmpMo.m_obj = mo;
                tmpMo.strValue = self.isUpdate ? @"无" : @"";
            }
        }
        
        // 如果已提交，则不可编辑
        if ([tmpMo.key isEqualToString:@"commit"]) {
            if (!self.forbidEdit) self.forbidEdit = tmpMo.defaultValue;
        }
        
        // 链接
        if ([tmpMo.key isEqualToString:@"btcc"]) {
            tmpMo.rowType = K_INPUT_LINK;
            tmpMo.rightContent = @"规范贴发票";
            tmpMo.value = self.linkUrl.length==0?@"http://img.jiuyisoft.com/fpgf.pptx":self.linkUrl;
            tmpMo.strValue = @"";
            tmpMo.editAble = NO;
            tmpMo.nullAble = YES;
        }
        
        // 报销城市
        if ([tmpMo.key isEqualToString:@"reimbursementCity"]) {
            tmpMo.rowType = K_INPUT_TEXT;
            tmpMo.inputType = K_SHORT_TEXT;
            tmpMo.strValue = [Utils saveToValues:(NSString *)tmpMo.value];
        }
        
        // 实名交通费
        if ([tmpMo.key isEqualToString:@"kcTransport"]) {
            BOOL nullAble = [tmpMo.strValue floatValue] > 0.0001 ? NO : YES;
            NSInteger count = 0;
            for (int j = 0; j < self.arrData.count; j++) {
                CommonRowMo *timeMo = self.arrData[j];
                if ([timeMo.key isEqualToString:@"boardTime"] || [timeMo.key isEqualToString:@"dropTime"]) {
                    timeMo.nullAble = nullAble;
                    timeMo.rightContent = timeMo.nullAble ? @"选填" : @"必填";
                    count++;
                }
                if (count == 2) break;
            }
        }
    }
    
//    CommonRowMo *row = [[CommonRowMo alloc] init];
//    row.rowType = K_INPUT_LINK;
//    row.leftContent = @"URL测试";
//    row.rightContent = @"百度";
//    row.value = @"https://www.baidu.com";
//    row.editAble = NO;
//    row.nullAble = YES;
//    [self.arrData addObject:row];
}

- (void)getInvoiceStandard {
    [[JYUserApi sharedInstance] getConfigDicByName:@"invoice_standard" success:^(id responseObject) {
        if (((NSArray *)responseObject).count > 0) {
            self.linkUrl = STRING([responseObject firstObject][@"value"]);
        }
        [self specialConfig];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self specialConfig];
        [self.tableView reloadData];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    long long userId = [params[@"cohabitOperator"][@"id"] longLongValue];
    // -1: 未选择， 0:无同住人员 1:有同住
    if (userId < 0) {
        [Utils showToastMessage:@"请选择同住人员"];
        return;
    }
    if (userId == 0) [params removeObjectForKey:@"cohabitOperator"];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachments"];
    [[JYUserApi sharedInstance] createDynmicFormDynamicId:self.dynamicId param:params success:^(id responseObject) {
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

- (void)updateParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    long long userId = [params[@"cohabitOperator"][@"id"] longLongValue];
    // -1: 未选择， 0:无同住人员 1:有同住
    if (userId < 0) {
        [Utils showToastMessage:@"请选择同住人员"];
        return;
    }
    if (userId == 0) [params removeObjectForKey:@"cohabitOperator"];
    
    [params setObject:@(self.detailId) forKey:@"id"];
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachments"];
    [[JYUserApi sharedInstance] updateDynmicFormDynamicId:self.dynamicId param:params success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"修改成功"];
        if (self.updateSuccess) {
            self.updateSuccess(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
//    if ([toDo isEqualToString:@"placeArrival"]) {
//        [self getBxbzForCRM:indexPath];
//    }
    if ([toDo isEqualToString:@"cityTrafficInvoiceAmount"]) {
        [self toCountJiaoTongNum];
    }
    if ([toDo isEqualToString:@"stayInvoiceAmount"]) {
        [self toCountZhuSuNum];
    }
    if ([toDo isEqualToString:@"commit"]) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        if (rowMo.defaultValue) {
            [Utils showToastMessage:@"保存提交OA之后，当前记录不允许修改!"];
        }
    }
    // 实名交通费
    if ([toDo isEqualToString:@"kcTransport"]) {
        CommonRowMo *kcMo = self.arrData[indexPath.row];
        BOOL nullAble = [kcMo.strValue floatValue] > 0.0001 ? NO : YES;
        NSInteger count = 0;
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            if ([tmpMo.key isEqualToString:@"boardTime"] || [tmpMo.key isEqualToString:@"dropTime"]) {
                tmpMo.nullAble = nullAble;
                tmpMo.rightContent = tmpMo.nullAble ? @"选填" : @"必填";
                count++;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (count == 2) break;
        }
    }
    // 上车时间
    if ([toDo isEqualToString:@"boardTime"]) {
        if ([self compareBeginAndEndDate]) {
            CommonRowMo *tmpMo = self.arrData[indexPath.row];
            [Utils showToastMessage:@"上车时间不能晚于下车时间"];
            tmpMo.strValue = [Utils saveToValues:selName];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }
    // 下车时间
    if ([toDo isEqualToString:@"dropTime"]) {
        if ([self compareBeginAndEndDate]) {
            CommonRowMo *tmpMo = self.arrData[indexPath.row];
            [Utils showToastMessage:@"下车时间不能早于上车时间"];
            tmpMo.strValue = [Utils saveToValues:selName];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
    }
    // 报销城市
    if ([toDo isEqualToString:@"reimbursementCity"] && [selName isEqualToString:@"DefaultInputCellBegin"]) {
        TravelArriveCityViewCtrl *vc = [[TravelArriveCityViewCtrl alloc] init];
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *obj) {
            __strong typeof(self) strongself = weakself;
            [strongself afterSelectCityName:STRING(obj)];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 同住人员
    if ([toDo isEqualToString:@"cohabitOperator"]) {
        [self getBxbzForCRM:nil];
    }
}

// 比较上车时间和下车时间
- (BOOL)compareBeginAndEndDate {
    
    CommonRowMo *beginMo = nil;
    CommonRowMo *endMo = nil;
    NSInteger count = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        if ([tmpMo.key isEqualToString:@"boardTime"]) {
            beginMo = tmpMo;
            count++;
        }
        if ([tmpMo.key isEqualToString:@"dropTime"]) {
            endMo = tmpMo;
            count++;
        }
        if (count == 2) break;
    }
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:beginMo.pattern];
    NSDate *beginTime = [minDateFormater dateFromString:beginMo.strValue];
    
    [minDateFormater setDateFormat:endMo.pattern];
    NSDate *endTime = [minDateFormater dateFromString:endMo.strValue];
    
    NSLog(@"\n时间1:%@\n时间2:%@", beginTime, endTime);
    if (beginMo.strValue.length == 0 || endMo.strValue.length == 0) {
        return NO;
    }
    //开始时间和当前时间比较
    NSComparisonResult result = [beginTime compare:endTime];
    if (result == NSOrderedAscending) {  //升序
        // 返回正常
        return NO;
    } else {
        // 结束时间不能早于开始时间
        return YES;
    }
}

- (void)getBxbzForCRM:(NSIndexPath *)indexPath {
    //    cityname=杭州&workcode=WLM1NG20118&tzryworkcode=123
    NSMutableDictionary *param = [NSMutableDictionary new];
    // 同住人员
    NSInteger tzryIndex = 0;
    NSInteger bxcsIndex = 0;
    CommonRowMo *tzryMo = nil;
    CommonRowMo *bxcsMo = nil;
    NSInteger count = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"cohabitOperator"]) {
            tzryMo = tmpRowMo;
            tzryIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"reimbursementCity"]) {
            bxcsMo = tmpRowMo;
            bxcsIndex = i;
            count++;
        }
        if (count==2) break;
    }
    
    JYUserMo *userMo = (JYUserMo *)tzryMo.m_obj;
    long long userId =  userMo.id;
    // -1: 未选择， 0:无同住人员 1:有同住
    if (userId > 0) [param setObject:STRING(userMo.oaCode) forKey:@"tzryworkcode"];
    
    // 报销城市
    [param setObject:STRING(bxcsMo.strValue) forKey:@"cityname"];
    [param setObject:STRING(TheUser.userMo.oaCode) forKey:@"workcode"];
    [[JYUserApi sharedInstance] getBxbzFroCrmParam:param success:^(id responseObject) {
        // 住宿 stayReimbursementStandard         zsbz
        // 交通 cityTrafficReimbursementStandard  jtbz
        // 餐补 mealAllowance                     cbbz
        NSInteger count = 0;
        NSString *zsbz = [Utils getPriceFromStr:[NSString stringWithFormat:@"%@", responseObject[@"zsbz"]]];
        NSString *jtbz = [Utils getPriceFromStr:[NSString stringWithFormat:@"%@", responseObject[@"jtbz"]]];
        NSString *cbbz = [Utils getPriceFromStr:[NSString stringWithFormat:@"%@", responseObject[@"cbbz"]]];
        
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            if ([tmpMo.key isEqualToString:@"stayReimbursementStandard"]) {
                tmpMo.value = zsbz;
                tmpMo.strValue = zsbz;
                count++;
            }
            if ([tmpMo.key isEqualToString:@"cityTrafficReimbursementStandard"]) {
                tmpMo.value = jtbz;
                tmpMo.strValue = jtbz;
                count++;
            }
            if ([tmpMo.key isEqualToString:@"mealAllowance"]) {
                tmpMo.value = cbbz;
                tmpMo.strValue = cbbz;
                count++;
            }
            if (count == 3) break;
        }
        [self toCountZhuSuNum];
        [self toCountJiaoTongNum];
        [self toCountCanBuNum];
    } failure:^(NSError *error) {
    }];
}

// 根据市内交通发票和标准得出报销金额
- (void)toCountJiaoTongNum {
    CommonRowMo *fapiaoMo = nil;
    CommonRowMo *biaozhunMo = nil;
    CommonRowMo *jineMo = nil;
    NSInteger count = 0;
    NSInteger fapiaoIndex = 0;
    NSInteger biaozhunIndex = 0;
    NSInteger jineIndex = 0;
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"cityTrafficInvoiceAmount"]) {
            fapiaoMo = tmpRowMo;
            fapiaoIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cityTrafficReimbursementStandard"]) {
            biaozhunMo = tmpRowMo;
            biaozhunIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"cityTrafficReimbursementAmount"]) {
            jineMo = tmpRowMo;
            jineIndex = i;
            count++;
        }
        if (count==3) break;
    }
    
    CGFloat fapiao = [((NSString *)fapiaoMo.value) floatValue];
    CGFloat biaozhun = [((NSString *)biaozhunMo.value) floatValue];
    if (biaozhun - fapiao > 0) {
        jineMo.strValue = [Utils getPriceFrom:fapiao];
        jineMo.value = [NSString stringWithFormat:@"%f", fapiao];
    } else {
        jineMo.strValue = [Utils getPriceFrom:biaozhun];
        jineMo.value = [NSString stringWithFormat:@"%f", biaozhun];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:fapiaoIndex inSection:0],
                                             [NSIndexPath indexPathForRow:biaozhunIndex inSection:0],
                                             [NSIndexPath indexPathForRow:jineIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// 根据住宿发票和标准得出报销金额
- (void)toCountZhuSuNum {
    CommonRowMo *fapiaoMo = nil;
    CommonRowMo *biaozhunMo = nil;
    CommonRowMo *jineMo = nil;
    NSInteger count = 0;
    NSInteger fapiaoIndex = 0;
    NSInteger biaozhunIndex = 0;
    NSInteger jineIndex = 0;
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        if ([tmpRowMo.key isEqualToString:@"stayInvoiceAmount"]) {
            fapiaoMo = tmpRowMo;
            fapiaoIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"stayReimbursementStandard"]) {
            biaozhunMo = tmpRowMo;
            biaozhunIndex = i;
            count++;
        } else if ([tmpRowMo.key isEqualToString:@"stayReimbursementAmount"]) {
            jineMo = tmpRowMo;
            jineIndex = i;
            count++;
        }
        if (count==3) break;
    }
    
    CGFloat fapiao = [((NSString *)fapiaoMo.value) floatValue];
    CGFloat biaozhun = [((NSString *)biaozhunMo.value) floatValue];
    if (biaozhun - fapiao > 0) {
        jineMo.strValue = [Utils getPriceFrom:fapiao];
        jineMo.value = [NSString stringWithFormat:@"%f", fapiao];
    } else {
        jineMo.strValue = [Utils getPriceFrom:biaozhun];
        jineMo.value = [NSString stringWithFormat:@"%f", biaozhun];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:fapiaoIndex inSection:0],
                                             [NSIndexPath indexPathForRow:biaozhunIndex inSection:0],
                                             [NSIndexPath indexPathForRow:jineIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// 根据餐补和标准得出餐补金额
- (void)toCountCanBuNum {
//    CommonRowMo *fapiaoMo = nil;
    CommonRowMo *biaozhunMo = nil;
//    CommonRowMo *jineMo = nil;
    NSInteger count = 0;
//    NSInteger fapiaoIndex = 0;
    NSInteger biaozhunIndex = 0;
//    NSInteger jineIndex = 0;
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpRowMo = self.arrData[i];
        // 餐补标准
        if ([tmpRowMo.key isEqualToString:@"mealAllowance"]) {
            biaozhunMo = tmpRowMo;
            biaozhunIndex = i;
            count++;
        }
        if (count==1) break;
    }
    
//    CGFloat fapiao = [((NSString *)fapiaoMo.value) floatValue];
//    CGFloat biaozhun = [((NSString *)biaozhunMo.value) floatValue];
//    if (biaozhun - fapiao > 0) {
//        jineMo.strValue = [Utils getPriceFrom:fapiao];
//        jineMo.value = [NSString stringWithFormat:@"%f", fapiao];
//    } else {
//        jineMo.strValue = [Utils getPriceFrom:biaozhun];
//        jineMo.value = [NSString stringWithFormat:@"%f", biaozhun];
//    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:biaozhunIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)afterSelectCityName:(NSString *)cityname {
    NSInteger index = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        if ([tmpMo.key isEqualToString:@"reimbursementCity"]) {
            tmpMo.strValue = cityname;
            tmpMo.m_obj = cityname;
            index = i;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    [self getBxbzForCRM:[NSIndexPath indexPathForRow:index inSection:0]];
}

@end
