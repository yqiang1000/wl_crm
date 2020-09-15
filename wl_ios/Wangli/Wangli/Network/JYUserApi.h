//
//  JYUserApi.h
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseApi.h"

@interface JYUserApi : BaseApi

@property(nonatomic,strong) NSString *token;

@property(nonatomic,strong) NSString *phoneCode;

@property(nonatomic,assign) long long diffTimestamp;

+ (instancetype) sharedInstance;

// 客户列表缓存
+ (void)releaseCustomerParamsCache;

// 客户搜索缓存
+ (void)releaseSearchParamsCache;

#pragma mark - 登录
/**
 *  快捷登录
 *  @param mobile  手机号
 *  @param smsCode 验证码
 */
- (void)login:(NSString *) mobile
      smsCode:(NSString *) smsCode
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))fail;
/**
 *  获取验证码
 *  @param mobile  手机号
 */
- (void)getSMSCodeByMobile:(NSString *) mobile
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;
///**
// *  获取userSign
// *  @param userName 用户名
// */
//- (void)getUserSign:(NSString *)userName
//            success:(void (^)(id responseObject))success
//            failure:(void (^)(NSError *error))fail;

#pragma mark - 客户
/**
 *  获取客户列表
 *  @param direction 排序
 *  @param property 需要排序的id
 *  @param size 每页数量
 *  @param rules 规则
 *  @param page 分页
 *  @param specialDirection 排序字段
 *  @param specialConditions 负责人和快速筛选条件数组
 */
- (void)getCustomerListDirection:(NSString *)direction
                        property:(NSString *)property
                            size:(NSInteger)size
                           rules:(NSArray *)rules
                            page:(NSInteger)page
                specialDirection:(NSString *)specialDirection
               specialConditions:(NSArray *)specialConditions
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  搜索客户列表
 *  @param page 分页
 *  @param size 每页数量
 *  @param rules 规则
 *  @param specialConditions 集合
 *  @param keyword 关键字
 */
- (void)searchCustomerListPage:(NSInteger)page
                          size:(NSInteger)size
                         rules:(NSArray *)rules
                       keyword:(NSString *)keyword
             specialConditions:(NSArray *)specialConditions
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

#pragma mark - 通讯录
/**
 *  获取公司通讯录部门
 */
- (void)getDepartmentSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  获取公司通讯录成员
 */
- (void)getDepartmentPersonRules:(NSArray *)rules
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  分页获取通讯录
 */
- (void)getOperaterListParam:(NSDictionary *)param
                       rules:(NSArray *)rules
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  获取可查找的协作者
 */
- (void)getTaskCollaboratorRules:(NSArray *)rules
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  获取可查找的接受者
 */
- (void)getTaskReceiverRules:(NSArray *)rules
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/**
 *  获取重要联系人（客户的联系人）
 *  @param trueOrFallse true:重要联系人 false:所有联系人
 */
- (void)getImportPersonParam:(NSDictionary *)param
                       rules:(NSArray *)rules
                 trueOrFalse:(NSString *)trueOrFallse
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/**
 *  获取手动筛选条件
 */
- (void)getMemberChooseSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;


/**
 *  获取客户联系人列表
 *  @param customerId 客户id
 *  @param page 页码
 *  @param size 数量
 *  @param direction 排序
 *  @param contentId 联系人id
 */
- (void)getContentPageByCustomerId:(NSInteger)customerId
                              page:(NSInteger)page
                              size:(NSInteger)size
                         direction:(NSString *)direction
                         contentId:(NSInteger)contentId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

#pragma mark - 联系人
/**
 *  新建联系人
 *  @param name 姓名
 *  @param title 标题（用途未知）
 *  @param type 类型 （未知）
 *  @param sex 性别
 *  @param birthday 出生年月
 *  @param email 邮箱
 *  @param address 地址
 *  @param office 部门
 *  @param duty 职务
 *  @param arrPhone 手机号
 *  @param memberId 客户id
 *  @param import 重要联系人
 */
- (void)createContactName:(NSString *)name
                    title:(NSString *)title
                     type:(NSString *)type
                      sex:(NSString *)sex
                 birthday:(NSString *)birthday
                    email:(NSString *)email
                  address:(NSString *)address
                   office:(NSString *)office
                     duty:(NSString *)duty
                 arrPhone:(NSArray *)arrPhone
                 memberId:(NSInteger)memberId
                   import:(BOOL)import
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail ;

/**
 *  更新联系人
 *  @param contactId 联系人id
 *  @param name 姓名
 *  @param title 标题（用途未知）
 *  @param type 类型 （未知）
 *  @param sex 性别
 *  @param birthday 出生年月
 *  @param email 邮箱
 *  @param address 地址
 *  @param office 部门
 *  @param duty 职务
 *  @param arrPhone 手机号
 *  @param memberId 客户id
 *  @param import 重要联系人
 */
- (void)updateContactId:(NSInteger)contactId
                   name:(NSString *)name
                  title:(NSString *)title
                   type:(NSString *)type
                    sex:(NSString *)sex
               birthday:(NSString *)birthday
                  email:(NSString *)email
                address:(NSString *)address
                 office:(NSString *)office
                   duty:(NSString *)duty
               arrPhone:(NSArray *)arrPhone
               memberId:(NSInteger)memberId
                 import:(BOOL)import
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/**
 *  获取联系人详情
 *  @param contactId 联系人id
 */
- (void)getContactDetailById:(NSInteger)contactId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  删除联系人
 *  @param contactId 联系人id
 */
- (void)deleteContactDetailById:(NSInteger)contactId
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;
/**
 *  搜索联系人
 *  @param keyword 关键字
 */
- (void)searchContactListByKeyword:(NSString *)keyword
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/**
 *  发送联系人
 */
- (void)getContactListParam:(NSDictionary *)param
                      rules:(NSArray *)rules
                   toUserId:(NSString *)toUserId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

#pragma mark - 地址
/**
 *  获取客户收货地址列表
 *  @param customerId 客户id
 */
- (void)getAddressPageByCustomerId:(NSInteger)customerId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  删除客户收货地址
 *  @param addressId 地址id
 */
- (void)deleteAddressAddressId:(NSInteger)addressId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

#pragma mark - 风险预警
/**
 *  获取风险预警提示条数
 *  @param customerId 客户id
 */
- (void)riskWarnStatisticsByCustomId:(NSInteger)customerId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/**
 *  获取上传七牛token(私有)
 */
- (void)getQiNiuUploadTokenSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  获取上传七牛token(共有)
 */
- (void)getQiNiuUploadTokenOpenSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  获取客户实控人信息
 *  @param customerId 客户id
 */
- (void)getCustomerInfoByCustomId:(NSInteger)customerId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/**
 *  获取客户基本资料信息
 *  @param customerId 客户id
 */
- (void)getCustomerOrgInfoByCustomId:(NSInteger)customerId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/**
 *  修改客户基本资料信息
 *  @param customerId 客户id
 *  @param field 字段
 *  @param value 值
 */
- (void)updateCustomerByCustomId:(NSInteger)customerId
                           field:(NSString *)field
                           value:(NSString *)value
                           param:(NSMutableDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/**
 *  修改客户实控人信息
 *  @param personId 客户实控人id
 *  @param field 字段
 *  @param value 值
 */
- (void)updateCustomerPersonInfo:(NSString *)personId
                           field:(NSString *)field
                           value:(NSString *)value
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/**
 *  获取客户基本资料信息
 *  @param customerId 客户id
 *  @param phoneOne 手机号
 *  @param areaIds 地址邮编
 *  @param areaNames 地址名
 *  @param address 详细地址
 *  @param receiver 收件人
 *  @param defaults 是否默认
 */
- (void)createAddressByCustomId:(NSInteger)customerId
                       phoneOne:(NSString *)phoneOne
                        areaIds:(NSArray *)areaIds
                      areaNames:(NSArray *)areaNames
                       receiver:(NSString *)receiver
                        address:(NSString *)address
                       defaults:(BOOL)defaults
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail ;

/**
 *  更新地址信息
 *  @param customerId 客户id
 *  @param addressId 地址id
 *  @param phoneOne 手机号
 *  @param areaIds 地址邮编
 *  @param areaNames 地址名
 *  @param address 详细地址
 *  @param receiver 收件人
 *  @param defaults 是否默认
 */
- (void)updateAddressByCustomId:(NSInteger)customerId
                      addressId:(NSInteger)addressId
                       phoneOne:(NSString *)phoneOne
                        areaIds:(NSArray *)areaIds
                      areaNames:(NSArray *)areaNames
                       receiver:(NSString *)receiver
                        address:(NSString *)address
                       defaults:(BOOL)defaults
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;


/**
 *  获取联系人选择列表
 *  @param customerId 客户id
 */
- (void)getChoseContentLIstByCustomId:(NSInteger)customerId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;
#pragma mark - 风险预警

/**
 *  获取某一项风险信息
 *  @param customerId 客户id
 *  @param number 分页
 *  @param size 大小
 *  @param direction 排序
 *  @param property 详细地址
 *  @param rules 规则
 */
- (void)getRiskWarnPageByCustomerId:(NSInteger)customerId
                             number:(NSInteger)number
                               size:(NSInteger)size
                          direction:(NSString *)direction
                           property:(NSString *)property
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;
/**
 *  获取Feed流
 *  @param customerId 客户id
 *  @param number 分页
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getFeedFlowPageByCustomerId:(NSInteger)customerId
                             number:(NSInteger)number
                               size:(NSInteger)size
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;
/**
 *  获取风险信息详情
 *  @param riskId 风险id
 */
- (void)getRiskWarnDetailRiskId:(NSInteger)riskId
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;
/**
 *  删除风险信息
 *  @param riskId feedId
 */
- (void)deleteRiskWarnDetailRiskId:(long long)riskId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/**
 *  新建风险信息
 *  @param param 参数
 *  @param attachmentList 附件
 */

- (void)createRiskWarnParam:(NSDictionary *)param
             attachmentList:(NSArray *)attachmentList
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  更新风险信息
 *  @param riskId 风险id
 *  @param param 参数
 *  @param attachmentList 附件
 */
- (void)updateRiskWarnByRiskId:(NSInteger)riskId
                         param:(NSDictionary *)param
                attachmentList:(NSArray *)attachmentList
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

#pragma mark - 信用欠款
/**
 *  获取信用及欠款主页信息
 *  @param customerId 客户id
 *  @param yearStr 年份
 */
- (void)getCreditCountByCustomerId:(NSInteger)customerId
                           yearStr:(NSString *)yearStr
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  新建信用数据
 */
- (void)getCreditSameCompanyByCustomerId:(NSInteger)customerId
                                 yearStr:(NSString *)yearStr
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail;

/**
 *  信用头部数据
 */
- (void)getCreditHeaderByCustomerId:(NSInteger)customerId
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/**
 *  信用尾部数据
 */
- (void)getCreditFooterByCustomerId:(NSInteger)customerId
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;
/**
 *  信用贷款账期分布
 */
- (void)getCreditDeptAccountByCustomerId:(NSInteger)customerId
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail;
/**
 *  新建信用及欠款申请
 */
- (void)createAccountApplyByParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

#pragma mark - 收款
/**
 *  新建收款计划
 *  @param customerId 客户id
 *  @param year 年
 *  @param month 月
 *  @param quantity 金额
 *  @param receivedAmount 截止收款
 *  @param planTotalAmount 计划总额
 */
- (void)createPayPlanByCustomerId:(NSInteger)customerId
                             year:(NSString *)year
                            month:(NSString *)month
                         quantity:(NSString *)quantity
                   receivedAmount:(NSString *)receivedAmount
                  planTotalAmount:(NSString *)planTotalAmount
                           remark:(NSString *)remark
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  收款计划详情
 */
- (void)getPayPlanDetail:(NSInteger)payPlanId
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  获取客户欠款情况
 */
- (void)getCusDeptByCustomerId:(NSInteger)customerId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/**
 *  获取客户已收款额度和欠款情况
 */
- (void)getReceiveCountCustomerId:(NSInteger)customerId
                        yearMonth:(NSString *)yearMonth
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  获取收款计划列表
 *  @param param 参数
 *  @param page 分页
 *  @param size 大小
 *  @param specialConditions 全局搜索
 *  @param rules 规则
 */
- (void)getGatheringPlanPageByParam:(NSDictionary *)param
                               page:(NSInteger)page
                               size:(NSInteger)size
                              rules:(NSArray *)rules
                  specialConditions:(NSArray *)specialConditions
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/**
 *  更新收款计划
 *  @param planId 计划id
 *  @param memberId 客户id
 *  @param year 年
 *  @param month 月
 *  @param quantity 计划数量
 *  @param receivedAmount 截止收款
 *  @param planTotalAmount 计划总额
 */
- (void)updateGatheringPlanByPlanId:(NSInteger)planId
                           memberId:(NSInteger)memberId
                               year:(NSString *)year
                              month:(NSString *)month
                           quantity:(NSString *)quantity
                     receivedAmount:(NSString *)receivedAmount
                    planTotalAmount:(NSString *)planTotalAmount
                             remark:(NSString *)remark
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail ;
/**
 *  shan chu收款计划
 */
- (void)deleteGatheringPlanByPlanId:(NSInteger)planId
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/**
 *  获取收款计划图表
 *  @param memberId 客户id
 *  @param year 年
 */
- (void)getGatheringLineChartByMemberId:(NSInteger)memberId
                                   year:(NSString *)year
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;
#pragma mark - 字典配置信息
/**
 *  获取后台配置信息列表
 *  @param name 配置类型名称
 */
- (void)getConfigDicByName:(NSString *)name
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

- (void)getConfigDicByName:(NSString *)name
                       key:(NSString *)key
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 360首页
/**
 *  获取客户首页信息
 *  @param memberId 客户id
 */
- (void)getMemberCenterByMemberId:(NSInteger)memberId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  获取标签列表
 *  @param memberId 客户id
 */
- (void)getLabelPage:(NSInteger)memberId
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail;
/**
 *  添加标签
 *  @param memberId 客户id
 */
- (void)createLabelMemberId:(NSInteger)memberId
                       desp:(NSString *)desp
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  移除标签
 *  @param memberId 客户id
 */
- (void)removeLabelMemberId:(NSInteger)memberId
                      labId:(NSInteger)labId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取客户系统信息
 *  @param memberId 客户id
 */
- (void)getMemberSystemInfoByMemberId:(NSInteger)memberId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

/**
 *  获取客户雷达图
 *  @param memberId 客户id
 */
- (void)getMemberRadarChatMemberId:(NSInteger)memberId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  获取客户发货趋势图
 *  @param memberId 客户id
 */
- (void)getInvoiceChartMobileByMemberId:(NSInteger)memberId
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

#pragma mark - 要货计划
/**
 *  获取物料列表
 *  @param customId 客户id
 *  @param page 页码
 *  @param rules 规则
 */
- (void)getMaterialList:(NSInteger)customId
                   page:(NSInteger)page
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/**
 *  获取物料价格
 *  @param customId 客户id
 *  @param materialId 物料id
 */
- (void)getMaterialPriceByCustomerId:(NSInteger)customId
                          materialId:(NSInteger)materialId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;
/**
 *  获取件重
 */
- (void)getBatchNumberWeightPageParam:(NSDictionary *)param
                                rules:(NSArray *)rules
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

/**
 *  新建要货计划
 *  @param customerId 客户id
 */
- (void)createDealPlanByCustomerId:(NSInteger)customerId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  获取要货计划列表
 *  @param param 参数
 *  @param page 分页
 *  @param size 大小
 *  @param rules 规则
 *  @param specialConditions 全局搜索参数
 */
-  (void)getDemandPlanPageByParam:(NSDictionary *)param
                             page:(NSInteger)page
                             size:(NSInteger)size
                            rules:(NSArray *)rules
                specialConditions:(NSArray *)specialConditions
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/**
 *  搜索要货计划
 *  @param param 参数
 *  @param page 分页
 *  @param size 大小
 *  @param specialConditions 集合
 *  @param rules 规则
 */
- (void)searchDemandPlanPageByParam:(NSDictionary *)param
                               page:(NSInteger)page
                               size:(NSInteger)size
                              rules:(NSArray *)rules
                  specialConditions:(NSArray *)specialConditions
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/**
 *  修改要货计划
 *  @param planId 计划id
 */
- (void)updateDemandPlanByPlanId:(NSInteger)planId
                           param:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  要货计划详情
 *  @param planId 计划id
 */
- (void)getDemandPlanDetailByPlanId:(NSInteger)planId
                              param:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;
/**
 *  删除要货计划
 */
- (void)deleteDemandPlanByPlanId:(NSInteger)planId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  要货计划汇总接口
 */
- (void)getDemandPlanCollectPageByParam:(NSDictionary *)param
                                  rules:(NSArray *)rules
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;
/**
 *  我的收藏要货计划汇总接口
 */
- (void)getCollectionSendTotal:(NSDictionary *)param
                         rules:(NSArray *)rules
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/**
 *  要货计划某一汇总详情接口
 */
- (void)getDemandPlanDetailPageByPager:(NSDictionary *)pager
                   operatorCollectBean:(NSDictionary *)operatorCollectBean
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail;
/**
 *  批量新建要货计划
 */
- (void)createDemandByBatchByParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/**
 *  历史要货计划
 */
- (void)getDemandPreBatchListParam:(NSDictionary *)param
                          memberId:(NSInteger)memberId
                         yearMonth:(NSString *)yearMonth
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
#pragma mark - 市场动态
/**
 *  获取市场动态提示条数
 *  @param customerId 客户id
 */
- (void)marketTrendStatisticsByCustomId:(NSInteger)customerId
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

/**
 *  新建市场动态
 *  @param customerId 客户id
 *  @param operatorIdId 操作员
 *  @param infoDate 日期
 *  @param type 风险类型
 *  @param title 标题
 *  @param content 详细内容
 *  @param attachmentList 附件
 *  @param important 重要性（pc端）
 *  @param departments 部门
 */
- (void)createMarkeTrendByCustomerId:(NSInteger)customerId
                        operatorIdId:(NSInteger)operatorIdId
                            infoDate:(NSString *)infoDate
                                type:(NSDictionary *)type
                               title:(NSString *)title
                             content:(NSString *)content
                           important:(NSInteger)important
                         departments:(NSArray *)departments
                      attachmentList:(NSArray *)attachmentList
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/**
 *  获取某一项市场动态信息
 *  @param customerId 客户id
 *  @param number 分页
 *  @param size 大小
 *  @param direction 排序
 *  @param property 详细地址
 *  @param rules 规则
 */
- (void)getMarketTrendPageByCustomerId:(NSInteger)customerId
                                number:(NSInteger)number
                                  size:(NSInteger)size
                             direction:(NSString *)direction
                              property:(NSString *)property
                                 rules:(NSArray *)rules
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail;

/**
 *  修改市场动态
 *  @param markId 动态id
 *  @param memberId 客户id
 *  @param infoDate 日期
 *  @param type 风险类型
 *  @param title 标题
 *  @param content 详细内容
 *  @param important 重要性（pc端）
 *  @param departments 部门
 *  @param attachmentList 附件
 */
- (void)updateMarkeTrendByMarkId:(NSInteger)markId
                        memberId:(NSInteger)memberId
                        infoDate:(NSString *)infoDate
                            type:(NSDictionary *)type
                           title:(NSString *)title
                         content:(NSString *)content
                       important:(NSInteger)important
                     departments:(NSArray *)departments
                  attachmentList:(NSArray *)attachmentList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  删除市场动态
 */
- (void)deleteMarkeTrendByMarkId:(long long)markId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  获取市场动态详情
 */
- (void)detailMarkeTrendByMarkId:(NSInteger)markId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/**
 *  新建客户投诉
 */
- (void)createCustomerComplaintsByCustomerId:(NSInteger)customerId
                                operatorIdId:(NSInteger)operatorIdId
                                    infoDate:(NSString *)infoDate
                                        type:(NSString *)type
                                      status:(NSInteger)status
                                       title:(NSString *)title
                                     content:(NSString *)content
                                   important:(NSInteger)important
                                 departments:(NSArray *)departments
                              attachmentList:(NSArray *)attachmentList
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail;
/**
 *  新建客户
 *  @param operatorIdId 业务员id
 *  @param data 动态创建的参数
 */
- (void)createCustomerByOperatorIdId:(NSInteger)operatorIdId
                                data:(NSArray *)data
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/**
 *  获取当前操作员可选择的客户列表
 *  只有订单，计划需要传rules
 */
- (void)getSelfMemberListParam:(NSDictionary *)param
                         rules:(NSArray *)rules
             specialConditions:(NSArray *)specialConditions
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  发消息选择的客户列表
 */
- (void)getSendAbleMemberListParam:(NSDictionary *)param
                          toUserId:(NSString *)toUserId
                             rules:(NSArray *)rules
                 specialConditions:(NSArray *)specialConditions
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**
 *  新建收藏
 *  @param typeId 收藏类型：ARTICLE,PRODUCT,MEMBER,ORDER,
 *  @param favoriteId 收藏id
 */
- (void)createFavoriteTypeId:(NSString *)typeId
                  favoriteId:(long long)favoriteId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/**
 *  删除收藏
 *  @param favoriteId 收藏id
 */
- (void)deleteFavoriteId:(long long)favoriteId
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/**
 *  获取旦数
 */
- (void)getMaterialFindDenierSuccess:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;
/**
 *  获取规格
 */
- (void)getMaterialFindSpecSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/**
 *  获取等级
 */
- (void)getMaterialFindGradeSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/**
 *  获取协助人列表
 */
- (void)getOperatorAssistListParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

#pragma mark - 转移，释放，认领
/**
 *  释放客户
 *  @param memberId 客户id
 *  @param originalSaleman 原负责人
 *  @param remark 备注
 *  @param infoDate 年月日
 */
- (void)applyReleaseMemberId:(NSInteger)memberId
             originalSaleman:(NSInteger)originalSaleman
                      remark:(NSString *)remark
                    infoDate:(NSString *)infoDate
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/**
 *  认领客户
 *  @param memberId 客户id
 *  @param targetSaleman 新负责人
 *  @param remark 备注
 *  @param infoDate 年月日
 */
- (void)applyClaimMemberId:(NSInteger)memberId
             targetSaleman:(NSInteger)targetSaleman
                    remark:(NSString *)remark
                  infoDate:(NSString *)infoDate
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail  ;

/**
 *  转移客户
 *  @param memberId 客户id
 *  @param originalSaleman 原负责人
 *  @param targetSaleman 新负责人
 *  @param remark 备注
 *  @param infoDate 年月日
 */
- (void)applyTransferMemberId:(NSInteger)memberId
              originalSaleman:(NSInteger)originalSaleman
                targetSaleman:(NSInteger)targetSaleman
                       remark:(NSString *)remark
                     infoDate:(NSString *)infoDate
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/**
 *  获取生产状况列表
 *  @param customerId 客户id
 */
- (void)getProductSituationByCustomId:(NSInteger)customerId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

#pragma mark - 产品信息
/**
 *  新建产品信息
 */
- (void)createProductMemberId:(NSInteger)memberId
                        param:(NSDictionary *)param
                  attachments:(NSArray *)attachments
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/**
 *  修改产品信息
 */
- (void)updateProductId:(NSInteger)productId
               memberId:(NSInteger)memberId
                  param:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/**
 *  产品信息列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getProductPage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;

/**
 *  删除产品信息
 *  @param productId 信息id
 */
- (void)deleteProductById:(NSInteger)productId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/**
 *  产品信息详情
 *  @param productId 信息id
 */
- (void)detailProductById:(NSInteger)productId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

#pragma mark - 原料信息
/**
 *  新建原料信息
 *  @param param 参数
 *  @param name 名称
 *  @param attachments 附件
 */
- (void)createRowMaterialParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  修改原料信息
 */
- (void)updateRowMaterialId:(NSInteger)rowMaterialId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取原料信息列表
 */
- (void)getRowMaterialPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

/**
 *  删除原料信息
 */
- (void)deleteRowMaterialById:(NSInteger)productId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/**
 *  获取原料信息详情
 */
- (void)detailRowMaterialById:(NSInteger)productId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

#pragma mark - 竞品信息
/**
 *  新建竞品信息
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createCompetitionParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  修改竞品信息
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updateCompetitionId:(NSInteger)competitionId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取竞品信息列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getCompetitionPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

/**
 *  删除竞品信息
 */
- (void)deleteCompetitionById:(NSInteger)competitionId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/**
 *  获取竞品信息详情
 */
- (void)detailCompetitionById:(NSInteger)competitionId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;
#pragma mark - 设备信息
/**
 *  新建设备信息
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createEquipmentParam:(NSDictionary *)param
                 attachments:(NSArray *)attachments
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/**
 *  修改设备信息
 *  @param equipmentId 设备id
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updateEquipmentId:(NSInteger)equipmentId
                    param:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/**
 *  获取设备列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getEquipmentPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/**
 *  删除设备
 */
- (void)deleteEquipmentById:(NSInteger)equipmentId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取设备详情
 */
- (void)detailEquipmentById:(NSInteger)equipmentId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  根据领域选择设备类型
 */
- (void)getEquipmentTypeWithField:(NSString *)fieldValue
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  获取设备总数
 */
- (void)getEquipmentTotalCountByMemberId:(NSInteger)memberIdId
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail;

#pragma mark - 生产动态
/**
 *  新建生产动态
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createPerformanceParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  修改生产动态
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updatePerformanceId:(NSInteger)performanceId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取生产动态列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getPerformancePage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

/**
 *  删除生产动态
 */
- (void)deletePerformanceById:(NSInteger)performanceId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/**
 *  获取生产动态详情
 */
- (void)detailPerformanceById:(NSInteger)performanceId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;
#pragma mark - 工厂招工
/**
 *  新建工厂招工
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createRecruitmentParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  修改工厂招工
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updateRecruitmentId:(NSInteger)recruitmentId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  获取工厂招工列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getRecruitmentPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail ;

/**
 *  删除工厂招工
 */
- (void)deleteRecruitmentById:(NSInteger)recruitmentId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail ;

/**
 *  获取工厂招工详情
 */
- (void)detailRecruitmentById:(NSInteger)recruitmentId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;
#pragma mark - 生产许可
/**
 *  新建生产许可
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createLicenseParam:(NSDictionary *)param
               attachments:(NSArray *)attachments
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;


/**
 *  修改生产许可
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updateLicenseId:(NSInteger)licenseId
                  param:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/**
 *  获取生产许可列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getLicensePage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;

/**
 *  删除生产许可
 */
- (void)deleteLicenseById:(NSInteger)licenseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/**
 *  获取工厂招工详情
 */
- (void)detailLicenseById:(NSInteger)licenseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/**
 *  新建采购招标
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)createPruchaseParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/**
 *  修改采购招标
 *  @param param 参数
 *  @param attachments 附件
 */
- (void)updatePruchaseId:(NSInteger)pruchaseId
                   param:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/**
 *  获取采购招标列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getPruchasePage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/**
 *  删除采购招标
 */
- (void)deletePruchaseById:(NSInteger)pruchaseId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

/**
 *  获取采购招标详情
 */
- (void)detailPruchaseById:(NSInteger)pruchaseId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 进出口信息

/**
 *  创建进出口信息
 */
- (void)createPortInfoParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  修改进出口信息
 */
- (void)updatePortInfoId:(NSInteger)portInfoId
                   param:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  获取进出口信息列表
 */
- (void)getPortInfoPage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/**
 *  删除进出口信息
 */
- (void)deletePortInfoById:(NSInteger)portInfoId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;
/**
 *  获取进出口信息详情
 */
- (void)detailPortInfoById:(NSInteger)portInfoId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 税务评级
/**
 *  创建税务评级
 */
- (void)createTaxRatingParam:(NSDictionary *)param
                 attachments:(NSArray *)attachments
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  修改税务评级
 */
- (void)updateTaxRatingId:(NSInteger)taxRatingId
                    param:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;
/**
 *  获取税务评级列表
 */
- (void)getTaxRatingPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  删除税务评级
 */
- (void)deleteTaxRatingById:(NSInteger)taxRatingId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  获取税务评级详情
 */
- (void)detailTaxRatingById:(NSInteger)taxRatingId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

#pragma mark - 抽查检查

/**
 *  创建抽查检查
 */
- (void)createSpotCheckParam:(NSDictionary *)param
                 attachments:(NSArray *)attachments
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  修改抽查检查
 */
- (void)updateSpotCheckId:(NSInteger)spotCheckId
                    param:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail ;
/**
 *  获取抽查检查列表
 */
- (void)getSpotCheckPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail ;
/**
 *  删除抽查检查
 */
- (void)deleteSpotCheckById:(NSInteger)spotCheckId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail ;
/**
 *  获取抽查检查详情
 */
- (void)detailSpotCheckById:(NSInteger)spotCheckId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

#pragma mark - 债券信息
/**
 *  获取债券信息列表
 */
- (void)getBondPage:(NSInteger)page
               size:(NSInteger)size
              rules:(NSArray *)rules
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))fail;
/**
 *  获取债券信息详情
 */
