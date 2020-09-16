//
//  URLConfig.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwitchUrlUtil.h"

//#if DEBUG
//
#define DOMAIN_NAME                     @"http://uat-crm.chinawangli.com:9090%@"
#define H5_URL                          @"http://uat-crm.chinawangli.com:9098/#"

#define CREATE_ORDER_URL                @"http://uat-crm.chinawangli.com:9098/#/orderonline?"
#define ORDER_LIST_URL                  @"http://uat-crm.chinawangli.com:9098/#/orderlist?"
#define ORDER_DETAIL_URL                @"http://uat-crm.chinawangli.com:9098/#/orderHelper?"
#define TASK_DETAIL_URL                 @"http://uat-crm.chinawangli.com:9098/#/task-detail?"
#define TASK_REMIND_URL                 @"http://uat-crm.chinawangli.com:9098/#/remindtask?"
#define TASK_HANDLE_URL                 @"http://uat-crm.chinawangli.com:9098/#/handletask?"
#define FOREIGN_URL                     @"http://uat-crm.chinawangli.com:9098/#/foreignorder?"
#define NOTICE_URL                      @"http://uat-crm.chinawangli.com:9098/#/policynotice?"
#define CREDIT_URL                      @"http://uat-crm.chinawangli.com:9098/#/creditArrears?"
#define BARCODE_SEARCH                  @"http://uat-crm.chinawangli.com:9098/#/barcodeSearch?"
#define TRACKING_TRANSACTION            @"http://uat-crm.chinawangli.com:9098/#/transactionTracking?"
#define CLERRK_360                      @"http://uat-crm.chinawangli.com:9098/#/clerk360?"
#define VISIT_RECEPTION_DETAIL          @"http://uat-crm.chinawangli.com:9098/#/customer-reception-detail?"

//#else

//#define DOMAIN_NAME                     @"http://crm.chinawangli.com:9096%@"
//#define H5_URL                          @"http://crm.chinawangli.com:9098/#"
//
//#define CREATE_ORDER_URL                @"http://crm.chinawangli.com:9098/#/orderonline?"
//#define ORDER_LIST_URL                  @"http://crm.chinawangli.com:9098/#/orderlist?"
//#define ORDER_DETAIL_URL                @"http://crm.chinawangli.com:9098/#/orderHelper?"
//#define TASK_DETAIL_URL                 @"http://crm.chinawangli.com:9098/#/task-detail?"
//#define TASK_REMIND_URL                 @"http://crm.chinawangli.com:9098/#/remindtask?"
//#define TASK_HANDLE_URL                 @"http://crm.chinawangli.com:9098/#/handletask?"
//#define FOREIGN_URL                     @"http://crm.chinawangli.com:9098/#/foreignorder?"
//#define NOTICE_URL                      @"http://crm.chinawangli.com:9098/#/policynotice?"
//#define CREDIT_URL                      @"http://crm.chinawangli.com:9098/#/creditArrears?"
//#define BARCODE_SEARCH                  @"http://crm.chinawangli.com:9098/#/barcodeSearch?"
//#define TRACKING_TRANSACTION            @"http://crm.chinawangli.com:9098/#/transactionTracking?"
//#define CLERRK_360                      @"http://crm.chinawangli.com:9098/#/clerk360?"
//#define VISIT_RECEPTION_DETAIL          @"http://crm.chinawangli.com:9098/#/customer-reception-detail?"


//#endif

// H5地址
/** 情报消息的跳转url */
#define H5_INTELLIGENCE_URL @"/intelligence-item-detail?id="

/** 市场活动消息跳转的url */
#define H5_MARKET_ACTIVITY_URL @"/market-activity-detail?id="

/** 线索消息跳转的url */
#define H5_CLUE_URL @"/clue-detail?id="

/** 商机消息跳转的url */
#define H5_BUSINESS_CHANCE_URL @"/business-chance-detail?id="

/** 送样申请消息跳转的url */
#define H5_SAMPLE_URL @"/sample-detail?id="

/** 报价消息跳转的url */
#define H5_QUOTED_PRICE_URL @"/quoted-price-detail?id="

/** 合同消息的跳转url */
#define H5_CONTRACT_URL @"/contract-details?id="

/** 订单消息的跳转url */
#define H5_ORDER_URL @"/order-detail?id="

/** 收款的跳转url */
#define H5_RECEIPT_URL @"/receipt-detail?id="


/** 日报消息的跳转url */
#define H5_AR_DAILY_URL @"/ar-daily?id="
/** 日报消息的跳转url */
#define H5_SR_DAILY_URL @"/sr-daily?id="
/** 日报消息的跳转url */
#define H5_FR_DAILY_URL @"/fr-daily?id="



#define USER_SELF_INFO                          @"/api/user/info"


