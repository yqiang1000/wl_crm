//
//  CreateTravelViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/5/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"
#import "TravelMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateTravelViewCtrl : CommonAutoViewCtrl

@property (nonatomic, strong) TravelMo *travelMo;

@end

NS_ASSUME_NONNULL_END

//[{
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "DATE_SELECT",
//    "index": 1,
//    "leftContent": "出差日期",
//    "rightContent": "请选择",
//    "key": "travelDate",
//    "value": "2019-07-08",
//    "pattern": "yyyy-MM-dd"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "DATE_SELECT",
//    "index": 2,
//    "leftContent": "结束日期",
//    "rightContent": "请选择",
//    "key": "endDate",
//    "value": "2019-07-09",
//    "pattern": "yyyy-MM-dd"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 3,
//    "leftContent": "计划出差地",
//    "rightContent": "请输入",
//    "key": "plannedBusinessTrip",
//    "value": "上海",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 4,
//    "leftContent": "出发地",
//    "rightContent": "请输入",
//    "key": "placeDeparture",
//    "value": "杭州",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 5,
//    "leftContent": "到达地",
//    "rightContent": "请输入",
//    "key": "placeArrival",
//    "value": "上海",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 6,
//    "leftContent": "报销地城市",
//    "rightContent": "请输入",
//    "key": "reimbursementCity",
//    "value": "杭州",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 7,
//    "leftContent": "火车/高铁/飞机交通费",
//    "rightContent": "请输入",
//    "key": "hgfTransport",
//    "value": "50",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 8,
//    "leftContent": "客车交通费",
//    "rightContent": "请输入",
//    "key": "kcTransport",
//    "value": "20",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 9,
//    "leftContent": "无实名交通费",
//    "rightContent": "请输入",
//    "key": "noRealNameTransport",
//    "value": "10",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 10,
//    "leftContent": "无实名备注",
//    "rightContent": "请输入",
//    "key": "noRealNameRemark",
//    "value": "无",
//    "inputType": "LONG_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_OPERATOR",
//    "index": 11,
//    "leftContent": "同住人员",
//    "rightContent": "必填",
//    "key": "cohabitOperator",
//    "value": {
//        "createdBy": null,
//        "createdDate": "2019-07-12 16:37:48",
//        "lastModifiedBy": null,
//        "lastModifiedDate": "2019-07-12 16:37:48",
//        "id": 1544,
//        "deleted": false,
//        "sort": 10,
//        "fromClientType": null,
//        "optionGroup": [],
//        "searchContent": null,
//        "oaCode": null,
//        "oaId": null,
//        "username": null,
//        "activated": false,
//        "name": "刘仲平",
//        "nameFullPinyin": null,
//        "nameShortPinyin": null,
//        "telOne": null,
//        "telTwo": null,
//        "telThree": null,
//        "address": null,
//        "email": null,
//        "sex": null,
//        "birthday": null,
//        "superiorOperator": null,
//        "superiorIdChain": null,
//        "department": null,
//        "departmentName": null,
//        "position": null,
//        "avatarUrl": null,
//        "title": null,
//        "oaJobtitle": null,
//        "oaSubCompany": null,
//        "status": null,
//        "lastLoginDate": null,
//        "previousLoginDate": null,
//        "timIdentifier": null,
//        "sapCode": null,
//        "sapCname": null,
//        "osfaoo3r": null,
//        "roles": null,
//        "officeOrderApprovalConfigs": null,
//        "signInRecords": null,
//        "assistDepartmentSet": null,
//        "province": null,
//        "brand": null,
//        "firstBrand": null
//    },
//    "mutiAble": false
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 12,
//    "leftContent": "住宿发票金额",
//    "rightContent": "请输入",
//    "key": "stayInvoiceAmount",
//    "value": "100",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 13,
//    "leftContent": "住宿报销标准",
//    "rightContent": "请输入",
//    "key": "stayReimbursementStandard",
//    "value": "100",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 14,
//    "leftContent": "住宿报销金额",
//    "rightContent": "请输入",
//    "key": "stayReimbursementAmount",
//    "value": "400",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 15,
//    "leftContent": "市内交通发票金额",
//    "rightContent": "请输入",
//    "key": "cityTrafficInvoiceAmount",
//    "value": "20",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 16,
//    "leftContent": "市内交通报销标准",
//    "rightContent": "请输入",
//    "key": "cityTrafficReimbursementStandard",
//    "value": "20",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 17,
//    "leftContent": "市内交通报销金额",
//    "rightContent": "请输入",
//    "key": "cityTrafficReimbursementAmount",
//    "value": "20",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 18,
//    "leftContent": "餐费补助",
//    "rightContent": "请输入",
//    "key": "mealAllowance",
//    "value": "50",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": false,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 19,
//    "leftContent": "出差餐费",
//    "rightContent": "请输入",
//    "key": "mealBusinessTrip",
//    "value": "50",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 20,
//    "leftContent": "其他费用",
//    "rightContent": "请输入",
//    "key": "otherExpenses",
//    "value": "50",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDOUBLE"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 21,
//    "leftContent": "备注",
//    "rightContent": "请输入",
//    "key": "remark",
//    "value": "无",
//    "inputType": "LONG_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "INPUT_TEXT",
//    "index": 22,
//    "leftContent": "酒店名称",
//    "rightContent": "请输入",
//    "key": "hotel",
//    "value": "如家",
//    "inputType": "SHORT_TEXT",
//    "keyBoardType": "KBDEFAULT"
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "K_INPUT_TOGGLEBUTTON",
//    "index": 23,
//    "leftContent": "是否提交到OA",
//    "rightContent": "",
//    "key": "commit",
//    "value": true
//}, {
//    "nullAble": true,
//    "editAble": true,
//    "rowType": "FILE_INPUT",
//    "index": 24,
//    "leftContent": "附件",
//    "rightContent": "请选择",
//    "key": "attachments",
//    "value": [{
//        "createdBy": "guanliyuan",
//        "createdDate": "2019-07-08 11:00:10",
//        "lastModifiedBy": "wlm120118",
//        "lastModifiedDate": "2019-07-10 10:58:32",
//        "id": 48,
//        "deleted": false,
//        "sort": 10,
//        "fromClientType": null,
//        "optionGroup": [],
//        "searchContent": null,
//        "fkType": "TRAVEL_BUSINESS",
//        "fkId": 55,
//        "qiniuKey": "244338c84fc14fdcb3a681a6810c6909",
//        "fileName": "1562554781784photo.jpeg",
//        "fileType": "jpeg",
//        "sizeOfByte": 56167,
//        "fileSize": "54KB",
//        "url": null,
//        "thumbnail": null,
//        "key": null,
//        "fkTypeValue": "差旅管理和报销",
//        "extData": null
//    }]
//}]