- (void)detailBondById:(NSInteger)bondId
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;

#pragma mark - 购地信息
/**
 *  获取购地信息列表
 */
- (void)getPurchasePage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/**
 *  获取购地信息详情
 */
- (void)detailPurchaseById:(NSInteger)purchaseId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 交易跟踪总览
/**
 *  获取交易跟踪
 */
- (void)getTrackingSituationListById:(NSInteger)memberId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

#pragma mark - 商务合同

/**
 *  创建商务合同
 */
- (void)createContractParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  获取商务合同列表
 */
- (void)getContractPage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/**
 *  删除商务合同
 */
- (void)deleteContractById:(NSInteger)contractId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;
/**
 *  获取商务合同详情
 */
- (void)detailContractById:(NSInteger)contractId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;



#pragma mark - 销售订单
/**
 *  获取销售订单列表
 */
- (void)getOrderPage:(NSInteger)page
                size:(NSInteger)size
               rules:(NSArray *)rules
   specialConditions:(NSArray *)specialConditions
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail;
/**
 *  发送销售订单列表
 */
- (void)getOrderSendPage:(NSInteger)page
                toUserId:(NSString *)toUserId
                    size:(NSInteger)size
                   rules:(NSArray *)rules
       specialConditions:(NSArray *)specialConditions
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  获取销售订单详情
 */