#define LOGIN                                   @"/api/authenticate"
#define GET_USER_SIGN                           @"/api/tim/sig/"
#define GET_SMS_CODE                            @"/api/sms/login-sms/"
#define GET_CUSTOMER_LIST_PC                    @"/api/member/page"
#define GET_CUSTOMER_LIST                       @"/api/member/find-page"
#define GET_MEMBER_SEND_ABLE_LIST               @"/api/member/send_able/"
#define GET_MEMBER_FIND_LIST                    @"/api/member/find_member_list"
#define GET_COMPANY_DEPARTMENT                  @"/api/department/page"
#define GET_COMPANY_PEOPLE                      @"/api/operator/page?"
#define GET_PEOPLE_PAGE                         @"/api/operator/page"
//#define GET_IMPORT_PERSON                       @"/api/contact/find_list_by_operator/"
#define GET_IMPORT_PERSON                       @"/api/link-man/page"
#define GET_TASK_COLLABORATOR                   @"/api/operator/task-collaborator"
#define GET_TASK_RECEIVER                       @"/api/operator/task-receiver"

// 客户相关
#define GET_MEMBER_CHOOSE                       @"/api/member/memberChoose"
#define GET_MEMBER_FIND                         @"/api/member/find/"
#define GET_MEMBER_CENTER                       @"/api/member-center/index/"
#define MEMBER_CREATE                           @"/api/member/create"
#define MEMBER_FIND_SYS_INFO                    @"/api/member/find_system_information/"
#define OPERATION_FIND_INDEX                    @"/api/operator/find_index"
#define MEMBER_RADAR_CHAT                       @"/api/member/radar_chart/"

#define FIND_INVOICE_CHART_MOBILE               @"/api/member/find-sap-invoice-chart-mobile/"

// 标签
#define LABEL_PAGE                              @"/api/label/page"
#define LABEL_ADD                               @"/api/member/label/add/"
#define LABEL_REMOVE                            @"/api/member/label/remove/"

// 升级
#define VERSION_CREATE                          @"/api/android_version_check/create"
#define VERSION_UPDATE                          @"/api/android_version_check/update"
#define VERSION_CHECK                           @"/api/android_version_check/check"

// 联系人
#define CONTACT_CREATE                          @"/api/contact/create"
#define CONTACT_UPDATE                          @"/api/contact/update"
#define CONTACT_DETAIL                          @"/api/contact/detail/"
#define CONTACT_DELETE                          @"/api/contact/delete/"
#define CONTACT_SEARCH                          @"/api/operator/search"
#define CONTACT_SEARCH_PAGE_SEND_ABLE           @"/api/contact/send_able/"

#define GET_CONTENT_PAGE                        @"/api/contact/find_page"
#define GET_ADDRESS_PAGE                        @"/api/address/page"
#define ADDRESS_CREATE                          @"/api/address/create"
#define ADDRESS_UPDATE                          @"/api/address/update"
#define ADDRESS_DELETE                          @"/api/address/delete/"
#define CHOSE_CONTENT_LIST                      @"/api/contact/list/"

// 转移释放认领
#define MEMBER_RELEASE                          @"/api/member_process/release"
#define MEMBER_CLAIM                            @"/api/member_process/claim"
#define MEMBER_TRANSFER                         @"/api/member_process/transfer"

#define OPERATOR_ASSIST_LIST                    @"/api/operator/assist_list"
// 360
#define GET_ACTUAL_PERSON_INFO                  @"/api/actual/find_read_bean/"
#define GET_MEMBER_ORG_INFO                     @"/api/member/find-read-bean/"
#define MEMBER_UPDATE                           @"/api/member/updateMessageBean"

// 人事组织
//#define LINK_MAN_OFFICE                         @"/api/link-man-office/officeVoList/"
#define LINK_MAN_OFFICE                         @"/api/link-man-office/findVoByMemberIdOfIos/"
// 信用
#define GET_CREDIT_COUNT                        @"/api/monthly-credit-count/abstract-mobile/"
#define ACCOUNT_APPLY                           @"/api/account-amount-flow/apply"
#define SAME_COMPANY_LIST                       @"/api/monthly-credit-count/same-company-list/"
#define CREDIT_HEADER                           @"/api/monthly-credit-count/abstract-knkli-header-mobile/"
#define CREDIT_FOOTER                           @"/api/monthly-credit-count/abstract-knkli-footer/"

#define CUST_DEPT_ACCOUNT                       @"/api/cust-dept-account/member_owed_same_knkli/"

