//
//  SalesCommonCreateViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2019/1/9.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "SalesCommonCreateViewCtrl.h"

@interface SalesCommonCreateViewCtrl ()

@end

@implementation SalesCommonCreateViewCtrl

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
        NSInteger tag = 0;
        for (int i = 0; i < self.arrData.count; i++) {
            CommonRowMo *tmpMo = self.arrData[i];
            // 客户
            if ([tmpMo.rowType isEqualToString:K_INPUT_MEMBER]  && [tmpMo.key isEqualToString:@"member"]) {
                tag++;
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
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
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
    [params setObject:@{@"id":@(TheCustomer.customerMo.id)} forKey:@"member"];
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

@end