- (void)detailOrderById:(NSInteger)orderId
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

#pragma mark - 发货
/**
 *  获取发货列表
 */
- (void)getSapInvoicePage:(NSInteger)page
                     size:(NSInteger)size
                    rules:(NSArray *)rules
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;
/**
 *  获取发货详情
 */
- (void)detailSapInvoiceById:(NSInteger)sapInvoiceId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  添加发货影像
 */
- (void)addSapInvoiceAttachmentListById:(NSInteger)sapInvoiceId
                         attachmentList:(NSArray *)attachmentList
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;
#pragma mark - 发票
/**
 *  获取发票列表
 */
- (void)getSalesBillingPage:(NSInteger)page
                       size:(NSInteger)size
                      rules:(NSArray *)rules
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/**
 *  获取发票详情
 */
- (void)detailSalesBillingById:(NSInteger)salesBillingId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/**
 *  添加发票影像
 */
- (void)addSalesBillingAttachmentListById:(NSInteger)salesBillingId
                           attachmentList:(NSArray *)attachmentList
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail;
#pragma mark - 电汇
/**
 *  获取电汇列表
 */
- (void)getReceiptTrackingPage:(NSInteger)page
                          size:(NSInteger)size
                         rules:(NSArray *)rules
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/**
 *  获取电汇详情
 */