// 七牛云
#define QINIU_UPLOAD_TOKEN                      @"/api/qiniu/upload-token"
#define QINIU_UPLOAD_TOKEN_OPEN                 @"/api/qiniu/upload-token-open"
// 收款计划
#define GATHERING_PLAN_CREATE                   @"/api/gathering_plan/create"
#define GATHERING_PLAN_PAGE                     @"/api/gathering_plan/page"
#define GATHERING_PLAN_UPDATE                   @"/api/gathering_plan/update"
#define GATHERING_PLAN_DELETE                   @"/api/gathering_plan/delete/"
#define GATHERING_PLAN_DETAIL                   @"/api/gathering_plan/detail/"
#define GATHERING_LINE_CHART                    @"/api/gathering_plan/find_line_chart/"
#define GATHERING_CUST_DEPT                     @"/api/member/cust-dept-account/"
#define GATHERING_PLAN_RECEIVE_COUNT            @"/api/gathering_plan/find_account_received_amount/"
// 发货计划
#define PRICE_FIND_ONE                          @"/api/price/material-member/"
#define DEMAND_PLAN_CREATE                      @"/api/demand_plan/create"
#define GET_DEMAND_PLAN_PAGE                    @"/api/demand_plan/page"
#define DEMAND_PLAN_UPDATE                      @"/api/demand_plan/update"
#define DEMAND_PLAN_DELETE                      @"/api/demand_plan/delete/"
#define DEMAND_PLAN_DETAIL                      @"/api/demand_plan/detail/"
#define DEMAND_PLAN_BATCH_WEIGHT                @"/api/batch-number-weight/page"
#define DEMAND_FIND_COLLECT                     @"/api/demand_plan/find_operator_collect"
#define DEMAND_FIND_COLLECT_TWO                 @"/api/demand_plan/find_operator_collect_two"
#define DEMAND_FIND_DETAIL                      @"/api/demand_plan/find_detail_plan"
#define DEMAND_CREATE_BY_BATCH                  @"/api/demand_plan/create_by_batch"
#define DEMAND_PRE_BATCH                        @"/api/demand_plan/pre-month-batchnumber-weight/"

// 风险
#define RISK_WARN_STATISTICS                    @"/api/risk-warn/statistics/"
#define RISK_WARN_PAGE                          @"/api/risk-warn/page"
#define RISK_WARN_CREATE                        @"/api/risk-warn/create"
#define RISK_WARN_UPDATE                        @"/api/risk-warn/update"
#define RISK_WARN_DETAIL                        @"/api/risk-warn/detail/"
#define RISK_WARN_DELETE                        @"/api/market-trend/delete-feed/"
// feed流
#define FEED_FLOW_PAGE                          @"/api/feed-flow/page"
// 市场动态
#define MARKET_TREND_PAGE                       @"/api/market-trend/page"
#define MARKET_TREND_STATISTICS                 @"/api/market-trend/statistics/"
#define MARKET_TREND_CREATE                     @"/api/market-trend/create"
#define MARKET_TREND_UPDATE                     @"/api/market-trend/update"
#define MARKET_TREND_DELETE                     @"/api/market-trend/delete-feed/"
#define MARKET_TREND_DETAIL                     @"/api/market-trend/detail/"
#define CUSTOMER_COMPLAINTS_CREATE              @"/api/customer-complaints/create"
// 生产状况
#define PRODUCT_SITUATION                       @"/api/product/situation/"
// 产品信息
#define PRODUCT_CREATE                          @"/api/product/create"
#define PRODUCT_UPDATE                          @"/api/product/update"
#define PRODUCT_DELETE                          @"/api/product/delete/"
#define PRODUCT_PAGE                            @"/api/product/page"
#define PRODUCT_DETAIL                          @"/api/product/detail/"
// 工厂设备
#define EQUIPMENT_CREATE                        @"/api/equipment/create"
#define EQUIPMENT_UPDATE                        @"/api/equipment/update"
#define EQUIPMENT_DELETE                        @"/api/equipment/delete/"
#define EQUIPMENT_PAGE                          @"/api/equipment/page"
#define EQUIPMENT_DETAIL                        @"/api/equipment/detail/"
#define LIST_REMARK                             @"/api/dict/list-remark/"
#define EQUIPMENT_TOTAL_COUNT                   @"/api/equipment/equipment-total/"
// 生产动态
#define PERFORMANCE_CREATE                      @"/api/performance/create"
#define PERFORMANCE_DELETE                      @"/api/performance/delete/"
#define PERFORMANCE_UPDATE                      @"/api/performance/update"
#define PERFORMANCE_PAGE                        @"/api/performance/page"
#define PERFORMANCE_DETAIL                      @"/api/performance/detail/"
// 原料信息
#define ROW_MATERIAL_CREATE                     @"/api/row_material/create"
#define ROW_MATERIAL_DELETE                     @"/api/row_material/delete/"
#define ROW_MATERIAL_UPDATE                     @"/api/row_material/update"
#define ROW_MATERIAL_PAGE                       @"/api/row_material/page"
#define ROW_MATERIAL_DETAIL                     @"/api/row_material/detail/"
// 竞品信息
#define COMPETITION_CREATE                      @"/api/competition_product/create"
#define COMPETITION_DELETE                      @"/api/competition_product/delete/"
#define COMPETITION_UPDATE                      @"/api/competition_product/update"
#define COMPETITION_PAGE                        @"/api/competition_product/page"
#define COMPETITION_DETAIL                      @"/api/competition_product/detail/"
// 工厂招工
#define RECRUITMENT_CREATE                      @"/api/recruitment/create"
#define RECRUITMENT_DELETE                      @"/api/recruitment/delete/"
#define RECRUITMENT_UPDATE                      @"/api/recruitment/update"
#define RECRUITMENT_PAGE                        @"/api/recruitment/page"
#define RECRUITMENT_DETAIL                      @"/api/recruitment/detail/"
// 采购招标
#define PRUCHASE_CREATE                         @"/api/purchase_tender/create"
#define PRUCHASE_DELETE                         @"/api/purchase_tender/delete/"
#define PRUCHASE_UPDATE                         @"/api/purchase_tender/update"
#define PRUCHASE_PAGE                           @"/api/purchase_tender/page"
#define PRUCHASE_DETAIL                         @"/api/purchase_tender/detail/"
// 进出口信息
#define PORT_INFO_CREATE                        @"/api/in_ex_port_info/create"
#define PORT_INFO_DELETE                        @"/api/in_ex_port_info/delete/"
#define PORT_INFO_UPDATE                        @"/api/in_ex_port_info/update"
#define PORT_INFO_PAGE                          @"/api/in_ex_port_info/page"
#define PORT_INFO_DETAIL                        @"/api/in_ex_port_info/detail/"
// 生产许可
#define LICENSE_CREATE                          @"/api/production_license/create"
#define LICENSE_DELETE                          @"/api/production_license/delete/"
#define LICENSE_UPDATE                          @"/api/production_license/update"
#define LICENSE_PAGE                            @"/api/production_license/page"
#define LICENSE_DETAIL                          @"/api/production_license/detail/"
// 税务评级
#define TAX_RATING_CREATE                       @"/api/tax_rating/create"
#define TAX_RATING_DELETE                       @"/api/tax_rating/delete/"
#define TAX_RATING_UPDATE                       @"/api/tax_rating/update"
#define TAX_RATING_PAGE                         @"/api/tax_rating/page"
#define TAX_RATING_DETAIL                       @"/api/tax_rating/detail/"
// 检查抽查
#define SPOT_CHECK_CREATE                       @"/api/spot_check/create"
#define SPOT_CHECK_DELETE                       @"/api/spot_check/delete/"
#define SPOT_CHECK_UPDATE                       @"/api/spot_check/update"
#define SPOT_CHECK_PAGE                         @"/api/spot_check/page"
#define SPOT_CHECK_DETAIL                       @"/api/spot_check/detail/"
// 销售合同
#define CONTRACT_CREATE                         @"/api/sales-contract/create-mobile"
#define CONTRACT_DELETE                         @"/api/sales-contract/delete/"
#define CONTRACT_PAGE                           @"/api/sales-contract/page-mobile"
#define CONTRACT_DETAIL                         @"/api/sales-contract/detail-mobile/"
// 债券信息
#define BOND_INFO_PAGE                          @"/api/bond_info/page"
#define BOND_INFO_DETAIL                        @"/api/bond_info/detail/"
// 购地信息
#define PURCHASE_LAND_PAGE                      @"/api/purchase_land/page"
#define PURCHASE_LAND_DETAIL                    @"/api/purchase_land/detail/"

