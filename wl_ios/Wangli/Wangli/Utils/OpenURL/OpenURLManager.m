//
//  OpenURLManager.m
//  Wangli
//
//  Created by yeqiang on 2018/8/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "OpenURLManager.h"
#import "CustomerCardViewCtrl.h"
#import "CustomerMo.h"
#import "MainTabBarViewController.h"
#import "CreateAddressViewCtrl.h"
#import "WebDetailViewCtrl.h"
#import "ContactDetailViewCtrl.h"
#import "CreateDealPlanViewCtrl.h"
#import "CreatePayPlanViewCtrl.h"
#import "RecruitmentMo.h"
#import "CreateProductionLicenseViewCtrl.h"
#import "BondInfoMo.h"
#import "CreateBondInfoViewCtrl.h"
#import "PurchaseLandMo.h"
#import "CreatePurchaseLandViewCtrl.h"
#import "BusinessVisitActiveViewCtrl.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CommonAutoViewCtrl.h"
#import "CreateTravelViewCtrl.h"

@implementation OpenURLManager
//http://crm-cdn-private.Wangli.com/2018上半年萧绍市场半月报.pdf1534994590861?e=1535007851&token=Dry7nZtT03zFkpQaMB5dDz9yLogddtn4rxiyEZbU:50MeKFTIkqywDjrpdjMqPv4xawI=