- (void)detailReceiptTrackingById:(NSInteger)receiptTrackingId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  添加电汇影像
 */
- (void)addReceiptAttachmentListById:(NSInteger)receiptId
                      attachmentList:(NSArray *)attachmentList
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;
#pragma mark - 外贸
/**
 *  获取外贸列表
 */
- (void)getForeignPage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;
/**
 *  获取外贸详情
 */
- (void)detailForeignById:(NSInteger)foreignId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

#pragma mark - 对账单
/**
 *  获取对账单列表
 */
- (void)getMonthyStatementPage:(NSInteger)page
                          size:(NSInteger)size
                         rules:(NSArray *)rules
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/**
 *  获取对账单详情
 */
- (void)detailMonthyStatementById:(NSInteger)monthyStatementId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/**
 *  添加对账单影像
 */
- (void)addMonthyStatementAttachmentListById:(NSInteger)monthyStatementId
                              attachmentList:(NSArray *)attachmentList
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail;

#pragma mark - 应用大全
/**
 *  获取常用列表
 */
- (void)getApplicationPageParam:(NSDictionary *)param
                          rules: (NSArray *)rules
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;
/**
 *  获取常用列表分层
 */
- (void)getApplicationItemPageParam:(NSDictionary *)param
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

#pragma mark - 任务协作
/**
 *  创建任务协作
 */