// 销售订单
#define ORDER_PAGE                              @"/api/order/page"
#define ORDER_DETAIL                            @"/api/order/detail-id/"
#define ORDER_SEND_PAGE                         @"/api/order/page-operator/"
// 发货
#define SAP_INVOICE_PAGE                        @"/api/sap-invoice/page"
#define SAP_INVOICE_DETAIL                      @"/api/sap-invoice/find_read_bean/"
#define SAP_INVOICE_ADD                         @"/api/sap-invoice/add"
// 发票
#define SALES_BILLING_PAGE                      @"/api/sales-billing/page"
#define SALES_BILLING_DETAIL                    @"/api/sales-billing/find_read_bean/"
#define SALES_BILLING_ADD                       @"/api/sales-billing/add"
// 电汇
#define RECEIPT_TRACKING_PAGE                   @"/api/receipt-tracking/page"
#define RECEIPT_TRACKING_DETAIL                 @"/api/receipt-tracking/find_read_bean/"
#define RECEIPT_TRACKING_ADD                    @"/api/receipt-tracking/add"
// 外贸
#define FOREIGN_PAGE                            @"/api/foreign/page"
#define FOREIGN_DETAIL                          @"/api/foreign/detail/"
// 对帐单
#define MONTHY_STATEMENT_PAGE                   @"/api/balance-account/page"
#define MONTHY_STATEMENT_DETAIL                 @"/api/balance-account/detail-mobile/"
#define MONTHY_STATEMENT_ADD                    @"/api/balance-account/add"
// 交易跟踪总览
#define TRACKING_SITUATION                      @"/api/tracking/situation/"


// 任务协作
#define TASK_CREATE                             @"/api/task/create"
#define TASK_PAGE                               @"/api/task/page-two"
#define TASK_CONDITION_LIST                     @"/api/task/condition-list"
#define TASK_CREATE_COMMENT                     @"/api/task/create-comment"

// 新建工厂
#define FACTORY_CREATE                          @"/api/factory/create"
#define FACTORY_DELETE                          @"/api/factory/delete/"
#define FACTORY_UPDATE                          @"/api/factory/update"
#define FACTORY_PAGE                            @"/api/factory/page"
#define FACTORY_DETAIL                          @"/api/factory/detail/"
#define FACTORY_FIND                            @"/api/batch-number-weight/find_factory"

