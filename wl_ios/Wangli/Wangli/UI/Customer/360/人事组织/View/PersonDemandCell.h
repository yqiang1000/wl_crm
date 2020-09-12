//
//  PersonDemandCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkManDemandMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonDemandCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) LinkManDemandMo *model;
- (void)loadData:(LinkManDemandMo *)model;

@end


//{
//    "id": 24,
//    "sort": 1,
//    "createdDate": 1545739241109,
//    "lastModifiedDate": 1545739241109,
//    "createdBy": "17721180295",
//    "lastModifiedBy": "17721180295",
//    "member": {
//        "id": 199,
//        "sort": 1,
//        "createdDate": 1545101062721,
//        "lastModifiedDate": 1546863303484,
//        "createdBy": "system",
//        "lastModifiedBy": "1022768",
//        "statusValue": "普通",
//        "statusKey": "ordinary",
//        "crmNumber": "200193",
//        "simpleSpell": "fsyz",
//        "office": {
//            "id": 59,
//            "sort": 200,
//            "createdDate": 1544544000000,
//            "lastModifiedDate": 1546513991814,
//            "createdBy": "13901565517",
//            "lastModifiedBy": "13901565517",
//            "name": "销售部(Z)",
//            "oaDepartmentId": "260"
//        },
//        "sapNumber": "200193",
//        "abbreviation": "佛山雅卓",
//        "orgName": "佛山市禅城区雅卓文具劳保商场",
//        "arOperatorName": "涂曦",
//        "frOperatorName": "董志勇",
//        "srOperatorName": "张善淋",
//        "creditLevelValue": "AAA",
//        "riskLevelValue": "高危",
//        "cooperationTypeValue": "供应商",
//        "memberLevelValue": "普通",
//        "registeredCapital": 10000000
//    },
//    "reply": "",
//    "linkMan": {
//        "id": 9,
//        "sort": 1,
//        "createdDate": 1545273660941,
//        "lastModifiedDate": 1546769807641,
//        "createdBy": "17721180295",
//        "lastModifiedBy": "1022768",
//        "address": "杭州",
//        "name": "赵",
//        "type": "SHAREHOLDER",
//        "email": "24556162@qq.com",
//        "sex": "男",
//        "cityName": "杭州",
//        "phone": "12345678910",
//        "duty": "部长",
//        "avatralUrl": "7a2c125404d64569abf07841d4ab8ecd",
//        "office": {
//            "id": 8,
//            "sort": 1,
//            "createdDate": 1545271514835,
//            "lastModifiedDate": 1546522068273,
//            "createdBy": "17721180295",
//            "lastModifiedBy": "18888996001",
//            "name": "总裁办",
//            "member": {
//                "id": 199,
//                "sort": 1,
//                "createdDate": 1545101062721,
//                "lastModifiedDate": 1546863303484,
//                "createdBy": "system",
//                "lastModifiedBy": "1022768",
//                "statusValue": "普通",
//                "statusKey": "ordinary",
//                "crmNumber": "200193",
//                "simpleSpell": "fsyz",
//                "office": {
//                    "id": 59,
//                    "sort": 200,
//                    "createdDate": 1544544000000,
//                    "lastModifiedDate": 1546513991814,
//                    "createdBy": "13901565517",
//                    "lastModifiedBy": "13901565517",
//                    "name": "销售部(Z)",
//                    "oaDepartmentId": "260"
//                },
//                "sapNumber": "200193",
//                "abbreviation": "佛山雅卓",
//                "orgName": "佛山市禅城区雅卓文具劳保商场",
//                "arOperatorName": "涂曦",
//                "frOperatorName": "董志勇",
//                "srOperatorName": "张善淋",
//                "creditLevelValue": "AAA",
//                "riskLevelValue": "高危",
//                "cooperationTypeValue": "供应商",
//                "memberLevelValue": "普通",
//                "registeredCapital": 10000000
//            }
//        },
//        "provinceName": "浙江"
//    },
//    "needFeedBack": true,
//    "desp": "新需求"
//}

NS_ASSUME_NONNULL_END
