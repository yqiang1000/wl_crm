//
//  CreateStoreViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/6/29.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"
#import "StoreMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateStoreViewCtrl : CommonAutoViewCtrl

@property (nonatomic, strong) StoreMo *storeMo;

@end

NS_ASSUME_NONNULL_END

//{
//    "vtext1": null,
//    "orto1": null,
//    "storeNumber": 15,
//    "cityNumber": "321300",
//    "zterm": null,
//    "bail": "",
//    "operator": "oper",
//    "erdat": null,
//    "aufsd": null,
//    "legalName": "应那",
//    "accountBank": "",
//    "registeredAddress": "",
//    "areaName": "沭阳县",
//    "companyPhone": "0577-88888888",
//    "statusKey": "potential",
//    "provinceNumber": "320000",
//    "id": 362,
//    "orgName": "浙江王力门业有限责任公司",
//    "creditLevelKey": "A",
//    "avatarUrl": null,
//    "areaNumber": "321322",
//    "stras": null,
//    "taxNumber": "",
//    "marketBailQuentity": "",
//    "businessScope": null,
//    "faksd": null,
//    "sort": 10,
//    "afterSalesNumber": "12313123",
//    "labels": [],
//    "superiorChain": null,
//    "firstDistributor": {
//        "storeNumber": 1,
//        "cityNumber": "451400",
//        "bail": "",
//        "operator": {
//            "departmentName": null,
//            "lastModifiedDate": "2019-06-28 16:00:17",
//            "avatarUrl": null,
//            "lastModifiedBy": "许仁杰",
//            "sort": 10,
//            "title": "员工",
//            "createdDate": "2019-05-13 15:29:05",
//            "province": [
//                         {
//                             "provinceName": "广西",
//                             "id": 20,
//                             "provinceId": "450000"
//                         },
//                         {
//                             "provinceName": "海南",
//                             "id": 21,
//                             "provinceId": "460000"
//                         }
//                         ],
//            "createdBy": "管理员",
//            "name": "许仁杰",
//            "id": 502,
//            "department": {
//                "desp": null,
//                "createdDate": "2019-04-04 15:01:15",
//                "lastModifiedDate": "2019-05-14 15:09:12",
//                "createdBy": "管理员",
//                "lastModifiedBy": "管理员",
//                "name": "能诚营销事业部",
//                "oaDepartmentId": null,
//                "id": 111,
//                "sort": 10
//            },
//            "brand": [
//                      {
//                          "brandName": "能诚",
//                          "createdDate": "2019-04-09 14:08:12",
//                          "brandDesc": "能诚",
//                          "lastModifiedDate": "2019-04-09 14:08:17",
//                          "createdBy": "管理员",
//                          "lastModifiedBy": "管理员",
//                          "id": 4,
//                          "sort": 0
//                      }
//                      ],
//            "oaId": null,
//            "oaCode": "XC011932",
//            "username": "XC011932"
//        },
//        "legalName": "有意义啊",
//        "accountBank": "",
//        "registeredAddress": "",
//        "areaName": "凭祥市",
//        "companyPhone": "",
//        "statusKey": "potential",
//        "provinceNumber": "450000",
//        "id": 361,
//        "orgName": "有意义",
//        "creditLevelKey": "A",
//        "avatarUrl": null,
//        "areaNumber": "451481",
//        "taxNumber": "",
//        "marketBailQuentity": "",
//        "businessScope": null,
//        "sort": 10,
//        "afterSalesNumber": "1",
//        "superiorChain": null,
//        "provinceName": "广西",
//        "cooperationTypeValue": "二级分销商",
//        "region": null,
//        "targetQuantity": null,
//        "assessmentAgreement": "",
//        "crmNumber": "WL20190626004",
//        "statusValue": "潜在",
//        "growthRate": null,
//        "creditLevelValue": "A",
//        "sapNumber": null,
//        "operatorName": "许仁杰",
//        "cooperationTypeKey": "two_level_distributor",
//        "exclusiveShopNumber": 1,
//        "memberLevelValue": "普通",
//        "firstDistributorName": "钦州市钦南区欣泽门类经营部",
//        "cityName": "崇左市",
//        "registeredCapital": 100000,
//        "simpleSpell": "yyy",
//        "natureManagement": null,
//        "createdOperatorName": "许仁杰",
//        "faxAreaCode": "1234",
//        "lastModifiedDate": "2019-06-26 15:12:10",
//        "lastModifiedBy": "许仁杰",
//        "abbreviation": null,
//        "faxPhoneNumber": "123456",
//        "marketBail": "",
//        "brandNames": "",
//        "createdDate": "2019-06-26 15:12:10",
//        "createdBy": "许仁杰",
//        "companyAddress": "",
//        "memberLevelKey": "ordinary",
//        "annualTargetCompletionRate": null
//    },
//    "land1": null,
//    "lifsd": null,
//    "kkber": null,
//    "provinceName": "江苏",
//    "cooperationTypeValue": "二级分销商",
//    "ztag1": null,
//    "region": null,
//    "vkorg": null,
//    "ztag3": null,
//    "ztag2": null,
//    "targetQuantity": null,
//    "assessmentAgreement": "",
//    "cassd": null,
//    "crmNumber": "WL20190626005",
//    "statusValue": "潜在",
//    "growthRate": null,
//    "creditLevelValue": "A",
//    "sapNumber": null,
//    "vtextf": null,
//    "operatorName": "刘鹏城",
//    "regio": null,
//    "cooperationTypeKey": "two_level_distributor",
//    "exclusiveShopNumber": 1,
//    "memberLevelValue": "普通",
//    "firstDistributorName": "有意义",
//    "cityName": "宿迁市",
//    "registeredCapital": 40000,
//    "simpleSpell": "zjwlmyyxzrgs",
//    "linkMans": [],
//    "natureManagement": null,
//    "vtextx": null,
//    "createdOperatorName": "刘鹏城",
//    "faxAreaCode": "2344",
//    "sperr": null,
//    "brands": [],
//    "lastModifiedDate": "2019-06-28 17:28:05",
//    "lastModifiedBy": "汪蠡",
//    "memberAssists": [],
//    "abbreviation": null,
//    "faxPhoneNumber": "231244",
//    "vtweg": null,
//    "spart": null,
//    "bezei": null,
//    "marketBail": "",
//    "brandNames": "",
//    "landx": null,
//    "knkli": null,
//    "createdDate": "2019-06-26 15:14:09",
//    "createdBy": "刘鹏城",
//    "companyAddress": "",
//    "faxNumber": "2344-231244",
//    "memberLevelKey": "ordinary",
//    "annualTargetCompletionRate": null,
//    "pstlz": null
//}