// 采购招标
// 收藏
#define FAVORITE_CREATE                         @"/api/favorite/create"
#define FAVORITE_DELETE                         @"/api/favorite/delete/"

// 配置列表
#define LIST_RISK_TYPE                          @"/api/dict/list/"
#define GET_DIC_LIST_NAME_KEY                   @"/api/dict/list/%@/%@"
#define GET_MATERIAL_LIST                       @"/api/material/page/"
// 物料信息
#define MATERIAL_FIND_DENIER                    @"/api/material/find_denier"
#define MATERIAL_FIND_SPEC                      @"/api/material/find_spec"
#define MATERIAL_FIND_GRADE                     @"/api/material/find_grade"

#define MATERIAL_BATCH_NUMBER_PAGE              @"/api/material/batch-number/page/"

#define APPLICATION_PAGE                        @"/api/application-item/find-page"
#define APPLICATION_ITEM_PAGE                   @"/api/application-item/find-page-category"


// 收藏
#define FAVORITE_MEMBER                         @"/api/favorite/MEMBER/page"
#define FAVORITE_ORDER                          @"/api/favorite/ORDER/page"
#define FAVORITE_TASK                           @"/api/favorite/COLLABORATIVE_TASK/page"

// 签到
#define SIGN_IN_CREATE                          @"/api/sign-in/create"
#define SIGN_IN_UPDATE                          @"/api/sign-in/update"
#define COMMENT_APP                             @"/api/task/create-comment-app"

#define GATHERING_FIND_SORT                     @"/api/gathering_plan/find_sort"

#define MEMBER_UPDATE_URL                       @"/api/member/update-avatar-url"
#define ACTUAL_UPDATE                           @"/api/actual/update"
#define OPERATOR_UPDATE_AVATOR                  @"/api/operator/update-picture"

#define DUNNING_FAILURE                         @"/api/dunning-failure/failure-message"

#define CHANGE_ASSIST                           @"/api/member/change_assist/"
#define SPECIAL_RECORD                          @"/api/special-record/save"
#define FIND_BATCH                              @"/api/material/find-batch"

#define DEMAND_RECORD                           @"/api/demand-record/save"


#pragma mark - 客户价值评估
#define MEMBER_CENTER_GETWORTHBEAN              @"/api/member-center/getWorthBean/%lld/%@"

// 动态表单
#define DYNMIC_CREATE_FORM                      @"/api/%@/create-form"
#define DYNMIC_CREATE                           @"/api/%@/create"
#define DYNMIC_PAGE                             @"/api/%@/page"
#define DYNMIC_UPDATE_FORM                      @"/api/%@/update-form/%lld"
#define DYNMIC_UPDATE                           @"/api/%@/update"
#define DYNMIC_DETAIL                           @"/api/%@/detail/%lld"
#define DYNMIC_DELETE_DETAIL_ID                 @"/api/%@/delete/%lld"
// 批量逻辑删除
#define DYNMIC_BATCH_DELETE                     @"/api/%@/batch-delete"



#pragma mark - 人事组织
#define LINK_MAN_LIST_MEMBERID                  @"/api/link-man/find-pager-memberId"
#define LINK_MAN_LIST_OFFICEID                  @"/api/link-man/find-pager-officeId"
#define LINK_MAN_BUSINESS_CHANCE_PAGE           @"/api/business-chance/page"
#define LINK_MAN_PAIN_POINT_PAGE                @"/api/pain-point/page"
#define LINK_MAN_TOTOL_COUNT                    @"/api/link-man/count-link-man/%lld"

#define LINK_MAN_CREATE                         @"/api/link-man/create"
#define LINK_MAN_DETAIL                         @"/api/link-man/detail/%lld"
#define LINK_MAN_UPDATE                         @"/api/link-man/update"
#define LINK_MAN_DELETE                         @"/api/link-man/delete/%lld"

#define PAIN_POINT_UPDATEMESSAGE                @"/api/pain-point/updateMessageBean"

#pragma mark - 财务风险
#define FINANCE_THIRD_MODULE                    @"/api/finance/third-module-mobile/%lld"
#define FINANCE_BALANCE_AMOUNT                  @"/api/finance/balance-amount-chart-mobile/%lld"
#define FINANCE_BISD_GROUP_BY_BUKRS             @"/api/finance/bisd-group-by-bukrs/%lld"


#pragma mark - 采购状况
#define PURCHASE_SUMMARY_NUMBER                 @"/api/supplier-directory/abstract-summary/%lld"
#define SUPPLIER_DIRECTORY_PAGE                 @"/api/supplier-directory/supplier-list-mobile"

#pragma mark - 生产状况
#define PRODUCT_SUMMARY_NUMBER                  @"/api/product-standard/abstract-summary/%lld"

#pragma mark - 销售状况
#define SALES_SUMMARY_NUMBER                    @"/api/sales-system/abstract-summary/%lld"