- (void)createTaskParam:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/**
 *  获取任务协作列表
 */
- (void)getTaskPageParam:(NSDictionary *)param
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  获取任务协作筛选条件
 */
- (void)getTaskConditionList:(NSDictionary *)param
                       rules:(NSArray *)rules
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  新建任务协作反馈
 */
- (void)createTaskComment:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

#pragma mark - 我的页面
- (void)getOperationInfoSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;

#pragma mark - 工厂列表
/**
 *  获取工厂列表
 *  @param page 页码
 *  @param size 大小
 *  @param rules 规则
 */
- (void)getFactoryPage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;
/**
 *  获取工厂列表筛选
 */
- (void)getFindFactoryPage:(NSInteger)page
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 收藏
/**
 *  获取收藏客户
 */
- (void)getFavoriteMemberPage:(NSInteger)page
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;
/**
 *  获取收藏订单
 */
- (void)getFavoriteOrderPage:(NSInteger)page
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  获取收藏任务
 */
- (void)getFavoriteTaskPage:(NSInteger)page
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

#pragma mark - 签到
/**
 *  签到
 */
- (void)createSignInParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 修改签到地址 */
- (void)updateSignInParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;
/**
 *  反馈
 */
- (void)createCommentApp:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;
/**
 *  要货计划排序
 */
- (void)getGatheringPlanFindSort:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

#pragma mark - 修改头像
/**
 *  客户头像修改
 */
- (void)memberUpdateAvatorParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;
/**
 *  操作员头像修改
 */
- (void)operatorAvatorUpdateParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

#pragma mark - 修改实控人

- (void)actualUpdateParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

- (void)dunningFailure:(id)param
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;

#pragma mark - 修改协助人
/**
 *  修改协助人
 */
- (void)changeAssistByMemberId:(NSInteger)memberId
                       operIds:(id)operIds
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  新建特价
 */
- (void)createSpecialRecordParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/**
 *  批号列表
 */
- (void)findBatchParam:(NSDictionary *)param
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail;

/**
 *  计划外要货
 */
- (void)createDemandRecordParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;

#pragma mark - 升级
/**
 *  创建版本（维护）
 */
- (void)createVersionParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;
/**
 *  检查版本更新
 */
- (void)checkVersionParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/**
 *  设置默认工厂
 */
- (void)getDefaultFactorySuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

#pragma mark - 客户价值评估
/** 获取客户价值评估 */
- (void)getWorthbeanMemberId:(long long)memberId
                         key:(NSString *)key
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

#pragma mark - 动态表单
/** 获取动态新建表单 */
- (void)getDynmicFormDynamicId:(NSString *)dynamicId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/** 动态新建 */
- (void)createDynmicFormDynamicId:(NSString *)dynamicId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/** 动态列表 */
- (void)getPageDynmicFormDynamicId:(NSString *)dynamicId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/** 动态获取详情表单 */
- (void)getDynmicFormDynamicId:(NSString *)dynamicId
                      detailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;


/** 动态获取详情 */
- (void)getObjDetailByDynamicId:(NSString *)dynamicId
                       detailId:(long long)detailId
                          param:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;

/** 动态删除某一条记录 */
- (void)deleteObjDetailByDynamicId:(NSString *)dynamicId
                          detailId:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/** 动态逻辑删除 */
- (void)batchDeleteObjDetailByDynamicId:(NSString *)dynamicId
                                  param:(NSMutableArray *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

/** 动态更新 */
- (void)updateDynmicFormDynamicId:(NSString *)dynamicId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;


#pragma mark - 人事组织
/** 获取人事组织结构 */
- (void)getLinkManOfficeByMemberId:(NSInteger)memberId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;
/** 获取客户下联系人 */
- (void)getLinkManListByMemberParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/** 获取部门下联系人 */
- (void)getLinkManListByOfficeParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/** 获取关联商机列表 */
- (void)getLinkManBusinessPageParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;
/** 获取关键需求列表 */
- (void)getLinkManPainPointPageParam:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;
/** 获取客户所有人数 */
- (void)getLinkManTotalCount:(long long)memberId
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

#pragma mark - 财务风险
/** 获取财务资金方块 */
- (void)getFinanceThirdMobileMemberId:(long long)memberId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;
/** 获取财务走势图 */
- (void)getFinanceBalanceAmountMemberId:(long long)memberId
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;
/** 获取客户余额分布 */
- (void)getFinanceBisdGroupByBurksMemberId:(long long)memberId
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;

#pragma mark - 采购状况
/** 获取采购状况汇总 */
- (void)getPurchaseSummaryNumberByMemberId:(long long)memberId
                                       key:(NSString *)key
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;
/** 获取供应商名录列表 */
- (void)getSupplierDirectoryPageByMemberId:(long long)memberId
                                     subId:(NSString *)subId
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;

#pragma mark - 生产状况
/** 获取生产状况汇总 */
- (void)getProductSummaryNumberByMemberId:(long long)memberId
                                      key:(NSString *)key
                                    param:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail;

#pragma mark - 销售状况
/** 获取销售状况汇总 */
- (void)getSalesSummaryNumberByMemberId:(long long)memberId
                                    key:(NSString *)key
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

#pragma mark - 研发状况
/** 获取研发状况汇总 */
- (void)getDevelopSummaryNumberByMemberId:(long long)memberId
                                      key:(NSString *)key
                                    param:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail;

#pragma mark - 合同跟踪
/** 获取合同跟踪汇总 */
- (void)getContractSummaryNumberByMemberId:(long long)memberId
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;

#pragma mark - 商务拜访
/** 获取商务拜访日历数据 */
- (void)getBusinessVisitActivityCalendarMemberId:(long long)memberId
                                         dateStr:(NSString *)dateStr
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail;
/** 获取商务拜访某一天数据 */
- (void)getBusinessVisitActivityListByCalendarMemberId:(long long)memberId
                                               dateStr:(NSString *)dateStr
                                                 param:(NSDictionary *)param
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))fail;
/** 获取商务拜访某一条记录详情 */
- (void)getBusinessVisitActivityDetailByDetailId:(long long)detailId
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail;
/** 删除商务拜访某一条记录 */
- (void)deleteBusinessVisitActivityByDetailId:(long long)detailId
                                        param:(NSDictionary *)param
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))fail;
/** 更新商务拜访状态 */
- (void)updateVisitActivityStatus:(NSString *)status
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;
/** 更新商务拜访沟通记录 */
- (void)updateVisitActivityCommunicateRecordParam:(NSDictionary *)param
                                          success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))fail;