+ (void)handleOpenURL:(NSString *)url {
    
    NSMutableDictionary *params = [Utils getURLParameters:url];
    NSString *funValue = [Utils getURLTag:url];
    // 客户详情
    if ([funValue isEqualToString:@"2013"] || [funValue isEqualToString:@"2013/"]) {
        CustomerMo *mo = [[CustomerMo alloc] init];
        mo.id = [params[@"customreid"] integerValue];
        CustomerCardViewCtrl *vc = [[CustomerCardViewCtrl alloc] init];
        vc.mo = mo;
        vc.forbidRefresh = YES;
        vc.index = 0;
        vc.arrData = [[NSMutableArray alloc] initWithObjects:mo, nil];
        [TheCustomer insertCustomer:mo];
        vc.hidesBottomBarWhenPushed = YES;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        if ([params objectForKey:@"subId"] != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CUSTOMER_360_SELECT object:nil userInfo:@{@"section": @"0",@"item": [params objectForKey:@"subId"]}];
            });
        }
    }
    // 返回
    else if ([funValue isEqualToString:@"10002"] || [funValue isEqualToString:@"10002/"]) {
        if ([Utils topViewController].navigationController) {
            [[Utils topViewController].navigationController popViewControllerAnimated:YES];
        }
    }
    // 提交成功返回到订单列表
    else if ([funValue isEqualToString:@"5003"] || [funValue isEqualToString:@"5003/"]) {
        if ([Utils topViewController].navigationController) {
            [[Utils topViewController].navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                if ([mainVC isKindOfClass:[MainTabBarViewController class]]) {
                    ((MainTabBarViewController *)mainVC).selectedIndex = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_ORDER_LIST_REFRESH object:nil];
                }
            });
        }
    }
    // 跳新增收货地址
    else if ([funValue isEqualToString:@"2017"] || [funValue isEqualToString:@"2017/"]) {
        CustomerMo *mo = [[CustomerMo alloc] init];
        mo.id = [params[@"customerID"] integerValue];
//        TheCustomer.customerMo = mo;
        [TheCustomer insertCustomer:mo];
        CreateAddressViewCtrl *vc = [[CreateAddressViewCtrl alloc] init];
        vc.addSuccessBlock = ^(AddressMo *mo) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([[Utils topViewController] isKindOfClass:[WebDetailViewCtrl class]]) {
                    WebDetailViewCtrl *webVC = (WebDetailViewCtrl *)[Utils topViewController];
                    [webVC reloadWebView];
                }
            });
        };
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    // 跳新联系人详情
    else if ([funValue isEqualToString:@"7007"] || [funValue isEqualToString:@"7007/"]) {
        ContactMo *mo = [[ContactMo alloc] init];
        mo.id = [params[@"contactid"] integerValue];
        ContactDetailViewCtrl *vc = [[ContactDetailViewCtrl alloc] init];
        vc.mo = mo;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    // 要货计划详情
//    http://action:2021/?id=80553899&viewtype=view
    else if ([funValue isEqualToString:@"2021"] || [funValue isEqualToString:@"2021/"]) {
        DealPlanMo *mo = [[DealPlanMo alloc] init];
        mo.id = [params[@"id"] integerValue];
        CreateDealPlanViewCtrl *vc = [[CreateDealPlanViewCtrl alloc] init];
        vc.mo = mo;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    // 收款计划
    else if ([funValue isEqualToString:@"2022"] || [funValue isEqualToString:@"2022/"]) {
        PayPlanMo *mo = [[PayPlanMo alloc] init];
        mo.id = [params[@"id"] integerValue];
        CreatePayPlanViewCtrl *vc = [[CreatePayPlanViewCtrl alloc] init];
        vc.mo = mo;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    // pdf附件
    else if ([funValue isEqualToString:@"10054"] || [funValue isEqualToString:@"10054/"]) {
        NSString *pdfUrl = [NSString stringWithFormat:@"%@?", params[@"url"]];
        NSString *paramStr = @"";
        if (pdfUrl.length > 0) {
            NSArray *arrKeys = [params allKeys];
            for (int i = 0; i < params.count; i++) {
                NSString *key = arrKeys[i];
                if (![key isEqualToString:@"url"]) {
                    if (paramStr.length > 0) paramStr = [paramStr stringByAppendingString:@"&"];
                    paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",STRING(key),STRING(params[key])]];
                }
            }
        }
        if (paramStr.length > 0) pdfUrl = [pdfUrl stringByAppendingString:paramStr];
        if ([pdfUrl containsString:@"mp4"]) {
            NSURL *path = [NSURL URLWithString:pdfUrl];
            // 第二步:创建视频播放器
            MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
            playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            //第四步:跳转视频播放界面
            [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
            
        } else {
            WebDetailViewCtrl *vc = [[WebDetailViewCtrl alloc] init];
            vc.urlStr = pdfUrl;
            vc.titleStr = @"附件";
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        }
    }
    // 语音视频
    else if ([funValue isEqualToString:@"10058"] || [funValue isEqualToString:@"10058/"] ||
             [funValue isEqualToString:@"10059"] || [funValue isEqualToString:@"10059/"]) {
        NSString *urlStr = params[@"url"];
        urlStr = [NSString stringWithFormat:@"/%@", urlStr];
        urlStr = [NSString stringWithFormat:DOMAIN_NAME, urlStr];
        NSURL *path = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:path];
        playerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [[Utils topViewController] presentViewController:playerViewController animated:YES completion:nil];
    }
    // 采购招标
    else if ([funValue isEqualToString:@"2046"] || [funValue isEqualToString:@"2046/"]) {
        [OpenURLManager getDetail:7 tagId:[params[@"id"] integerValue]];
    }
    // 税务评级
    else if ([funValue isEqualToString:@"2048"] || [funValue isEqualToString:@"2048/"]) {
        [OpenURLManager getDetail:9 tagId:[params[@"id"] integerValue]];
    }
    // 检查抽查信息
    else if ([funValue isEqualToString:@"2049"] || [funValue isEqualToString:@"2049/"]) {
        [OpenURLManager getDetail:10 tagId:[params[@"id"] integerValue]];
    }
    // 债券信息
    else if ([funValue isEqualToString:@"2117"] || [funValue isEqualToString:@"2117/"]) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailBondById:[params[@"id"] integerValue] success:^(id responseObject) {
            [Utils dismissHUD];
            BondInfoMo *tmpMo = [[BondInfoMo alloc] initWithDictionary:responseObject error:nil];
            CreateBondInfoViewCtrl *vc = [[CreateBondInfoViewCtrl alloc] init];
            vc.bondInfoMo = tmpMo;
            vc.title = @"债券信息";
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
    // 购地信息
    else if ([funValue isEqualToString:@"2118"] || [funValue isEqualToString:@"2118/"]) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailPurchaseById:[params[@"id"] integerValue] success:^(id responseObject) {
            [Utils dismissHUD];
            PurchaseLandMo *tmpMo = [[PurchaseLandMo alloc] initWithDictionary:responseObject error:nil];
            CreatePurchaseLandViewCtrl *vc = [[CreatePurchaseLandViewCtrl alloc] init];
            vc.purchaseMo = tmpMo;
            vc.title = @"购地信息";
            [[Utils topViewController].navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    }
    // 拜访活动
    else if ([funValue isEqualToString:@"2662"] || [funValue isEqualToString:@"2662/"]) {
        BusinessVisitActiveViewCtrl *vc = [[BusinessVisitActiveViewCtrl alloc] init];
        BusinessVisitActivityMo *model = [[BusinessVisitActivityMo alloc] init];
        model.id = [params[@"id"] longLongValue];
        vc.model = model;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
    // 动态表单 2631/?id=80553899&viewType=view&backPageType=travel-business&title=差旅详情
    else if ([funValue isEqualToString:@"2631"] || [funValue isEqualToString:@"2631/"]) {
        CreateTravelViewCtrl *vc = [[CreateTravelViewCtrl alloc] init];
        vc.dynamicId = STRING(params[@"backPageType"]);
        vc.detailId = [params[@"id"] longLongValue];
        vc.isUpdate = YES;
        vc.title = STRING(params[@"title"]);
        if ([params[@"viewType"] isEqualToString:@"view"]) {
            vc.forbidEdit = YES;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [[Utils topViewController].navigationController pushViewController:vc animated:YES];
    }
}

+ (void)getDetail:(NSInteger)indexId tagId:(NSInteger)tagId  {
    // 采购招标
    if (indexId == 7) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailPruchaseById:tagId success:^(id responseObject) {
            [Utils dismissHUD];
            [OpenURLManager commonPushToEditVC:responseObject indexId:indexId];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    // 税务评级
    else if (indexId == 9) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailTaxRatingById:tagId success:^(id responseObject) {
            [Utils dismissHUD];
            [OpenURLManager commonPushToEditVC:responseObject indexId:indexId];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
    // 检查抽查
    else if (indexId == 10) {
        [Utils showHUDWithStatus:nil];
        [[JYUserApi sharedInstance] detailSpotCheckById:tagId success:^(id responseObject) {
            [Utils dismissHUD];
            [OpenURLManager commonPushToEditVC:responseObject indexId:indexId];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
        }];
    }
}

+ (void)commonPushToEditVC:(id)responseObject indexId:(NSInteger)indexId {
    NSError *error = nil;
    RecruitmentMo *tmpMo = [[RecruitmentMo alloc] initWithDictionary:responseObject error:nil];
    TheCustomer.customerMo = [[CustomerMo alloc] initWithDictionary:responseObject[@"member"] error:&error];
    CreateProductionLicenseViewCtrl *vc = [[CreateProductionLicenseViewCtrl alloc] init];
    vc.mo = tmpMo;
    vc.type = (ProduceViewCtrlType)indexId-6;
    NSArray *titleArray = @[@"生产许可",
                            @"采购招标",
                            @"进出口信息",
                            @"税务评级",
                            @"抽查检查"];
    if (indexId-6 < titleArray.count) {
        vc.title = titleArray[indexId-6];
    }
    [[Utils topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


//@"http://crm-test-api.aikosolar.net/file/201903/cfbe77306d0e4a7aa5f37ee4c25d936f.mp4";
//@"http://crm-test-api.aikosolar.net/file/201903/cfbe77306d0e4a7aa5f37ee4c25d936f.mp4"
