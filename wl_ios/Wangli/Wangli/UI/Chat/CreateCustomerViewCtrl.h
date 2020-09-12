//
//  CreateCustomerViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/11.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface CreateCustomerViewCtrl : BaseViewCtrl

@end

//
//{
////    "areaName": "东城区",
////    "cooperationTypeValue": "二级分销商",
//    "firstDistributor": {
//        "id": 18158,
//        "orgName": "山西光谱"
//    },
////    "exclusiveShopNumber": "3668",
////    "storeNumber": "967",
////    "faxNumber": "45",
//    "memberLevelKey": "ordinary",
////    "cooperationTypeKey": "two_level_distributor",
////    "provinceName": "北京市",
////    "provinceNumber": "110000",
////    "registeredCapital": "100",
//    "listing": "false",
//    "fromClientType": "ios",
////    "afterSalesNumber": "965",
//    "memberLevelValue": "普通",
////    "areaNumber": "110101",
////    "cityNumber": "110100",
//    "creditLevelValue": "A",
//    "creditLevelKey": "A",
////    "cityName": "市辖区",
////    "orgName": "借你",
////    "legalName": "k k"
//}
//
//{
////    "storeNumber": "566",
////    "orgName": "fyhh",
////    "cityNumber": "330100",
////    "areaNumber": "330108",
////    "bail": "否",
////    "afterSalesNumber": "965",
////    "cooperationTypeKey": "two_level_distributor",
////    "legalName": "hjj",
////    "exclusiveShopNumber": "866",
////    "cityName": "杭州市",
////    "areaName": "滨江区",
////    "registeredCapital": "10",
//    "firstDistributor": {
//        "id": 18155
//    },
////    "provinceNumber": "330000",
////    "faxNumber": "45",
////    "provinceName": "浙江省",
////    "cooperationTypeValue": "二级分销商"
//}
//
//
//{
//    "content": [{
//        "title": "账户信息",
//        "data": [{
//            "leftContent": "客户名称",
//            "rightContent": "",
//            "field": "orgName",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "客户编码",
//            "rightContent": "",
//            "field": "crmNumber",
//            "change": false,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "SAP编码",
//            "rightContent": "",
//            "field": "sapNumber",
//            "change": false,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "法人姓名",
//            "rightContent": "",
//            "field": "legalName",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "一级经销商",
//            "rightContent": "",
//            "field": "firstDistributor",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "客户状态",
//            "rightContent": "",
//            "field": "statusValue",
//            "change": false,
//            "url": null,
//            "dictField": "member_status"
//        }, {
//            "leftContent": "地区",
//            "rightContent": "",
//            "field": "region",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "客户等级",
//            "rightContent": "",
//            "field": "memberLevelValue",
//            "change": true,
//            "url": null,
//            "dictField": "member_level"
//        }, {
//            "leftContent": "客户类型",
//            "rightContent": "",
//            "field": "cooperationTypeValue",
//            "change": true,
//            "url": null,
//            "dictField": "cooperation_type"
//        }, {
//            "leftContent": "信用等级",
//            "rightContent": "",
//            "field": "creditLevelValue",
//            "change": true,
//            "url": null,
//            "dictField": "credit_level"
//        }, {
//            "leftContent": "注册资金(万元)",
//            "rightContent": "",
//            "field": "registeredCapital",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "传真号码",
//            "rightContent": "",
//            "field": "faxNumber",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "售后号码",
//            "rightContent": "",
//            "field": "afterSalesNumber",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "门店数量",
//            "rightContent": "",
//            "field": "storeNumber",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "专卖店数量",
//            "rightContent": "",
//            "field": "exclusiveShopNumber",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }],
//        "attachments": null
//    }, {
//        "title": "业务信息",
//        "data": [{
//            "leftContent": "开票税号",
//            "rightContent": "",
//            "field": "taxNumber",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "开户行",
//            "rightContent": "",
//            "field": "accountBank",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "注册地址",
//            "rightContent": "",
//            "field": "registeredAddress",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "市场保证金到账",
//            "rightContent": "",
//            "field": "marketBail",
//            "change": true,
//            "url": null,
//            "dictField": "member_listing"
//        }, {
//            "leftContent": "考核协议是否签订",
//            "rightContent": "",
//            "field": "assessmentAgreement",
//            "change": true,
//            "url": null,
//            "dictField": "member_listing"
//        }, {
//            "leftContent": "业务员",
//            "rightContent": "",
//            "field": "operatorName",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "品牌",
//            "rightContent": "",
//            "field": "brandNames",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "市场保证金金额",
//            "rightContent": "",
//            "field": "marketBailQuentity",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "保证金是否到账",
//            "rightContent": "",
//            "field": "bail",
//            "change": true,
//            "url": null,
//            "dictField": "member_listing"
//        }, {
//            "leftContent": "联系电话",
//            "rightContent": "",
//            "field": "companyPhone",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "目标量",
//            "rightContent": "",
//            "field": "targetQuantity",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "增长率",
//            "rightContent": "",
//            "field": "growthRate",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }, {
//            "leftContent": "年目标完成率",
//            "rightContent": "",
//            "field": "annualTargetCompletionRate",
//            "change": true,
//            "url": null,
//            "dictField": null
//        }],
//        "attachments": null
//    }]
//}