#pragma mark - 商机跟进
/** 获取商机跟进汇总 */
- (void)getBusinessFollowSummaryNumberByMemberId:(long long)memberId
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail;

#pragma mark - 商务接待
/** 获取商务接待日历数据 */
- (void)getBusinessVisitReceptionCalendarMemberId:(long long)memberId
                                          dateStr:(NSString *)dateStr
                                            param:(NSDictionary *)param
                                          success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))fail;
/** 获取商务接待某一天数据 */
- (void)getBusinessVisitReceptionListByCalendarMemberId:(long long)memberId
                                                dateStr:(NSString *)dateStr
                                                  param:(NSDictionary *)param
                                                success:(void (^)(id responseObject))success
                                                failure:(void (^)(NSError *error))fail;

#pragma mark - 附件上传
/**
 *  附件上传
 *  list 附件数组
 */
- (void)fileUploadMultiParam:(NSDictionary *)param
                        list:(NSArray *)list
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;
/**
 *  附件上传
 *  attFiles 图片语音视频混合上传
 */
- (void)fileUploadMultiParam:(NSDictionary *)param
                    attFiles:(NSArray *)attFiles
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

- (void)downTaskWithUrlStr:(NSString *)urlStr
                    toPath:(NSString *)toPath
                     param:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 动态feed流
/** 获取动态Feel流 */
- (void)getFeedLowPageTrendParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;
/** 动态Feel流点赞 */
- (void)addFeedLikeRecord:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;
/** 动态Feel流取消点赞 */
- (void)removeFeedLikeRecordId:(long long)likeId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;


#pragma mark - 字典项feed列表

- (void)getDicListByName:(NSString *)name
                  remark:(NSString *)remark
                   param:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

#pragma mark - 情报大全
/** 获取情报大全列表 type:字段 */
- (void)getFeedBigItemPageType:(NSString *)type
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/** 手机端清单 */
- (void)getFeedBigItemPageMobileType:(NSString *)type
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/** 新建线索 */
- (void)createClueParam:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/** 修改线索 */
- (void)updateClueParam:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/** 关联活动 */
- (void)getMarketActivityPage:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/** 关联情报 */
- (void)getMarketIntelligenceItemPage:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;
/** 产品大类 */
- (void)getBigMaterialTypePage:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/** 获取部门 */
- (void)getDepartmentPage:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 关联情报 */
- (void)createLinkActivityByDetailId:(long long)detailId
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/** 关联线索 */
- (void)getClueItemPage:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/** 关联情报列表 */
- (void)getLinkActivityPageByDetailId:(long long)detailId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

/** 修改单个关联情报 */
- (void)updateIntelligenceItemDetailParam:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail;


/** 删除单个关联情报 */
- (void)deleteIntelligenceItemDetailId:(long long)detailId
                                 param:(NSDictionary *)param
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail;

/** 获取单个关联情报详情 */
- (void)getIntelligenceItemDetailId:(long long)detailId
                              param:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail;

/** 获取线索详情 */
- (void)getClueDetailId:(long long)detailId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;
/** 获取样品详情 */
- (void)getSampleDetailId:(long long)detailId
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 获取商机详情 */
- (void)getBusinessChangeDetailId:(long long)detailId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/** 修改商机详情 */
- (void)updateBusinessChangeParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/** 新建报价 */
- (void)createQuotedPriceParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 获取报价详情 */
- (void)getQuotedPriceDetailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 修改报价 */
- (void)updateQuotedPriceParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 新建联系人 */
- (void)createPersonalParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 联系人详情 */
- (void)getPersonalDetailId:(long long)detailId
                      param:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 修改联系人 */
- (void)updatePersonalParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 删除联系人 */
- (void)deletePersonalDetailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 新建回复 */
- (void)updateReplayPointMessageParam:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

/** 新建痛点 */
- (void)createPainPointParam:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/** 获取国家列表 */
- (void)getCountryListParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 新建工作圈动态 */
- (void)createWorkingCircleParam:(NSDictionary *)param
                           isAll:(BOOL)isAll
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/** 获取用户详情 */
- (void)getOperatorDetail:(NSInteger)contactId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 获取竞争对手详情 */
- (void)getCompetitorBehaviorDetailId:(long long)detailId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

/** 修改密码 */
- (void)updatePasswordParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 意见反馈 */
- (void)createFeedBackParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;

/** 获取用户日历 */
- (void)getCurrentUserVisitCalendarDateStr:(NSString *)dateStr
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;

/** 获取用户某天日程 */
- (void)getCurrentVisitPageParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/** 获取用户接待日历 */
- (void)getCurrentUserReceptionCalendarDateStr:(NSString *)dateStr
                                         param:(NSDictionary *)param
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))fail;

/** 获取用户某天接待日程 */
- (void)getCurrentReceptionPageParam:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;

/** 新增浏览记录 */
- (void)viewRecordCreate:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/** 获取客户协助人列表 */
- (void)getMemberAssistFindOperatorMemberId:(long long)memberId
                                      param:(NSDictionary *)param
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))fail;
/** 新建客户协助人 */
- (void)createMemberAssistParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;

/** 删除客户协助人 */
- (void)deleteMemberAssistId:(long long)deleteId
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;