//[{
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_TITLE",
//    "index": 1,
//    "leftContent": "经营范围",
//    "rightContent": "",
//    "key": null,
//    "value": null
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_MEMBER",
//    "index": 2,
//    "leftContent": "客户",
//    "rightContent": "请选择",
//    "key": "customer",
//    "value": null,
//    "mutiAble": false
//}, {
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_SELECT",
//    "index": 3,
//    "leftContent": "省份",
//    "rightContent": "自动带出",
//    "key": "province",
//    "value": null,
//    "mutiAble": false,
//    "dictName": ""
//}, {
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_SELECT",
//    "index": 4,
//    "leftContent": "地区",
//    "rightContent": "自动带出",
//    "key": "city",
//    "value": null,
//    "mutiAble": false,
//    "dictName": ""
//}, {
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_SELECT",
//    "index": 5,
//    "leftContent": "县镇级或地辖区网点",
//    "rightContent": "自动带出",
//    "key": "area",
//    "value": null,
//    "mutiAble": false,
//    "dictName": ""
//}, {
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_TITLE",
//    "index": 6,
//    "leftContent": "经销商信息",
//    "rightContent": "",
//    "key": null,
//    "value": null
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_BRAND_SELECT",
//    "index": 7,
//    "leftContent": "经营品牌",
//    "rightContent": "请选择",
//    "key": "brandName",
//    "value": null,
//    "mutiAble": true
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 8,
//    "leftContent": "对公户",
//    "rightContent": "请输入",
//    "key": "forPublicHouseholds",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 9,
//    "leftContent": "联系电话",
//    "rightContent": "请输入",
//    "key": "contactNumber",
//    "value": null,
//    "inputType": "PHONE_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 10,
//    "leftContent": "传真号码",
//    "rightContent": "请输入",
//    "key": "faxNumber",
//    "value": null,
//    "inputType": "PHONE_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 11,
//    "leftContent": "售后电话",
//    "rightContent": "请输入",
//    "key": "afterSalesCall",
//    "value": null,
//    "inputType": "PHONE_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": false,
//    "rowType": "INPUT_TITLE",
//    "index": 12,
//    "leftContent": "门店经营状况",
//    "rightContent": "",
//    "key": null,
//    "value": null
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 13,
//    "leftContent": "门店名称",
//    "rightContent": "必填",
//    "key": "storeName",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 14,
//    "leftContent": "门店地址",
//    "rightContent": "必填",
//    "key": "storeAddress",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "K_INPUT_TOGGLEBUTTON",
//    "index": 15,
//    "leftContent": "是否专卖",
//    "rightContent": "",
//    "key": "whetherToMonopolize",
//    "value": null
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 16,
//    "leftContent": "店面面积",
//    "rightContent": "必填",
//    "key": "storeArea",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 17,
//    "leftContent": "样品门数量",
//    "rightContent": "必填",
//    "key": "numberOfSampleDoors",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBINTEGER"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 18,
//    "leftContent": "样品门款式",
//    "rightContent": "必填",
//    "key": "sampleDoorStyle",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 19,
//    "leftContent": "本月基本款符合情况、样品质量情况",
//    "rightContent": "请输入",
//    "key": "qualitySituation",
//    "value": null,
//    "inputType": "LONG_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 20,
//    "leftContent": "对比销售道具情况",
//    "rightContent": "必填",
//    "key": "compareSalesItems",
//    "value": null,
//    "inputType": "LONG_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 21,
//    "leftContent": "本月小区活动情况",
//    "rightContent": "请输入",
//    "key": "communityActivityThisMonth",
//    "value": null,
//    "inputType": "LONG_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 22,
//    "leftContent": "导购员数量",
//    "rightContent": "必填",
//    "key": "numberOfGuides",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBINTEGER"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 23,
//    "leftContent": "进店量",
//    "rightContent": "请输入",
//    "key": "intoTheStore",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBINTEGER"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 24,
//    "leftContent": "零售量",
//    "rightContent": "请输入",
//    "key": "retailVolume",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 25,
//    "leftContent": "发货量",
//    "rightContent": "请输入",
//    "key": "shipment",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 26,
//    "leftContent": "成交率",
//    "rightContent": "请输入",
//    "key": "turnoverRate",
//    "value": null,
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "FILE_INPUT",
//    "index": 27,
//    "leftContent": "门店图片",
//    "rightContent": "请选择",
//    "key": "attachmentList",
//    "value": null
//}]


