//
//  CreateStoreViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/6/29.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CreateStoreViewCtrl.h"
#import "StoreBandsMo.h"
#import "QueryCityViewCtrl.h"

@interface CreateStoreViewCtrl ()

@property (nonatomic, strong) NSMutableDictionary *provinceDic;
@property (nonatomic, strong) NSMutableDictionary *cityDic;
@property (nonatomic, strong) NSMutableDictionary *areaDic;
@property (nonatomic, strong) CommonRowMo *provinceRowMo;
@property (nonatomic, strong) CommonRowMo *memberRowMo;

@end

@implementation CreateStoreViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configRowMos {
    if (self.isUpdate) {
        // 修改的话，先获取详情，再获取列表
        [[JYUserApi sharedInstance] getObjDetailByDynamicId:self.dynamicId detailId:self.storeMo.id param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.storeMo = [[StoreMo alloc] initWithDictionary:responseObject error:&error];
            [self getDynmicFormUpdatePage];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 如果是从首页进来，可以选客户，如果是从360进来，不允许选择客户
        [self getDynmicFormCreatePage];
    }
}

// 获取新建动态表单
- (void)getDynmicFormCreatePage {
    [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self specialConfig];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

// 获取修改动态表单
- (void)getDynmicFormUpdatePage {
    [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId detailId:self.detailId param:nil success:^(id responseObject) {
        NSError *error = nil;
        self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
        [self specialConfig];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)specialConfig {
    // 修改的情况
    if (self.storeMo) {
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            // 客户
            if ([tmpMo.key isEqualToString:@"customer"]) {
                self.memberRowMo = tmpMo;
                self.memberRowMo.member.provinceNumber = STRING(self.storeMo.province[@"provinceId"]);
                self.memberRowMo.member.cityNumber = STRING(self.storeMo.city[@"cityId"]);
                self.memberRowMo.member.areaNumber = STRING(self.storeMo.area[@"areaId"]);
            }
            // 文件
            if ([tmpMo.rowType isEqualToString:K_FILE_INPUT]) {
                tmpMo.nullAble = YES;
                for (QiniuFileMo *fileMo in tmpMo.attachments) {
                    [self.attachments addObject:STRING(fileMo.thumbnail)];
                    [self.attachUrls addObject:STRING(fileMo.url)];
                }
            }
            // 省份
            if ([tmpMo.key isEqualToString:@"province"]) {
                if (self.storeMo.province) {
                    tmpMo.value = self.storeMo.province[@"provinceName"];
                    tmpMo.strValue = self.storeMo.province[@"provinceName"];;
                    tmpMo.m_obj = self.storeMo.province;
                    tmpMo.singleValue = nil;
                    self.provinceDic = [[NSMutableDictionary alloc] initWithDictionary:self.storeMo.province];
                    self.provinceRowMo = tmpMo;
                }
            }
            // 市
            if ([tmpMo.key isEqualToString:@"city"]) {
                tmpMo.editAble = YES;
                tmpMo.rowType = K_INPUT_TEXT;
                tmpMo.inputType = K_SHORT_TEXT;
                if (self.storeMo.city) {
                    tmpMo.value = self.storeMo.city[@"cityName"];
                    tmpMo.strValue = self.storeMo.city[@"cityName"];;
                    tmpMo.m_obj = self.storeMo.city;
                    tmpMo.singleValue = nil;
                    self.cityDic = [[NSMutableDictionary alloc] initWithDictionary:self.storeMo.city];
                }
            }
            // 区
            if ([tmpMo.key isEqualToString:@"area"]) {
                tmpMo.editAble = YES;
                tmpMo.rowType = K_INPUT_TEXT;
                tmpMo.inputType = K_SHORT_TEXT;
                if (self.storeMo.area) {
                    tmpMo.value = self.storeMo.area[@"areaName"];
                    tmpMo.strValue = self.storeMo.area[@"areaName"];;
                    tmpMo.m_obj = self.storeMo.area;
                    tmpMo.singleValue = nil;
                    self.areaDic = [[NSMutableDictionary alloc] initWithDictionary:self.storeMo.area];
                }
            }
            
            // 修改时客户不可修改
            if ([tmpMo.key isEqualToString:@"customer"] ||
                [tmpMo.key isEqualToString:@"forPublicHouseholds"] ||
                [tmpMo.key isEqualToString:@"legalName"]) {
                if (self.isUpdate) tmpMo.editAble = NO;
            }
            
            // 品牌
            if ([tmpMo.key isEqualToString:@"brandName"]) {
                NSString *str = [[NSString alloc] init];
                NSError *error = nil;
                NSMutableArray *arrBands = [StoreBandsMo arrayOfModelsFromDictionaries:self.storeMo.brand error:&error];
                for (int i = 0; i < arrBands.count; i++) {
                    StoreBandsMo *tmpMo = arrBands[i];
                    str = [str stringByAppendingString:STRING(tmpMo.brandName)];
                    if (i < arrBands.count - 1) {
                        str = [str stringByAppendingString:@" "];
                    }
                }
                tmpMo.strValue = str;
                tmpMo.m_objs = arrBands;
            }
        }
    } else {
        // 新建的情况
        if (!self.fromTab) {
            for (int i = 0; i < self.arrData.count; i++) {
                CommonRowMo *tmpMo = self.arrData[i];
                // 客户
                if ([tmpMo.key isEqualToString:@"customer"]) {
                    tmpMo.member = TheCustomer.customerMo;
                    tmpMo.strValue = TheCustomer.customerMo.orgName;
                    [self continueTodo:@"member" selName:@"MemberSelectViewCtrl" indexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                // 360进来新建时客户不可修改
                if ([tmpMo.key isEqualToString:@"customer"] ||
                    [tmpMo.key isEqualToString:@"forPublicHouseholds"] ||
                    [tmpMo.key isEqualToString:@"legalName"]) {
                    tmpMo.editAble = NO;
                    if ([tmpMo.key isEqualToString:@"customer"]) {
                        self.memberRowMo = tmpMo;
                    }
                }
                if ([tmpMo.key isEqualToString:@"legalName"]) {
                    tmpMo.strValue = TheCustomer.customerMo.legalName;
                }
                if ([tmpMo.key isEqualToString:@"forPublicHouseholds"]) {
                    tmpMo.strValue = TheCustomer.customerMo.orgName;
                }
            }
        }
        NSInteger count = 0;
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            // 360进来新建时客户不可修改
            if ([tmpMo.key isEqualToString:@"city"] ||
                [tmpMo.key isEqualToString:@"area"]) {
                tmpMo.editAble = YES;
                tmpMo.rowType = K_INPUT_TEXT;
                tmpMo.inputType = K_SHORT_TEXT;
                count++;
                if (count==2) break;
            } else if ([tmpMo.key isEqualToString:@"province"]) {
                self.provinceRowMo = tmpMo;
            }
        }
    }
}

- (void)continueTodo:(NSString *)toDo selName:(NSString *)selName indexPath:(NSIndexPath *)indexPath {
    if ([toDo isEqualToString:@"member"] && [selName isEqualToString:@"MemberSelectViewCtrl"]) {
        CommonRowMo *rowMo = self.arrData[indexPath.row];
        CustomerMo *tmpMember = rowMo.member;
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] getMemberDetailParam:nil memberId:tmpMember.id success:^(id responseObject) {
            [Utils dismissHUD];
            NSError *error = nil;
            NSMutableArray *tmpArr = [CustomerMo arrayOfModelsFromDictionaries:responseObject[@"content"] error:&error];
            if (tmpArr.count > 0) rowMo.member = tmpArr.firstObject;
            [self getAddressConfig:rowMo.member];
            [self dealWithOtherDefaultConfig:rowMo.member];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else if ([toDo isEqualToString:@"city"] && [selName isEqualToString:@"DefaultInputCellBegin"]) {
        __block CommonRowMo *memberRowMo = nil;
        CommonRowMo *provinceRowMo = nil;
        // 如果省份为空，则返回
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            if ([tmpMo.key isEqualToString:@"customer"]) {
                memberRowMo = tmpMo;
            } else if ([tmpMo.key isEqualToString:@"province"]) {
                if (tmpMo.strValue.length == 0) {
                    [Utils showToastMessage:@"省份为空"];
                    [self hidenKeyboard];
                    return;
                } else {
                    provinceRowMo = tmpMo;
                    break;
                }
            }
        }
        
        QueryCityViewCtrl *vc = [[QueryCityViewCtrl alloc] init];
        vc.typeId = 1;
        vc.searchId = STRING(((NSDictionary *)provinceRowMo.m_obj)[@"provinceId"]);
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *cityId) {
            __strong typeof(self) strongself = weakself;
            memberRowMo.member.cityNumber = cityId;
            memberRowMo.member.areaNumber = nil;
            [strongself getAddressConfig:memberRowMo.member];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([toDo isEqualToString:@"area"] && [selName isEqualToString:@"DefaultInputCellBegin"]) {
        __block CommonRowMo *memberRowMo = nil;
        CommonRowMo *cityRowMo = nil;
        // 如果市为空，则返回
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            if ([tmpMo.key isEqualToString:@"customer"]) {
                memberRowMo = tmpMo;
            } else if ([tmpMo.key isEqualToString:@"city"]) {
                if (tmpMo.strValue.length == 0) {
                    [Utils showToastMessage:@"地区为空"];
                    [self hidenKeyboard];
                    return;
                } else {
                    cityRowMo = tmpMo;
                    break;
                }
            }
        }
        
        QueryCityViewCtrl *vc = [[QueryCityViewCtrl alloc] init];
        vc.typeId = 2;
        vc.searchId = STRING(((NSDictionary *)cityRowMo.m_obj)[@"cityId"]);
        __weak typeof(self) weakself = self;
        vc.updateSuccess = ^(NSString *areaId) {
            __strong typeof(self) strongself = weakself;
            memberRowMo.member.areaNumber = areaId;
            [strongself getAddressConfig:memberRowMo.member];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)getProvinceCityAreaId:(NSString *)provinceCityAreaId {
    if (provinceCityAreaId.length == 0) {
        return @"0";
    } else {
        return provinceCityAreaId;
    }
}

- (void)getAddressConfig:(CustomerMo *)config {
    _provinceDic = nil;
    _cityDic = nil;
    _areaDic = nil;

    if (config.provinceNumber.length > 0) {
        [[JYUserApi sharedInstance] getProvinceByProvinceId:config.provinceNumber param:nil success:^(id responseObject) {
            self.provinceDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [self refreshAddressType:@"province" typeName:@"provinceName" typeDic:self.provinceDic];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [self refreshAddressType:@"province" typeName:@"provinceName" typeDic:self.provinceDic];
        }];
    } else {
        [self resetAddressType:@"province" typeDic:self.provinceDic];
    }
    
    if (config.cityNumber.length > 0) {
        [[JYUserApi sharedInstance] getCityByCityId:config.cityNumber param:nil success:^(id responseObject) {
            self.cityDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [self refreshAddressType:@"city" typeName:@"cityName" typeDic:self.cityDic];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [self refreshAddressType:@"city" typeName:@"cityName" typeDic:self.cityDic];
        }];
    } else {
        [self resetAddressType:@"city" typeDic:self.cityDic];
    }
    
    if (config.areaNumber.length > 0) {
        [[JYUserApi sharedInstance] getAreaByAreaId:config.areaNumber param:nil success:^(id responseObject) {
            self.areaDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [self refreshAddressType:@"area" typeName:@"areaName" typeDic:self.areaDic];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
            [self refreshAddressType:@"area" typeName:@"areaName" typeDic:self.areaDic];
        }];
    } else {
        [self resetAddressType:@"area" typeDic:self.areaDic];
    }
}

- (void)refreshAddressType:(NSString *)type typeName:(NSString *)typeName typeDic:(NSMutableDictionary *)typeDic {
    NSInteger addressId = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 省份
        if ([tmpMo.key isEqualToString:STRING(type)]) {
            addressId = i;
            tmpMo.value = typeDic[STRING(typeName)];
            tmpMo.strValue = typeDic[STRING(typeName)];;
            tmpMo.m_obj = typeDic;
            break;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:addressId inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)resetAddressType:(NSString *)type typeDic:(NSMutableDictionary *)typeDic {
    NSInteger addressId = 0;
    typeDic = nil;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 省份
        if ([tmpMo.key isEqualToString:STRING(type)]) {
            addressId = i;
            tmpMo.value = @"";
            tmpMo.strValue = @"";
            tmpMo.m_obj = typeDic;
            break;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:addressId inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dealWithOtherDefaultConfig:(CustomerMo *)config {
    NSInteger publicIndex = 0;
    NSInteger legalIndex = 0;
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 对公
        if ([tmpMo.key isEqualToString:@"forPublicHouseholds"]) {
            publicIndex = i;
            tmpMo.value = config.orgName;
            tmpMo.strValue = config.orgName;
        }
        // 法人
        if ([tmpMo.key isEqualToString:@"legalName"]) {
            legalIndex = i;
            tmpMo.value = config.legalName;
            tmpMo.strValue = config.legalName;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:publicIndex inSection:0],
                                             [NSIndexPath indexPathForRow:legalIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachmentList"];
    
    [params removeObjectForKey:@"province"];
    [params removeObjectForKey:@"city"];
    [params removeObjectForKey:@"area"];
    [params removeObjectForKey:@"brandName"];
    
    [params setObject:STRING(self.provinceDic[@"provinceName"]) forKey:@"provinceName"];
    [params setObject:STRING(self.provinceDic[@"id"]) forKey:@"provinceId"];
    [params setObject:STRING(self.cityDic[@"cityName"]) forKey:@"cityName"];
    [params setObject:STRING(self.cityDic[@"id"]) forKey:@"cityId"];
    [params setObject:STRING(self.areaDic[@"areaName"]) forKey:@"areaName"];
    [params setObject:STRING(self.areaDic[@"id"]) forKey:@"areaId"];
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 品牌
        if ([tmpMo.key isEqualToString:@"brandName"]) {
            NSString *idStr = @"";
            NSString *nameStr = @"";
            for (int i = 0; i < tmpMo.m_objs.count; i++) {
                StoreBandsMo *brandsMo = tmpMo.m_objs[i];
                idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)brandsMo.id]];
                nameStr = [nameStr stringByAppendingString:STRING(brandsMo.brandName)];
                if (i < tmpMo.m_objs.count - 1) {
                    idStr = [idStr stringByAppendingString:@"-"];
                    nameStr = [nameStr stringByAppendingString:@" "];
                }
            }
            [params setObject:STRING(idStr) forKey:@"brandId"];
            [params setObject:STRING(nameStr) forKey:@"brandName"];
        }
    }
    
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
    [params setObject:@(self.detailId) forKey:@"id"];
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachmentList"];
    
    [params removeObjectForKey:@"province"];
    [params removeObjectForKey:@"city"];
    [params removeObjectForKey:@"area"];
    [params removeObjectForKey:@"brandName"];
    
    [params setObject:STRING(self.provinceDic[@"provinceName"]) forKey:@"provinceName"];
    [params setObject:STRING(self.provinceDic[@"id"]) forKey:@"provinceId"];
    [params setObject:STRING(self.cityDic[@"cityName"]) forKey:@"cityName"];
    [params setObject:STRING(self.cityDic[@"id"]) forKey:@"cityId"];
    [params setObject:STRING(self.areaDic[@"areaName"]) forKey:@"areaName"];
    [params setObject:STRING(self.areaDic[@"id"]) forKey:@"areaId"];
    
    for (int i = 0; i < self.arrData.count; i++) {
        CommonRowMo *tmpMo = self.arrData[i];
        // 品牌
        if ([tmpMo.key isEqualToString:@"brandName"]) {
            NSString *idStr = @"";
            NSString *nameStr = @"";
            for (int i = 0; i < tmpMo.m_objs.count; i++) {
                StoreBandsMo *brandsMo = tmpMo.m_objs[i];
                idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)brandsMo.id]];
                nameStr = [nameStr stringByAppendingString:STRING(brandsMo.brandName)];
                if (i < tmpMo.m_objs.count - 1) {
                    idStr = [idStr stringByAppendingString:@"-"];
                    nameStr = [nameStr stringByAppendingString:@" "];
                }
            }
            [params setObject:STRING(idStr) forKey:@"brandId"];
            [params setObject:STRING(nameStr) forKey:@"brandName"];
        }
    }
    
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

- (NSMutableDictionary *)provinceDic {
    if (!_provinceDic) _provinceDic = [NSMutableDictionary new];
    return _provinceDic;
}

- (NSMutableDictionary *)cityDic {
    if (!_cityDic) _cityDic = [NSMutableDictionary new];
    return _cityDic;
}

- (NSMutableDictionary *)areaDic {
    if (!_areaDic) _areaDic = [NSMutableDictionary new];
    return _areaDic;
}

@end