#pragma mark - 研发状况
#define DEVLOP_SUMMARY_NUMBER                   @"/api/system-standard/abstract-summary/%lld"

#pragma mark - 合同跟踪
#define CONTRACT_SUMMARY_NUMBER                 @"/api/contract/abstract-summary/%lld"

#pragma mark - 商务拜访
#define VISIT_ACTIVITY_CALENDAR                 @"/api/visit-activity/calendar-list-mobile/%lld/%@"
#define VISIT_ACTIVITY_LIST_BY_CALENDAR         @"/api/visit-activity/activity-list-by-calendar/%lld/%@"
#define VISIT_ACTIVITY_LIST_DETAIL              @"/api/visit-activity/detail/%lld"
#define VISIT_ACTIVITY_LIST_DELETE              @"/api/visit-activity/delete/%lld"
#define VISIT_ACTIVITY_UPDATE_STATUS            @"/api/visit-activity/update-mobile"
#define VISIT_ACTIVITY_UPDATE_COMMUNICATERECORD @"/api/visit-activity/update-communicateRecord-mobile"

#pragma mark - 商务接待
#define VISIT_RECEPTION_CALENDAR                @"/api/customer-base-reception/calendar-list-mobile/%lld/%@"
#define VISIT_RECEPTION_LIST_BY_CALENDAR        @"/api/customer-base-reception/reception-list-by-calendar/%lld/%@"

#pragma mark - 商机跟进
#define BUSINIESS_FOLLOW_SUMMARY_NUMBER         @"/api/clue/abstract-summary/%lld"

#pragma mark - 附件上传
#define FILE_UPLOAD_MULTI                       @"/api/file/upload-multi"
#define FILE_ORG_READ                           @"/api/file/"
#define FILE_THUMBNAIL_READ                     @"/api/file/%@/_thumbnail"

#pragma mark - 动态Feed流
#define FEED_FLOW_PAGE_TREND                    @"/api/feed-flow/page-trend"
#define FEED_LIKE_RECORD_ADD                    @"/api/like-record/add"
#define FEED_LIKE_RECORD_REMOVE                 @"/api/like-record/remove/%lld"

#pragma mark - 字典项
#define DICT_LIST_NAME_REMARK                   @"/api/dict/list-by-name-remark/%@/%@"


#pragma mark - 情报大全
// 情报 @"/api/market-intelligence-item/page"
// 活动 @"/api/market-activity/page"
// 线索 @"/api/clue/page"
// 商机 @"/api/business-chance/page"
#define FEED_BIG_ITEM_PAGE                      @"/api/%@/page"
// 移动端的接口
#define FEED_BIG_ITEM_PAGE_MOBILE               @"/api/%@/page-mobile"

#define FEED_CLUE_CREATE                        @"/api/clue/create"
#define FEED_CLUE_UPDATE                        @"/api/clue/update"
// 关联活动
#define MARKET_ACTIVITY_PAGE                    @"/api/market-activity/page"
// 关联情报
#define MARKET_INTELLIGENCE_ITEM_PAGE           @"/api/market-intelligence-item/page"
//#define CREATE_BUSINESS_CHANGE                  @"/api/business-chance/create"
// 获取大类
#define GET_MATERIAL_TYPE_PAGE                  @"/api/material-type/page"
// 获取部门
#define GET_DEPARTMENT_PAGE                     @"/api/department/page"
// 关联线索
#define GET_CLUE_PAGE                           @"/api/clue/page"

#define GET_CLUE_DETAIL                         @"/api/clue/detail/%lld"
#define GET_SAMPLE_DETAIL                       @"/api/sample/detail/%lld"
#define GET_BUSINESS_CHANGE_DETAIL              @"/api/business-chance/detail/%lld"
#define UPDATE_BUSINESS_CHANGE_DETAIL           @"/api/business-chance/update"
#define CREATE_LINK_ACTIVITY_BY_ID              @"/api/market-intelligence/create-link-activity"
#define GET_LINK_INTELLIGENCE_ITEM              @"/api/link-intelligence-item/list-fkid-fktype/%lld/VISIT_ACTIVITY"
#define UPDATE_INTELLIGENCE_ITEM                @"/api/market-intelligence-item/update"
#define DELETE_INTELLIGENCE_ITEM                @"/api/link-intelligence-item/unlink/%lld/VISIT_ACTIVITY"
#define DETAIL_INTELLIGENCE_ITEM                @"/api/market-intelligence-item/detail/%lld"
// 新增报价
#define CREATE_QUOTED_PRICE                     @"/api/quoted_price/create-and-commit"
#define DETAIL_QUOTED_PRICE                     @"/api/quoted_price/detail/%lld"
#define UPDATE_QUOTED_PRICE                     @"/api/quoted_price/update"
#define CREATE_PAIN_POINT                       @"/api/pain-point/create"
// 国家
#define GET_COUNTRY_PAGE                        @"/api/region/country-page"
#define CREATE_WORKING_CIRCLE                   @"/api/feed-flow/create-working-circle"
#define OPERATOR_DETAIL                         @"/api/operator/detail/"
#define COMPETITOR_BEHAVIOR_DETAIL              @"/api/competitor-behavior/detail/%lld"