//{
//    "vtext1": null,
//    "orto1": "株洲市",
//    "storeNumber": null,
//    "cityNumber": null,
//    "zterm": null,
//    "bail": null,
//    "operator": null,
//    "erdat": "2019-07-12",
//    "aufsd": "",
//    "legalName": "贺叶平",
//    "accountBank": null,
//    "registeredAddress": null,
//    "areaName": null,
//    "companyPhone": null,
//    "statusKey": "formal",
//    "provinceNumber": "430000",
//    "id": 17937,
//    "orgName": "湖南龙响新型材料有限公司",
//    "creditLevelKey": "A",
//    "avatarUrl": null,
//    "areaNumber": null,
//    "stras": "金山街道太阳村上老虎冲组028号",
//    "taxNumber": null,
//    "marketBailQuentity": null,
//    "businessScope": "组件",
//    "faksd": "",
//    "sort": 10,
//    "afterSalesNumber": null,
//    "labels": [],
//    "superiorChain": null,
//    "firstDistributor": null,
//    "land1": "CN",
//    "lifsd": "",
//    "kkber": null,
//    "provinceName": "湖南",
//    "cooperationTypeValue": "直销客户",
//    "ztag1": null,
//    "region": null,
//    "vkorg": null,
//    "ztag3": null,
//    "ztag2": null,
//    "targetQuantity": null,
//    "assessmentAgreement": null,
//    "cassd": "",
//    "crmNumber": "2913269",
//    "statusValue": "正式",
//    "growthRate": null,
//    "creditLevelValue": "A",
//    "sapNumber": "2913269",
//    "vtextf": null,
//    "operatorName": "未分配",
//    "regio": "160",
//    "cooperationTypeKey": "straight_pin",
//    "exclusiveShopNumber": null,
//    "memberLevelValue": "普通",
//    "firstDistributorName": null,
//    "cityName": null,
//    "registeredCapital": null,
//    "simpleSpell": "hnlxxxclyxgs",
//    "linkMans": [],
//    "natureManagement": null,
//    "vtextx": null,
//    "createdOperatorName": null,
//    "faxAreaCode": null,
//    "sperr": null,
//    "brands": [],
//    "lastModifiedDate": "2019-07-12 18:01:11",
//    "lastModifiedBy": "系统自动创建",
//    "memberAssists": [],
//    "abbreviation": null,
//    "faxPhoneNumber": null,
//    "vtweg": null,
//    "spart": null,
//    "bezei": "湖南",
//    "marketBail": null,
//    "brandNames": null,
//    "landx": "中国",
//    "knkli": null,
//    "createdDate": "2019-07-12 18:01:11",
//    "createdBy": "系统自动创建",
//    "companyAddress": null,
//    "faxNumber": null,
//    "memberLevelKey": "ordinary",
//    "annualTargetCompletionRate": null,
//    "pstlz": "412000"
//}

