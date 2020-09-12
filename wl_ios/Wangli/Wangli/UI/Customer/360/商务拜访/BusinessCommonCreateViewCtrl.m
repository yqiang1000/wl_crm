//
//  BusinessCommonCreateViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BusinessCommonCreateViewCtrl.h"

@interface BusinessCommonCreateViewCtrl ()

@end

@implementation BusinessCommonCreateViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configRowMos {
    if (self.isUpdate) {
        [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId detailId:self.detailId param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self specialConfig];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        [[JYUserApi sharedInstance] getDynmicFormDynamicId:self.dynamicId param:nil success:^(id responseObject) {
            NSError *error = nil;
            self.arrData = [CommonRowMo arrayOfModelsFromDictionaries:responseObject error:&error];
            [self specialConfig];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
}

- (void)specialConfig {
    // 不可修改时，设置当前客户或者后台返回的客户，
    if (!self.fromTab) {
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            // 客户
            if ([tmpMo.rowType isEqualToString:K_INPUT_MEMBER]) {
                tmpMo.editAble = NO;
                if (!self.isUpdate) {
                    // 新建时设置当前客户
                    tmpMo.strValue = TheCustomer.customerMo.orgName;
                    tmpMo.member = TheCustomer.customerMo;
                }
            }
            // 文件
            if ([tmpMo.rowType isEqualToString:K_FILE_INPUT]) {
                for (QiniuFileMo *fileMo in tmpMo.attachments) {
                    [self.attachments addObject:STRING(fileMo.thumbnail)];
                    [self.attachUrls addObject:STRING(fileMo.url)];
                }
            }
            // 活动地址
            if ([tmpMo.key isEqualToString:@"address"] && [tmpMo.rowType isEqualToString:K_INPUT_TEXT]) {
                if (!self.isUpdate) {
                    tmpMo.strValue = [Utils saveToValues:TheCustomer.customerMo.stras];
                    continue;
                }
            }
        }
    }
}

#pragma mark - event

- (void)createParams:(NSMutableDictionary *)params attachementList:(NSArray *)attachementList {
    NSMutableArray *arr = [NSMutableArray new];
    for (QiniuFileMo *tmpMo in attachementList) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[tmpMo toDictionary]];
        [dic setObject:@"" forKey:@"url"];
        [dic setObject:@"" forKey:@"thumbnail"];
        [arr addObject:dic];
    }
    if (arr.count > 0) [params setObject:arr forKey:@"attachmentList"];
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
    
    if ([selName isEqualToString:@"MemberSelectViewCtrl"]) {
        if ([toDo isEqualToString:@"member"]) {
            CommonRowMo *rowMo0 = self.arrData[indexPath.row];
            if (rowMo0.member) {
                for (int i = 0; i < self.arrData.count; i++) {
                    CommonRowMo *tmpMo = self.arrData[i];
                    if ([tmpMo.key isEqualToString:@"address"]) {
                        tmpMo.strValue = [Utils saveToValues:rowMo0.member.stras];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        break;
                    }
                }
            }
        }
    }
}



@end