#define UPDATE_PASSWORD                         @"/api/operator/update-password"
#define FEED_BACK_CREATE                        @"/api/feed-back/create"

#define CURRENT_USER_VISIT_ACTIVITY_CALENDAR    @"/api/visit-activity/calendar-list-operator-mobile/%@"
#define CURRENT_USER_VISIT_ACTIVITY_LIST_PAGE   @"/api/visit-activity/page"
#define VIEW_RECORD_CREATE_MULTIPLE             @"/api/view-record/create-multiple"
#define CURRENT_USER_RECEPTION_LISTBY_CALENDAR  @"/api/customer-base-reception/calendar-list-operator-mobile/%@"
#define CURRENT_USER_RECEPTION_LIST_PAGE        @"/api/customer-base-reception/page"


#define MEMBER_ASSIST_FIND_OPERATOR             @"/api/member-assist/findOperator/%lld"
#define MEMBER_ASSIST_CREATE_APP                @"/api/member-assist/create-app"
#define MEMBER_ASSIST_DELETE                    @"/api/member-assist/delete/%lld"

#define SIGN_IN_PAGE                            @"/api/sign-in/page"

#define RETAIL_CHANNEL_CREATE                   @"/api/retail-channel/create"
#define RETAIL_CHANNEL_UPDATE                   @"/api/retail-channel/update"
#define RETAIL_CHANNEL_PAGE                     @"/api/retail-channel/page"
#define RETAIL_CHANNEL_DETAIL                   @"/api/retail-channel/detail/%lld"
#define WORK_PLAN_TARGET_FINDOPERATOR           @"/api/work-plan-target/findByOperator"
//#define RETAIL_CHANNEL_SUM_ACTUALSHIPMENT       @"/api/retail-channel/sum-actualShipment"
#define RETAIL_CHANNEL_ITEM_DETAIL              @"/api/attachment/list/RETAIL_CHANNEL_ITEM/%lld"
#define DELETE_WORK_PLAN                        @"/api/%@/remove"

#define NENG_CHENG_ITEM                         @"/api/attachment/list/NENG_CHENG_ITEM/%lld"
#define HUA_JUE_ITEM                            @"/api/attachment/list/HUA_JUE_ITEM/%lld"
#define JIN_MU_ITEM                             @"/api/attachment/list/JIN_MU_ITEM/%lld"

#define CHANNEL_DEVELOPMENT_PAGE                @"/api/channel-development/page"
#define CHANNEL_DEVELOPMENT_CREATE              @"/api/channel-development/create"
#define CHANNEL_DEVELOPMENT_UPDATE              @"/api/channel-development/update"
#define CHANNEL_DEVELOPMENT_DETAIL              @"/api/channel-development/detail/%lld"
#define CHANNEL_DEVELOPMENT_SUM_ACCUMULATEVISIT @"/api/channel-development/sum-accumulateVisit"

#define API_DATE_TODAY                          @"/api/date/today"

#define MARKET_ENGINEER_DETAIL                  @"/api/market-engineering/detail/%lld"
//#define MARKET_ENGINEERING_SUM_ACTUALSHIPMENT   @"/api/market-engineering/sum-actualShipment"
#define STRATEGIC_ENGINEER_DETAIL               @"/api/strategic-engineering/detail/%lld"
#define DIRECT_SALES_ENGINEER_DETAIL            @"/api/direct-sales-engineering/detail/%lld"
#define QUERY_PROVINCE_PAGE                     @"/api/region/queryProvinceInfoByPage"
#define NENG_CHENG_DETAIL                       @"/api/neng-cheng/detail/%lld"
#define HUAJUE_DETAIL                           @"/api/hua-jue/detail/%lld"

#define NENG_CHENG_SUM_ACCUMULATEVISIT          @"/api/neng-cheng/sum-accumulateVisit"
#define NENG_CHENG_SUM_ACTUALSHIPMENT           @"/api/neng-cheng/sum-actualShipment"
#define HUA_JUE_SUM_ACTUALSHIPMENT              @"/api/hua-jue/sum-actualShipment"

#define WORK_SUM_ACTUAL_SHIPMENT                @"/api/%@/sum-actualShipment/%@"
#define WORK_SUM_ACTUAL_SHIPMENT_DIRECT_SALE    @"/api/direct-sales-engineering/sum-actualReceivedPayments"
#define BRAND_PAGE                              @"/api/brand/page"
#define FIND_CAREFUL_AREA                       @"/api/member/find-careful-area"
#define JINMU_DETAIL                            @"/api/jin-mu/detail/%lld"
#define REGION_FIND                             @"/api/region/"
#define STOREM_MANAGE_CREATE                    @"/api/storme-manage-entity/create"
#define STOREM_MANAGE_DETAIL                    @"/api/storme-manage-entity/detail/%@lld"