//{
//    "id": "",
//    "provinceId": 12,
//    "provinceName": "安徽",
//    "cityId": null,
//    "cityName": null,
//    "areaId": null,
//    "areaName": null,
//    "customerCode": 17835,
//    "customerName": "阜南县王堰镇心悦装饰店",
//    "brandId": "6-5-",
//    "brandName": "舒格拉蒂 王力 ",
//    "forPublicHouseholds": "阜南县王堰镇心悦装饰店",
//    "contactNumber": "110",
//    "faxNumber": "120",
//    "afterSalesCall": "199",
//    "storeName": "杭州门店",
//    "storeAddress": "东软",
//    "whetherToMonopolize": false,
//    "storeArea": "19",
//    "numberOfSampleDoors": "3",
//    "sampleDoorStyle": "8",
//    "qualitySituation": "符合",
//    "compareSalesItems": "零号",
//    "communityActivityThisMonth": "良好",
//    "numberOfGuides": "4",
//    "intoTheStore": "87",
//    "retailVolume": "65",
//    "shipment": "34",
//    "turnoverRate": "7",
//    "attachmentList": [{
//        "createdBy": "guanliyuan",
//        "createdDate": "2019-07-15 20:49:32",
//        "lastModifiedBy": "guanliyuan",
//        "lastModifiedDate": "2019-07-15 20:49:32",
//        "id": 98,
//        "deleted": false,
//        "sort": 10,
//        "fromClientType": null,
//        "optionGroup": [],
//        "searchContent": null,
//        "fkType": "DEFAULT",
//        "fkId": 0,
//        "qiniuKey": "169de8b4615f470abdcbf14cca9b0d54",
//        "fileName": "WX20190715-164602@2x.png",
//        "fileType": "png",
//        "sizeOfByte": 1100041,
//        "fileSize": "1074KB",
//        "url": null,
//        "thumbnail": null,
//        "key": null,
//        "fkTypeValue": "默认",
//        "extData": null
//    }]
//}