/** 获取签到记录 */
- (void)getSignInPageParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 零售工作计划
/** 新建零售工作计划 */
- (void)createRetailChannelParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/** 更新零售工作计划 */
- (void)updateRetailChannelParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail;

/**  获取零售工作计划详情 */
- (void)getRetailChannelDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 获取零售工作计划列表 */
- (void)getRetailChannelPageParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/** 获取月销售目标 */
- (void)getWorkPlanTargetByOperatorType:(NSString *)type
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

/** 获取月销售目标(省份+品牌) */
- (void)getWorkPlanTargetAreaByOperatorType:(NSString *)type
                                      param:(NSDictionary *)param
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))fail;

/** 获取零售渠道单个走访客户详情 */
- (void)getRetailChannelItemDetail:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/** 删除工作计划 */
- (void)detailWorkPlanType:(NSString *)type
                       ids:(NSArray *)ids
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

#pragma mark - 渠道开发计划

/** 获取渠道开发工作计划列表 */
- (void)getChannelDevelopPageParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/**  获取渠道工作计划详情 */
- (void)getChannelDevelopDetail:(long long)detailId
                          param:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;

/** 新建渠道开发工作计划列表 */
- (void)createChannelDevelopParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail;

/** 更新渠道开发工作计划列表 */
- (void)updateChannelDevelopDetailId:(long long)detailId
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;
/** 获取当月累计拜访量 */
- (void)getChannelDevelopSumAccumulateVisitProvince:(NSString *)province
                                              param:(NSDictionary *)param
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))fail;
/** 获取当天服务器日期 */
- (void)getDateTodayParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

#pragma mark - 市场部工作计划
/** 获取市场部工作计划详情 */
- (void)getMarketEngineeringDetail:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail;

/** 获取当月累计发货量 */
- (void)getMarketEngineeringSumAccumulateVisitParam:(NSDictionary *)param
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))fail;
#pragma mark - 战略部工作计划
/** 获取市场部工作计划详情 */
- (void)getStrategicEngineeringDetail:(long long)detailId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail;

#pragma mark - 直营工程部计划
/** 获取直营工程部计划详情 */
- (void)getDirectSalesEngineeringDetail:(long long)detailId
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;
/** 获取当月累计回款 */
- (void)getSumActuallShipmentDirectSaleProvince:(NSString *)province
                                          param:(NSDictionary *)param
                                        success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))fail;
#pragma mark - 能诚计划
/** 获取能诚计划详情 */
- (void)getNengchengDetail:(long long)detailId
                     param:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;
/** 获取能诚开发目标 */
- (void)getNengchengSumAccumulateVisitProvince:(NSString *)province
                                         param:(NSDictionary *)param
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))fail;
/** 获取能诚单个走访客户详情 */
- (void)getNengchengItemDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;
/** 获取能诚当月累计发货量 */
- (void)getNengchengSumActualShipmentParam:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail;
#pragma mark - 华爵计划
/** 获取华爵计划详情 */
- (void)getHuajueDetail:(long long)detailId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/** 获取能诚单个走访客户附件详情 */
- (void)getHuajueItemDetail:(long long)detailId
                      param:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail;
/** 获取华爵当月累计发货量 */
- (void)getHuajueSumActualShipmentParam:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail;

#pragma mark - 金木门
/** 获取金木门计划详情 */
- (void)getJinMuMenDetail:(long long)detailId
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;


/** 获取能诚单个走访客户附件详情 */
- (void)getJinMuMenItemDetail:(long long)detailId
                        param:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/** 通用工作计划获取 当月累计销售额和当日实际销售额 */
- (void)GET_SAP_SALES_BY_WORK_PLAN_Param:(NSDictionary *)param
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail;

#pragma mark - 获取省份
/** 获取省份 */
- (void)getProvincePageByParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/**
 *  获取当月累计发货量
 *  @param type  工作类型
 *  @param province 省份
 *  @param param 其他参数
 */
- (void)getWorkSumAcutalShipmentType:(NSString *)type
                            province:(NSString *)province
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail;


/** 所有获取 当日实际发货量和当月累计发货量 */
- (void)GET_SAP_SALES_BY_BRAND_AND_YEAR_Param:(NSDictionary *)param
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail;

/** 具体某个 当日实际发货量和当月累计发货量 */
- (void)GET_SAP_SALES_BY_BRAND_AND_YEAR_Type:(NSString *)type
                                       param:(NSDictionary *)param
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail;

/** 获取品牌列表 */
- (void)getBrandPageParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 零售计划根据地址带出走访客户 */
- (void)findCarefulAreaParam:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;


/** 根据邮编获取行政地址 */
- (void)getChinessAddressParam:(NSDictionary *)param
                          code:(NSString *)code
                      codeType:(NSInteger)codeType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;

/** 根据id获取客户详情 */
- (void)getMemberDetailParam:(NSDictionary *)param
                    memberId:(long long)memberId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail;


/** 获取差旅标准 */
- (void)getBxbzFroCrmParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail;

/** 新建门店 */
- (void)createStoreParam:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/** 获取门店详情 */
- (void)getStoreDetailId:(long long)detailId
                   param:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail;

/** 根据省id获取省对象 */
- (void)getProvinceByProvinceId:(NSString *)provinceId
                          param:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail;
/** 根据市id获取市对象 */
- (void)getCityByCityId:(NSString *)cityId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/** 根据区id获取区对象 */
- (void)getAreaByAreaId:(NSString *)areaId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail;

/** 根据省份获取当日发货量 */
- (void)getDailyDeveliveryByWorkType:(NSString *)workType
                        provinceName:(NSString *)provinceName
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail ;
/** 根据省份获取未履行工程 */
- (void)getMarketEngineeringRequireEngineerParam:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail;

/** 获取差旅到达地 */
- (void)getTravelCityListParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail;


/** 市接口 */
- (void)queryCityPageType:(NSInteger)type
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail;

/** 获取通用工作计划详情 */
- (void)getCommonWorkPlanById:(long long)workPlanId
                        param:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/** 获取通用工作计划单个走访客户详情 */
- (void)getWorkPlanItemDetail:(long long)detailId
                        param:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail;

/** 获取开发目标 */
- (void)getWorkPlanSumAccumulateVisitProvince:(NSString *)province
                                        param:(NSDictionary *)param
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))fail;
/** 获取当月累计发货量 */
- (void)getWorkPlanSumAcutalShipmentType:(NSString *)workType
                                province:(NSString *)province
                                   param:(NSDictionary *)param
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail;

@end