#define FIND_PROVINCE_BY_PROVINCEID             @"/api/region/findProvinceByProvinceId/%@"
#define FIND_CITY_BY_CITYID                     @"/api/region/findCityByCityId//%@"
#define FIND_AREA_BY_AREA                       @"/api/region/findAreaByAreaId//%@"

#define DAILY_DEVELIVERY                        @"/api/%@/daily-develivery/%@"

#define WORK_PLAN_TARGET_AREA                   @"/api/work-plan-target-area/findByBrandAndProvince"
#define MARKET_ENGINEERING_REQUIRE_ENGINEER     @"/api/market-engineering/require-engineer"

#define GetBxbzForCRM                           @"http://112.17.59.161:10000/jiuyi/CRM/GetBxbzForCRM.jsp?"
#define TRAVEL_GETCITY_LIST                     @"http://112.17.59.161:10000/api/travel/getCity"

#define QUERY_CITY_INFOR                        @"/api/region/queryCityInfoByPage"
#define QUERY_AREA_INFOR                        @"/api/region/queryAreaInfoByPage"

#define WORKPLAN_DETAIL_ID                      @"/api/workPlan/detail/%lld"
#define WORKPLAN_ITEM                           @"/api/attachment/list/WORK_PLAN_ITEM/%lld"
#define WORKPLAN_SUM_ACCUMULATEVISIT            @"/api/workPlan/sum-accumulateVisit"
#define WORKPLAN_SUM_ACTUAL_SHIPMENT            @"/api/workPlan/sum-actualShipment"




// 所有获取 当日实际发货量和当月累计发货量
#define GET_SAP_SALES_BY_BRAND_AND_YEAR         @"/api/retail-channel/getSapSalesByBrandAdnYear"
//零售渠道部计划-获取-当月累计发货量--当日实际发货量       /api/SapDataController/getSapSalesByBrandAdnYear/_LS/LFIMG_
//战略工程部计划-获取-当月累计销售额--实际销售额          /api/SapDataController/getSapSalesByBrandAdnYear/_GC/KWERT_
//市场工程部计划-获取-当月累计发货量--当日实际发货量       /api/SapDataController/getSapSalesByBrandAdnYear/_GC/LFIMG_
#define GET_SAP_SALES_BY_BRAND_AND_YEAR_TYPE    @"/api/SapDataController/getSapSalesByBrandAdnYear/%@"

// 通用计划 获取当月累计销售额和当日实际销售额
#define GET_SAP_SALES_BY_WORK_PLAN              @"/api/workPlan/getSapSalesByBrandAdnYear"


// 获取昨日数据
#define WORKTYPE_RETAIL_CHANNEL                 @"retail-channel"       // 零售
#define WORKTYPE_MARKET_ENGINEERING             @"market-engineering"   // 市场
#define WORKTYPE_NENG_CHENG                     @"neng-cheng"           // 能诚
#define WORKTYPE_HUA_JUE                        @"hua-jue"              // 华爵
#define WORKYTPE_STR_ENGIN                      @"strategic-engineering"// 战略
#define WORKYTPE_DIRECT_SALES                   @"direct-sales-engineering"// 直营
#define WORKYTPE_CHANNEL_DEVELOPMENT            @"channel-development"  // 渠道

#define WORKTYPE_GOLDWOOD                       @"GOLDWOOD"             // 金木们
#define WORKTYPE_ZHINENG                        @"HYZNG"                // 智能锁
#define WORKTYPE_ALD                            @"ALD"                  // 铝木们
#define WORKTYPE_CERART                         @"CERART"               // 铜艺
#define WORKTYPE_TIMBER                         @"TIMBER"               // 木们

#define GET_INFO_YESTERDAY                      @"/api/%@/getInfo"
#define GET_INFO_YESTERDAY_COMMON               @"/api/workPlan/getInfo/%@"


@interface URLConfig : NSObject

+ (NSString *)domainUrl:(NSString *)url;
+ (NSString *)domainUrl:(NSString *)url withToken:(NSString *)token;
+ (NSString *)url:(NSString *)url withToken:(NSString *)token;


@end

/* {
 key-demand 需求痛点（关键需求）  2625 待确定
 
 supplier-directory 供应商 2631 待确定
 product-directory 采购目录 2632
 access-standard 准入技检标准 2633
 evaluation-system 评价考核体系 2634
 
 product-standard 标准 2637
 product-info 产品信息 2638
 factory-equipment 工厂设备 2639
 capacity-info 产能信息 2640
 quality-standard 品质标准 2641
 iqc-material IQC来料 2642
 put-into-product 投产状况 2643
 ctm-report CTM报告 2644
 
 sales-system 销售体系文件 2649
 client-list 客户名录 2650
 standard-price 销售报价 2651
 import-and-export-quotation 进出口产品 2652
 
 system-standard 研发标准 2657
 patent-certification 专利认证 2658
 technical-road-sign 技术路标 2659
 laboratory 实验室 2660
 
 visit-activity 新建拜访 2661
 新建接待 2669
} */
