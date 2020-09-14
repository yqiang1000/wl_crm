//
//  JYUserApi.m
//  Wangli
//
//  Created by yeqiang on 2018/4/10.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "JYUserApi.h"
#import "ApiTool.h"
#import "URLConfig.h"
#import "CusInfoMo.h"
#import "CountryMo.h"
#import "BrandMo.h"

static JYUserApi *userApi = nil;

@interface JYUserApi ()

@property (nonatomic, strong) NSMutableDictionary *customerParamsCache;
@property (nonatomic, strong) NSMutableDictionary *searchParamsCache;

@end

@implementation JYUserApi

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userApi = [[JYUserApi alloc] init];
    });
    return userApi;
}

+ (void)releaseCustomerParamsCache {
    [JYUserApi sharedInstance].customerParamsCache = nil;
}

+ (void)releaseSearchParamsCache {
    [JYUserApi sharedInstance].searchParamsCache = nil;
}

+(NSString *) getDeviceId
{
    return [ApiTool getDeviceId];
}

-(long long) diffTimestamp
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:DIFF_TIMESTAMP]) {
        _diffTimestamp = [[[NSUserDefaults standardUserDefaults] objectForKey:DIFF_TIMESTAMP] longLongValue];
    }
    return _diffTimestamp;
}

-(NSMutableDictionary *) baseParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"ios" forKey:@"fromClientType"];
    return params;
}


-(void) setToken:(NSString *)token
{
    _token = token;
    [ApiTool setToken:token];
}

- (void)login:(NSString *)mobile smsCode:(NSString *)smsCode success:(void (^)(id))success failure:(void (^)(NSError *))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(mobile) forKey:@"username"];
    [params setObject:STRING(smsCode) forKey:@"password"];
    [ApiTool postWithUrl:LOGIN andParams:params success:success failure:fail];
}

- (void)getSMSCodeByMobile:(NSString *)mobile success:(void (^)(id))success failure:(void (^)(NSError *))fail {
//    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%@",GET_SMS_CODE, mobile] andParams:nil success:success failure:fail];
}


//- (void)getUserSign:(NSString *)userName success:(void (^)(id))success failure:(void (^)(NSError *))fail {
//    NSMutableDictionary *params = [self baseParams];
//    
//    [ApiTool getUserSignWithUrl:[NSString stringWithFormat:@"%@%@", GET_USER_SIGN, userName] andParams:params success:success failure:fail];
//}

- (void)getCustomerListDirection:(NSString *)direction
                        property:(NSString *)property
                            size:(NSInteger)size
                           rules:(NSArray *)rules
                            page:(NSInteger)page
                specialDirection:(NSString *)specialDirection
               specialConditions:(NSArray *)specialConditions
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    if (!_customerParamsCache) {
        NSMutableDictionary *params = [self baseParams];
        [params setObject:@(size) forKey:@"size"];
        [params setObject:@(page) forKey:@"number"];
        [params setObject:@"DESC" forKey:@"direction"];
        [params setObject:@"createdDate" forKey:@"property"];
        if (specialDirection.length > 0) {
            [params setObject:STRING(specialDirection) forKey:@"specialDirection"];
        }
        [params setObject:STRING(rules) forKey:@"rules"];
        if (specialConditions.count > 0) {
            [params setObject:STRING(specialConditions) forKey:@"specialConditions"];
        }
        _customerParamsCache = [NSMutableDictionary new];
        _customerParamsCache = params;
    }
    [_customerParamsCache setObject:@(page) forKey:@"number"];
    [ApiTool postWithUrl:GET_CUSTOMER_LIST andParams:_customerParamsCache success:success failure:fail];
}

- (void)searchCustomerListPage:(NSInteger)page
                          size:(NSInteger)size
                         rules:(NSArray *)rules
                       keyword:(NSString *)keyword
             specialConditions:(NSArray *)specialConditions
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    if (!_searchParamsCache) {
        NSMutableDictionary *params = [self baseParams];
        [params setObject:@(size) forKey:@"size"];
        [params setObject:@(page) forKey:@"number"];
        [params setObject:@"DESC" forKey:@"direction"];
        [params setObject:@"createdDate" forKey:@"property"];
        if (specialConditions.count > 0) {
            [params setObject:STRING(specialConditions) forKey:@"specialConditions"];
        }
        [params setObject:STRING(rules) forKey:@"rules"];
        _searchParamsCache = [NSMutableDictionary new];
        _searchParamsCache = params;
    }
    [_searchParamsCache setObject:@(page) forKey:@"number"];
    [ApiTool postWithUrl:GET_CUSTOMER_LIST andParams:_searchParamsCache success:success failure:fail];
}

- (void)getDepartmentSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
//    NSArray *arr = @[@{@"field":@"salesman.id",
//                       @"option":@"EQ",
//                       @"values":@[@"46"]}];
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5000" forKey:@"size"];
    [params setObject:@"ASC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
//    [params setObject:arr forKey:@"rules"];
    [ApiTool postWithUrl:GET_COMPANY_DEPARTMENT andParams:params success:success failure:fail];
}

- (void)getDepartmentPersonRules:(NSArray *)rules
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5000" forKey:@"size"];
    [params setObject:@"ASC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_COMPANY_PEOPLE andParams:params success:success failure:fail];
}

- (void)getOperaterListParam:(NSDictionary *)param
                       rules:(NSArray *)rules
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_PEOPLE_PAGE andParams:params success:success failure:fail];
}

- (void)getTaskCollaboratorRules:(NSArray *)rules
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
//    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5000" forKey:@"size"];
//    [params setObject:@"ASC" forKey:@"direction"];
//    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_TASK_COLLABORATOR andParams:params success:success failure:fail];
}

- (void)getTaskReceiverRules:(NSArray *)rules
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
//    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5000" forKey:@"size"];
//    [params setObject:@"ASC" forKey:@"direction"];
//    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_TASK_RECEIVER andParams:params success:success failure:fail];
}

- (void)getImportPersonParam:(NSDictionary *)param
                       rules:(NSArray *)rules
                 trueOrFalse:(NSString *)trueOrFallse
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_IMPORT_PERSON andParams:params success:success failure:fail];
}

- (void)getMemberChooseSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:GET_MEMBER_CHOOSE andParams:params success:success failure:fail];
}

- (void)getMemberFindId:(NSInteger)customId
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", GET_MEMBER_FIND, customId] andParams:params success:success failure:fail];
}

- (void)getContentPageByCustomerId:(NSInteger)customerId
                              page:(NSInteger)page
                              size:(NSInteger)size
                         direction:(NSString *)direction
                         contentId:(NSInteger)contentId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"ASC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"member.id" forKey:@"field"];
    [dic setObject:@"EQ" forKey:@"option"];
    [dic setObject:@[@(customerId)] forKey:@"values"];
    [arr addObject:dic];
    [params setObject:arr forKey:@"rules"];
    [ApiTool postWithUrl:GET_CONTENT_PAGE andParams:params success:success failure:fail];
}

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
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@"CONTACTPERSON" forKey:@"type"];
    [params setObject:STRING(name) forKey:@"name"];
    [params setObject:STRING(title) forKey:@"title"];
    
    [params setObject:STRING(sex) forKey:@"sex"];
    [params setObject:STRING(birthday) forKey:@"birthday"];
    [params setObject:STRING(email) forKey:@"email"];
    [params setObject:STRING(address) forKey:@"address"];
    [params setObject:STRING(duty) forKey:@"duty"];
    [params setObject:STRING(office) forKey:@"office"];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    [params setObject:@(import) forKey:@"important"];
    NSArray *arr = @[@"phoneOne", @"phoneTwo", @"phoneThree", @"phoneFour"];
    for (int i = 0; i < arrPhone.count; i++) {
        [params setObject:STRING(arrPhone[i]) forKey:STRING(arr[i])];
    }
    [ApiTool postWithUrl:CONTACT_CREATE andParams:params success:success failure:fail];
}

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
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@"CONTACTPERSON" forKey:@"type"];
    [params setObject:@(contactId) forKey:@"id"];
    [params setObject:STRING(name) forKey:@"name"];
    [params setObject:STRING(title) forKey:@"title"];
    
    [params setObject:STRING(sex) forKey:@"sex"];
    [params setObject:STRING(birthday) forKey:@"birthday"];
    [params setObject:STRING(email) forKey:@"email"];
    [params setObject:STRING(address) forKey:@"address"];
    [params setObject:STRING(office) forKey:@"office"];
    [params setObject:STRING(duty) forKey:@"duty"];
    [params setObject:@(import) forKey:@"important"];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    
    NSArray *arr = @[@"phoneOne", @"phoneTwo", @"phoneThree", @"phoneFour"];
    for (int i = 0; i < arrPhone.count; i++) {
        [params setObject:STRING(arrPhone[i]) forKey:STRING(arr[i])];
    }
    
    [ApiTool putWithUrl:CONTACT_UPDATE andParams:params success:success failure:fail];
}

- (void)getContactDetailById:(NSInteger)contactId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", CONTACT_DETAIL, contactId] andParams:params success:success failure:fail];
}

- (void)deleteContactDetailById:(NSInteger)contactId
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", CONTACT_DELETE, contactId] andParams:params success:success failure:fail];
}

- (void)searchContactListByKeyword:(NSString *)keyword
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(keyword) forKey:@"keyword"];
    [ApiTool postWithUrl:CONTACT_SEARCH andParams:params success:success failure:fail];
}

- (void)getContactListParam:(NSDictionary *)param
                      rules:(NSArray *)rules
                   toUserId:(NSString *)toUserId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%@", CONTACT_SEARCH_PAGE_SEND_ABLE, toUserId] andParams:params success:success failure:fail];
}

- (void)getAddressPageByCustomerId:(NSInteger)customerId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5000" forKey:@"size"];
    [params setObject:@"ASC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    [dic setObject:@"member.id" forKey:@"field"];
    [dic setObject:@"EQ" forKey:@"option"];
    [dic setObject:@[@(customerId)] forKey:@"values"];
    [arr addObject:dic];
    [params setObject:arr forKey:@"rules"];
    [ApiTool postWithUrl:GET_ADDRESS_PAGE andParams:params success:success failure:fail];
}

- (void)deleteAddressAddressId:(NSInteger)addressId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld",ADDRESS_DELETE, addressId] andParams:params success:success failure:fail];
}

- (void)riskWarnStatisticsByCustomId:(NSInteger)customerId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",RISK_WARN_STATISTICS, customerId] andParams:params success:success failure:fail];
}

- (void)getQiNiuUploadTokenSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:QINIU_UPLOAD_TOKEN andParams:params success:success failure:fail];
}

- (void)getQiNiuUploadTokenOpenSuccess:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:QINIU_UPLOAD_TOKEN_OPEN andParams:params success:success failure:fail];
}

- (void)getCustomerInfoByCustomId:(NSInteger)customerId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",GET_ACTUAL_PERSON_INFO, customerId] andParams:params success:success failure:fail];
}

- (void)getCustomerOrgInfoByCustomId:(NSInteger)customerId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",GET_MEMBER_ORG_INFO, customerId] andParams:params success:success failure:fail];
}

- (void)updateCustomerByCustomId:(NSInteger)customerId
                           field:(NSString *)field
                           value:(NSString *)value
                           param:(NSMutableDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(customerId) forKey:@"id"];
    [params setObject:STRING(field) forKey:@"field"];
    [params setObject:STRING(value) forKey:@"value"];
    [params removeObjectForKey:@"fromClientType"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:MEMBER_UPDATE andParams:params success:success failure:fail];
}

- (void)updateCustomerPersonInfo:(NSString *)personId
                           field:(NSString *)field
                           value:(NSString *)value
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(personId) forKey:@"id"];
    [params setObject:STRING(field) forKey:@"field"];
    [params setObject:STRING(value) forKey:@"value"];
    [params removeObjectForKey:@"fromClientType"];
    [ApiTool putWithUrl:MEMBER_UPDATE andParams:params success:success failure:fail];
}

- (void)createAddressByCustomId:(NSInteger)customerId
                       phoneOne:(NSString *)phoneOne
                        areaIds:(NSArray *)areaIds
                      areaNames:(NSArray *)areaNames
                       receiver:(NSString *)receiver
                        address:(NSString *)address
                       defaults:(BOOL)defaults
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@{@"id":@(customerId)} forKey:@"member"];
    [params setObject:STRING(phoneOne) forKey:@"phoneOne"];
    [params setObject:STRING(address) forKey:@"address"];
    [params setObject:STRING(receiver) forKey:@"receiver"];
    if (areaNames.count == 3 || areaIds.count == 3) {
        [params setObject:STRING(areaNames[0]) forKey:@"provinceName"];
        [params setObject:STRING(areaNames[1]) forKey:@"cityName"];
        [params setObject:STRING(areaNames[2]) forKey:@"areaName"];
        
        [params setObject:STRING(areaIds[0]) forKey:@"provinceNumber"];
        [params setObject:STRING(areaIds[1]) forKey:@"cityNumber"];
        [params setObject:STRING(areaIds[2]) forKey:@"areaNumber"];
    }
    [params setObject:@(defaults) forKey:@"defaults"];
    
    [ApiTool postWithUrl:ADDRESS_CREATE andParams:params success:success failure:fail];
}


- (void)updateAddressByCustomId:(NSInteger)customerId
                      addressId:(NSInteger)addressId
                       phoneOne:(NSString *)phoneOne
                        areaIds:(NSArray *)areaIds
                      areaNames:(NSArray *)areaNames
                       receiver:(NSString *)receiver
                        address:(NSString *)address
                       defaults:(BOOL)defaults
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@{@"id":@(customerId)} forKey:@"member"];
    [params setObject:@(addressId) forKey:@"id"];
    [params setObject:STRING(phoneOne) forKey:@"phoneOne"];
    [params setObject:STRING(address) forKey:@"address"];
    [params setObject:STRING(receiver) forKey:@"receiver"];
    if (areaNames.count == 3 || areaIds.count == 3) {
        [params setObject:STRING(areaNames[0]) forKey:@"provinceName"];
        [params setObject:STRING(areaNames[1]) forKey:@"cityName"];
        if ([areaNames[2] isEqualToString:@"-"]) {
            [params setObject:@"" forKey:@"areaName"];
        } else {
            [params setObject:STRING(areaNames[2]) forKey:@"areaName"];
        }
        
        [params setObject:STRING(areaIds[0]) forKey:@"provinceNumber"];
        [params setObject:STRING(areaIds[1]) forKey:@"cityNumber"];
        [params setObject:STRING(areaIds[2]) forKey:@"areaNumber"];
    }
    [params setObject:@(defaults) forKey:@"defaults"];
    
    [ApiTool putWithUrl:ADDRESS_UPDATE andParams:params success:success failure:fail];
}

- (void)getChoseContentLIstByCustomId:(NSInteger)customerId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",CHOSE_CONTENT_LIST, customerId] andParams:params success:success failure:fail];
}

- (void)getRiskWarnPageByCustomerId:(NSInteger)customerId
                             number:(NSInteger)number
                               size:(NSInteger)size
                          direction:(NSString *)direction
                           property:(NSString *)property
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(number) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"createdDate" forKey:@"property"];
    [params setObject:STRING(rules) forKey:@"rules"];
    [ApiTool postWithUrl:RISK_WARN_PAGE andParams:params success:success failure:fail];
}

- (void)getFeedFlowPageByCustomerId:(NSInteger)customerId
                             number:(NSInteger)number
                               size:(NSInteger)size
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(number) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"createdDate" forKey:@"property"];
    [params setObject:STRING(rules) forKey:@"rules"];
    [ApiTool postWithUrl:FEED_FLOW_PAGE andParams:params success:success failure:fail];
}

- (void)getRiskWarnDetailRiskId:(NSInteger)riskId
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", RISK_WARN_DETAIL, riskId] andParams:params success:success failure:fail];
}

- (void)deleteRiskWarnDetailRiskId:(long long)riskId
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%lld", RISK_WARN_DELETE, riskId] andParams:params success:success failure:fail];
}


- (void)createRiskWarnParam:(NSDictionary *)param
             attachmentList:(NSArray *)attachmentList
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (attachmentList.count > 0) [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool postWithUrl:RISK_WARN_CREATE andParams:params success:success failure:fail];
}

- (void)updateRiskWarnByRiskId:(NSInteger)riskId
                         param:(NSDictionary *)param
                attachmentList:(NSArray *)attachmentList
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail{
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (attachmentList.count > 0) [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool putWithUrl:RISK_WARN_UPDATE andParams:params success:success failure:fail];
}

- (void)getCreditCountByCustomerId:(NSInteger)customerId
                          yearStr:(NSString *)yearStr
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",GET_CREDIT_COUNT, customerId] andParams:params success:success failure:fail];
}

- (void)getCreditSameCompanyByCustomerId:(NSInteger)customerId
                                 yearStr:(NSString *)yearStr
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",SAME_COMPANY_LIST, customerId] andParams:params success:success failure:fail];
}

- (void)getCreditHeaderByCustomerId:(NSInteger)customerId
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",CREDIT_HEADER, customerId] andParams:params success:success failure:fail];
}

- (void)getCreditFooterByCustomerId:(NSInteger)customerId
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",CREDIT_FOOTER, customerId] andParams:params success:success failure:fail];
}

- (void)getCreditDeptAccountByCustomerId:(NSInteger)customerId
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",CUST_DEPT_ACCOUNT, customerId] andParams:params success:success failure:fail];
}

- (void)createAccountApplyByParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:ACCOUNT_APPLY andParams:params success:success failure:fail];
}

- (void)createPayPlanByCustomerId:(NSInteger)customerId
                             year:(NSString *)year
                            month:(NSString *)month
                         quantity:(NSString *)quantity
                   receivedAmount:(NSString *)receivedAmount
                  planTotalAmount:(NSString *)planTotalAmount
                           remark:(NSString *)remark
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(year) forKey:@"year"];
    [params setObject:STRING(month) forKey:@"month"];
    [params setObject:STRING(quantity) forKey:@"quantity"];
    [params setObject:STRING(remark) forKey:@"remark"];
    [params setObject:STRING(receivedAmount) forKey:@"receivedAmount"];
    [params setObject:STRING(planTotalAmount) forKey:@"planTotalAmount"];
    [params setObject:@{@"id":@(customerId)} forKey:@"member"];
    [ApiTool postWithUrl:GATHERING_PLAN_CREATE andParams:params success:success failure:fail];
}

- (void)getPayPlanDetail:(NSInteger)payPlanId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", GATHERING_PLAN_DETAIL, payPlanId] andParams:params success:success failure:fail];
}

- (void)getCusDeptByCustomerId:(NSInteger)customerId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", GATHERING_CUST_DEPT, customerId] andParams:params success:success failure:fail];
}

- (void)getReceiveCountCustomerId:(NSInteger)customerId
                        yearMonth:(NSString *)yearMonth
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld/%@", GATHERING_PLAN_RECEIVE_COUNT, customerId, yearMonth] andParams:params success:success failure:fail];
}

- (void)getGatheringPlanPageByParam:(NSDictionary *)param
                               page:(NSInteger)page
                               size:(NSInteger)size
                              rules:(NSArray *)rules
                  specialConditions:(NSArray *)specialConditions
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:STRING(rules) forKey:@"rules"];
    [params addEntriesFromDictionary:param];
    if (specialConditions.count > 0) [params setObject:specialConditions forKey:@"specialConditions"];
    [ApiTool postWithUrl:GATHERING_PLAN_PAGE andParams:params success:success failure:fail];
}

- (void)updateGatheringPlanByPlanId:(NSInteger)planId
                           memberId:(NSInteger)memberId
                               year:(NSString *)year
                              month:(NSString *)month
                           quantity:(NSString *)quantity
                     receivedAmount:(NSString *)receivedAmount
                    planTotalAmount:(NSString *)planTotalAmount
                             remark:(NSString *)remark
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(planId) forKey:@"id"];
    [params setObject:STRING(year) forKey:@"year"];
    [params setObject:STRING(month) forKey:@"month"];
    [params setObject:STRING(quantity) forKey:@"quantity"];
    [params setObject:STRING(receivedAmount) forKey:@"receivedAmount"];
    [params setObject:STRING(planTotalAmount) forKey:@"planTotalAmount"];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    [params setObject:STRING(remark) forKey:@"remark"];
    [ApiTool putWithUrl:GATHERING_PLAN_UPDATE andParams:params success:success failure:fail];
}

- (void)deleteGatheringPlanByPlanId:(NSInteger)planId
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", GATHERING_PLAN_DELETE,planId] andParams:params success:success failure:fail];
}


- (void)getGatheringLineChartByMemberId:(NSInteger)memberId
                                   year:(NSString *)year
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", GATHERING_LINE_CHART, memberId] andParams:params success:success failure:fail];
}

- (void)getConfigDicByName:(NSString *)name
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%@", LIST_RISK_TYPE, name] andParams:params success:success failure:fail];
}

- (void)getConfigDicByName:(NSString *)name
                       key:(NSString *)key
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:GET_DIC_LIST_NAME_KEY, STRING(name), STRING(key)] andParams:params success:success failure:fail];
}

- (void)getMemberCenterByMemberId:(NSInteger)memberId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", GET_MEMBER_CENTER, memberId] andParams:params success:success failure:fail];
}

- (void)getLabelPage:(NSInteger)memberId
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool postWithUrl:LABEL_PAGE andParams:params success:success failure:fail];
}

- (void)createLabelMemberId:(NSInteger)memberId
                       desp:(NSString *)desp
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(desp) forKey:@"desp"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%ld", LABEL_ADD, memberId] andParams:params success:success failure:fail];
}

- (void)removeLabelMemberId:(NSInteger)memberId
                       labId:(NSInteger)labId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld/%ld", LABEL_REMOVE, memberId, labId] andParams:params success:success failure:fail];
}


- (void)getMemberSystemInfoByMemberId:(NSInteger)memberId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", MEMBER_FIND_SYS_INFO, memberId] andParams:params success:success failure:fail];
}

- (void)getMemberRadarChatMemberId:(NSInteger)memberId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", MEMBER_RADAR_CHAT, memberId] andParams:params success:success failure:fail];
}

- (void)getInvoiceChartMobileByMemberId:(NSInteger)memberId
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", FIND_INVOICE_CHART_MOBILE, memberId] andParams:params success:success failure:fail];
}

- (void)getMaterialList:(NSInteger)customId
                   page:(NSInteger)page
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(30) forKey:@"size"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%ld", MATERIAL_BATCH_NUMBER_PAGE, customId] andParams:params success:success failure:fail];
}

- (void)getMaterialPriceByCustomerId:(NSInteger)customId
                          materialId:(NSInteger)materialId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld/%ld", PRICE_FIND_ONE, materialId, customId] andParams:params success:success failure:fail];
}

- (void)getBatchNumberWeightPageParam:(NSDictionary *)param
                                rules:(NSArray *)rules
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:DEMAND_PLAN_BATCH_WEIGHT andParams:params success:success failure:fail];
}

- (void)createDealPlanByCustomerId:(NSInteger)customerId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) {
        [params addEntriesFromDictionary:param];
    }
    [ApiTool postWithUrl:DEMAND_PLAN_CREATE andParams:params success:success failure:fail];
}

- (void)getDemandPlanPageByParam:(NSDictionary *)param
                            page:(NSInteger)page
                            size:(NSInteger)size
                           rules:(NSArray *)rules
               specialConditions:(NSArray *)specialConditions
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:STRING(rules) forKey:@"rules"];
    [params addEntriesFromDictionary:param];
    if (specialConditions.count > 0) [params setObject:specialConditions forKey:@"specialConditions"];
    
    [ApiTool postWithUrl:GET_DEMAND_PLAN_PAGE andParams:params success:success failure:fail];
}

- (void)updateDemandPlanByPlanId:(NSInteger)planId
                           param:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(planId) forKey:@"id"];
    if (param.count > 0) {
        [params addEntriesFromDictionary:param];
    }
    [ApiTool putWithUrl:DEMAND_PLAN_UPDATE andParams:params success:success failure:fail];
}

- (void)getDemandPlanDetailByPlanId:(NSInteger)planId
                              param:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) {
        [params addEntriesFromDictionary:param];
    }
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", DEMAND_PLAN_DETAIL, planId] andParams:params success:success failure:fail];
}

- (void)deleteDemandPlanByPlanId:(NSInteger)planId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", DEMAND_PLAN_DELETE, planId] andParams:params success:success failure:fail];
}

- (void)getDemandPlanCollectPageByParam:(NSDictionary *)param
                           rules:(NSArray *)rules
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:DEMAND_FIND_COLLECT andParams:params success:success failure:fail];
}

- (void)getCollectionSendTotal:(NSDictionary *)param
                         rules:(NSArray *)rules
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:DEMAND_FIND_COLLECT_TWO andParams:params success:success failure:fail];
}

- (void)getDemandPlanDetailPageByPager:(NSDictionary *)pager
                   operatorCollectBean:(NSDictionary *)operatorCollectBean
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (pager.count > 0) [params setObject:pager forKey:@"pager"];
    if (operatorCollectBean.count > 0) [params setObject:operatorCollectBean forKey:@"operatorCollectBean"];
    [ApiTool postWithUrl:DEMAND_FIND_DETAIL andParams:params success:success failure:fail];
}

- (void)createDemandByBatchByParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:DEMAND_CREATE_BY_BATCH andParams:params success:success failure:fail];
}

- (void)getDemandPreBatchListParam:(NSDictionary *)param
                          memberId:(NSInteger)memberId
                         yearMonth:(NSString *)yearMonth
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld/%@", DEMAND_PRE_BATCH, memberId, yearMonth] andParams:params success:success failure:fail];
}

- (void)marketTrendStatisticsByCustomId:(NSInteger)customerId
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",MARKET_TREND_STATISTICS, customerId] andParams:params success:success failure:fail];
}

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
                             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@{@"id":@(customerId)} forKey:@"member"];
    [params setObject:@{@"id":@(operatorIdId)} forKey:@"operator"];
    [params addEntriesFromDictionary:type];
    [params setObject:@{@"id":@(important)} forKey:@"important"];
    [params setObject:STRING(title) forKey:@"title"];
    [params setObject:STRING(content) forKey:@"content"];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    [params setObject:STRING(attachmentList) forKey:@"attachmentList"];
    
    if (departments.count > 0) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSString *x in departments) {
            [arr addObject:@{@"id":STRING(x)}];
        }
        [params setObject:STRING(arr) forKey:@"departments"];
    }
    [ApiTool postWithUrl:MARKET_TREND_CREATE andParams:params success:success failure:fail];
}

- (void)getMarketTrendPageByCustomerId:(NSInteger)customerId
                                number:(NSInteger)number
                                  size:(NSInteger)size
                             direction:(NSString *)direction
                              property:(NSString *)property
                                 rules:(NSArray *)rules
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(number) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"createdDate" forKey:@"property"];
    [params setObject:STRING(rules) forKey:@"rules"];
    [ApiTool postWithUrl:MARKET_TREND_PAGE andParams:params success:success failure:fail];
}

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
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(markId) forKey:@"id"];
    [params addEntriesFromDictionary:type];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
//    [params setObject:@{@"id":@(important)} forKey:@"important"];
    [params setObject:STRING(title) forKey:@"title"];
    [params setObject:STRING(content) forKey:@"content"];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    [params setObject:STRING(attachmentList) forKey:@"attachmentList"];
    
    if (departments.count > 0) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSString *x in departments) {
            [arr addObject:@{@"id":STRING(x)}];
        }
        [params setObject:STRING(arr) forKey:@"departments"];
    }
    [ApiTool putWithUrl:MARKET_TREND_UPDATE andParams:params success:success failure:fail];
}

- (void)deleteMarkeTrendByMarkId:(long long)markId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool putWithUrl:[NSString stringWithFormat:@"%@%lld", MARKET_TREND_DELETE, markId] andParams:params success:success failure:fail];
}

- (void)detailMarkeTrendByMarkId:(NSInteger)markId
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", MARKET_TREND_DETAIL, markId] andParams:params success:success failure:fail];
}

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
                                     failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@{@"id":@(customerId)} forKey:@"member"];
    [params setObject:@{@"id":@(status)} forKey:@"status"];
//    [params setObject:@{@"id":@(important)} forKey:@"important"];
    [params setObject:@{@"id":STRING(type)} forKey:@"type"];
    [params setObject:STRING(title) forKey:@"title"];
    [params setObject:STRING(content) forKey:@"content"];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    [params setObject:STRING(attachmentList) forKey:@"attachments"];
    
//    if (departments.count > 0) {
//        NSMutableArray *arr = [NSMutableArray new];
//        for (NSString *x in departments) {
//            [arr addObject:@{@"id":STRING(x)}];
//        }
//        [params setObject:STRING(arr) forKey:@"departments"];
//    }
    [ApiTool postWithUrl:CUSTOMER_COMPLAINTS_CREATE andParams:params success:success failure:fail];
}

- (void)createCustomerByOperatorIdId:(NSInteger)operatorIdId
                                data:(NSArray *)data
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    if (data.count > 0) {
        for (CusInfoMo *infoMo in data) {
            for (CusInfoDetailMo *detailMo in infoMo.data) {
                if (![detailMo.rightValue isEqualToString:@"demo"]) {
                    
                    // 特殊情况
                    id m_obj = detailMo.m_obj;
                    if (detailMo.dictField.length > 0) {
                        // 字典项
                        if ([m_obj isKindOfClass:[DicMo class]]) {
                            NSString *dicValue = detailMo.field;
                            
                            DicMo *dicMo = (DicMo *)detailMo.m_obj;
                            if ([dicMo.name isEqualToString:@"member_listing"]) {
                                [params setObject:STRING(dicMo.key) forKey:STRING(dicValue)];
                                continue;
                            }
                            
                            if (dicValue.length > 5) {
                                NSString *str = [detailMo.field substringToIndex:detailMo.field.length-5];
                                NSString *keyStr = [str stringByAppendingString:@"Key"];
                                [params setObject:STRING(dicMo.value) forKey:dicValue];
                                [params setObject:STRING(dicMo.key) forKey:keyStr];
                            }
                        }
                        
                        if (detailMo.m_objs.count > 0) {
                            [params setObject:STRING(detailMo.rightValue) forKey:detailMo.field];
                        }
                    } else {
                        // m_obj 不为空的其他情况
                        if ([m_obj isKindOfClass:[CustomerMo class]]) {
                            CustomerMo *member = (CustomerMo *)detailMo.m_obj;
                            [params setObject:@{@"id":@(member.id),
                                                @"orgName":STRING(member.orgName)} forKey:detailMo.field];
                        }
                        else if ([m_obj isKindOfClass:[JYUserMo class]]) {
                            JYUserMo *user = (JYUserMo *)detailMo.m_obj;
                            [params setObject:@{@"id":@(user.id),
                                                @"name":STRING(user.name)} forKey:@"operator"];
                            continue;
                        }
                        
                        // 地区
                        if ([detailMo.field isEqualToString:@"region"]) {
                            NSArray *arrAddIds = detailMo.m_objs[0];
                            NSArray *arrAddNames = detailMo.m_objs[1];
                            [params setObject:STRING(arrAddNames[0]) forKey:@"provinceName"];
                            [params setObject:STRING(arrAddIds[0]) forKey:@"provinceNumber"];
                            [params setObject:STRING(arrAddNames[1]) forKey:@"cityName"];
                            [params setObject:STRING(arrAddIds[1]) forKey:@"cityNumber"];
                            [params setObject:STRING(arrAddNames[2]) forKey:@"areaName"];
                            if (![arrAddIds[2] isEqualToString:@"-"]) [params setObject:STRING(arrAddIds[2]) forKey:@"areaNumber"];
                            
//                            NSString *provinceName = @"";
//                            for (int i = 0; i < ids.count; i++) {
//                                NSString *num = ids[i];
//                                if (num.length > 0 && ![num containsString:@"-"]) {
//                                    if (provinceName.length > 0) provinceName = [provinceName stringByAppendingString:@"-"];
//                                    provinceName = [provinceName stringByAppendingString:[NSString stringWithFormat:@"%@-%@", num, names[i]]];
//                                }
//                            }
//                            [params setObject:STRING(provinceName) forKey:@"provinceName"];
                            continue;
                        }
                        // 品牌
                        else if ([detailMo.field isEqualToString:@"brandNames"]) {
                            NSMutableArray *brands = [NSMutableArray new];
                            for (int i= 0; i < detailMo.m_objs.count; i++) {
                                BrandMo *brandMo = (BrandMo *)detailMo.m_objs[i];
                                [brands addObject:[brandMo toDictionary]];
                            }
                            if (brands.count > 0) [params setObject:brands forKey:@"brands"];
                        }
                        else if ([detailMo.field isEqualToString:@"landx"]) {
                            CountryMo *mo = (CountryMo *)detailMo.m_obj;
                            [params setObject:STRING(mo.landx) forKey:@"landx"];
                            [params setObject:STRING(mo.land1) forKey:@"land1"];
                        }
                        else if ([detailMo.field isEqualToString:@"firstDistributor"]) {
                            
                        }
                        else {
                            [params setObject:STRING(detailMo.rightValue) forKey:STRING(detailMo.field)];
                        }
                    }
                }
            }
        }
    }
    [ApiTool postWithUrl:MEMBER_CREATE andParams:params success:success failure:fail];
}

- (void)getSelfMemberListParam:(NSDictionary *)param
                         rules:(NSArray *)rules
             specialConditions:(NSArray *)specialConditions
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@"id" forKey:@"property"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@(20) forKey:@"size"];
    [params addEntriesFromDictionary:param];
    if (specialConditions.count > 0) {
        [params setObject:specialConditions forKey:@"specialConditions"];
    }
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:GET_CUSTOMER_LIST andParams:params success:success failure:fail];
}

- (void)getSendAbleMemberListParam:(NSDictionary *)param
                          toUserId:(NSString *)toUserId
                             rules:(NSArray *)rules
                 specialConditions:(NSArray *)specialConditions
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@"id" forKey:@"property"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@(20) forKey:@"size"];
    [params addEntriesFromDictionary:param];
    if (specialConditions.count > 0) {
        [params setObject:specialConditions forKey:@"specialConditions"];
    }
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%@", GET_MEMBER_SEND_ABLE_LIST,toUserId] andParams:params success:success failure:fail];
}


- (void)createFavoriteTypeId:(NSString *)typeId
                  favoriteId:(long long)favoriteId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(typeId) forKey:@"fkType"];
    [params setObject:@(favoriteId) forKey:@"fkId"];
    [ApiTool postWithUrl:FAVORITE_CREATE andParams:params success:success failure:fail];
}

- (void)deleteFavoriteId:(long long)favoriteId
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%lld", FAVORITE_DELETE, favoriteId] andParams:params success:success failure:fail];
}

- (void)getMaterialFindDenierSuccess:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:MATERIAL_FIND_DENIER andParams:params success:success failure:fail];
}

- (void)getMaterialFindSpecSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:MATERIAL_FIND_SPEC andParams:params success:success failure:fail];
}

- (void)getMaterialFindGradeSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:MATERIAL_FIND_GRADE andParams:params success:success failure:fail];
}

- (void)getOperatorAssistListParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:OPERATOR_ASSIST_LIST andParams:params success:success failure:fail];
}

- (void)applyReleaseMemberId:(NSInteger)memberId
             originalSaleman:(NSInteger)originalSaleman
                      remark:(NSString *)remark
                    infoDate:(NSString *)infoDate
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    [params setObject:@{@"id":@(originalSaleman)} forKey:@"originalSaleman"];
    if (remark.length > 0) [params setObject:STRING(remark) forKey:@"remark"];
    [ApiTool postWithUrl:MEMBER_RELEASE andParams:params success:success failure:fail];
}

- (void)applyClaimMemberId:(NSInteger)memberId
             targetSaleman:(NSInteger)targetSaleman
                    remark:(NSString *)remark
                  infoDate:(NSString *)infoDate
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    [params setObject:@{@"id":@(targetSaleman)} forKey:@"targetSaleman"];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    if (remark.length > 0) [params setObject:STRING(remark) forKey:@"remark"];
    [ApiTool postWithUrl:MEMBER_CLAIM andParams:params success:success failure:fail];
}

- (void)applyTransferMemberId:(NSInteger)memberId
             originalSaleman:(NSInteger)originalSaleman
               targetSaleman:(NSInteger)targetSaleman
                       remark:(NSString *)remark
                     infoDate:(NSString *)infoDate
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(infoDate) forKey:@"infoDate"];
    [params setObject:@{@"id":@(memberId)} forKey:@"member"];
    [params setObject:@{@"id":@(originalSaleman)} forKey:@"originalSaleman"];
    [params setObject:@{@"id":@(targetSaleman)} forKey:@"targetSaleman"];
    if (remark.length > 0) [params setObject:STRING(remark) forKey:@"remark"];
    [ApiTool postWithUrl:MEMBER_TRANSFER andParams:params success:success failure:fail];
}

- (void)getProductSituationByCustomId:(NSInteger)customerId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld",PRODUCT_SITUATION, customerId] andParams:params success:success failure:fail];
}

//private Member member;//客户
//private Dict category;//产品类型 0
//private String name;//产品名称
//private Dict ingredient;//成份含量
//private Dict yarn;//纱支
//private Dict weight;//克重
//private Dict dyeingTechnology;//染整工艺
//private Dict qualityStandard;//品质标准
//private Dict popularElement;//流行元素
//private Dict applicableSession;//适用季节
//private Dict printStyle;//印花风格
//private Dict color;//颜色
//private Dict marketExpectation;//市场预期
//private String customerGroup;//客户群
//private BigDecimal marketReferencePrice;//市场参价
//attachments 附件

- (void)createProductMemberId:(NSInteger)memberId
                        param:(NSDictionary *)param
                  attachments:(NSArray *)attachments
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:PRODUCT_CREATE andParams:params success:success failure:fail];
}

- (void)updateProductId:(NSInteger)productId
               memberId:(NSInteger)memberId
                  param:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(productId) forKey:@"id"];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:PRODUCT_UPDATE andParams:params success:success failure:fail];
}

- (void)getProductPage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:PRODUCT_PAGE andParams:params success:success failure:fail];
}

- (void)deleteProductById:(NSInteger)productId
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", PRODUCT_DELETE, productId] andParams:params success:success failure:fail];
}

- (void)detailProductById:(NSInteger)productId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", PRODUCT_DETAIL, productId] andParams:params success:success failure:fail];
}

// 原料信息
- (void)createRowMaterialParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    [ApiTool postWithUrl:ROW_MATERIAL_CREATE andParams:params success:success failure:fail];
}

- (void)updateRowMaterialId:(NSInteger)rowMaterialId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(rowMaterialId) forKey:@"id"];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    
    [ApiTool putWithUrl:ROW_MATERIAL_UPDATE andParams:params success:success failure:fail];
}

- (void)getRowMaterialPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:ROW_MATERIAL_PAGE andParams:params success:success failure:fail];
}

- (void)deleteRowMaterialById:(NSInteger)productId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", ROW_MATERIAL_DELETE, productId] andParams:params success:success failure:fail];
}

- (void)detailRowMaterialById:(NSInteger)productId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", ROW_MATERIAL_DETAIL, productId] andParams:params success:success failure:fail];
}

// 竞品信息
- (void)createCompetitionParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:COMPETITION_CREATE andParams:params success:success failure:fail];
}

- (void)updateCompetitionId:(NSInteger)competitionId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(competitionId) forKey:@"id"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (attachments.count > 0) [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:COMPETITION_UPDATE andParams:params success:success failure:fail];
}

- (void)getCompetitionPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:COMPETITION_PAGE andParams:params success:success failure:fail];
}

- (void)deleteCompetitionById:(NSInteger)competitionId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", COMPETITION_DELETE, competitionId] andParams:params success:success failure:fail];
}

- (void)detailCompetitionById:(NSInteger)competitionId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", COMPETITION_DETAIL, competitionId] andParams:params success:success failure:fail];
}

// 工厂设备
- (void)createEquipmentParam:(NSDictionary *)param
                 attachments:(NSArray *)attachments
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:EQUIPMENT_CREATE andParams:params success:success failure:fail];
}

- (void)updateEquipmentId:(NSInteger)equipmentId
                    param:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(equipmentId) forKey:@"id"];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:EQUIPMENT_UPDATE andParams:params success:success failure:fail];
}

- (void)getEquipmentPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:EQUIPMENT_PAGE andParams:params success:success failure:fail];
}

- (void)deleteEquipmentById:(NSInteger)equipmentId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", EQUIPMENT_DELETE, equipmentId] andParams:params success:success failure:fail];
}

- (void)detailEquipmentById:(NSInteger)equipmentId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", EQUIPMENT_DETAIL, equipmentId] andParams:params success:success failure:fail];
}

- (void)getEquipmentTypeWithField:(NSString *)fieldValue
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params setObject:STRING(fieldValue) forKey:@"remark"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%@", LIST_REMARK,@"equipment_type"] andParams:params success:success failure:fail];
}

- (void)getEquipmentTotalCountByMemberId:(NSInteger)memberIdId
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", EQUIPMENT_TOTAL_COUNT,(long)memberIdId] andParams:params success:success failure:fail];
}

// 生产动态
- (void)createPerformanceParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:PERFORMANCE_CREATE andParams:params success:success failure:fail];
}

- (void)updatePerformanceId:(NSInteger)performanceId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(performanceId) forKey:@"id"];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:PERFORMANCE_UPDATE andParams:params success:success failure:fail];
}

- (void)getPerformancePage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:PERFORMANCE_PAGE andParams:params success:success failure:fail];
}

- (void)deletePerformanceById:(NSInteger)performanceId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", PERFORMANCE_DELETE, performanceId] andParams:params success:success failure:fail];
}

- (void)detailPerformanceById:(NSInteger)performanceId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", PERFORMANCE_DETAIL, performanceId] andParams:params success:success failure:fail];
}

// 工厂招工
- (void)createRecruitmentParam:(NSDictionary *)param
                   attachments:(NSArray *)attachments
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:RECRUITMENT_CREATE andParams:params success:success failure:fail];
}

- (void)updateRecruitmentId:(NSInteger)recruitmentId
                      param:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(recruitmentId) forKey:@"id"];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:RECRUITMENT_UPDATE andParams:params success:success failure:fail];
}

- (void)getRecruitmentPage:(NSInteger)page
                      size:(NSInteger)size
                     rules:(NSArray *)rules
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:RECRUITMENT_PAGE andParams:params success:success failure:fail];
}

- (void)deleteRecruitmentById:(NSInteger)recruitmentId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", RECRUITMENT_DELETE, recruitmentId] andParams:params success:success failure:fail];
}

- (void)detailRecruitmentById:(NSInteger)recruitmentId
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", RECRUITMENT_DETAIL, recruitmentId] andParams:params success:success failure:fail];
}

// 生产许可
- (void)createLicenseParam:(NSDictionary *)param
               attachments:(NSArray *)attachments
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:LICENSE_CREATE andParams:params success:success failure:fail];
}

- (void)updateLicenseId:(NSInteger)licenseId
                  param:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(licenseId) forKey:@"id"];
    [params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:LICENSE_UPDATE andParams:params success:success failure:fail];
}

- (void)getLicensePage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:LICENSE_PAGE andParams:params success:success failure:fail];
}

- (void)deleteLicenseById:(NSInteger)licenseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", LICENSE_DELETE, licenseId] andParams:params success:success failure:fail];
}

- (void)detailLicenseById:(NSInteger)licenseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", LICENSE_DETAIL, licenseId] andParams:params success:success failure:fail];
}

// 采购招标
- (void)createPruchaseParam:(NSDictionary *)param
               attachments:(NSArray *)attachments
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:PRUCHASE_CREATE andParams:params success:success failure:fail];
}

- (void)updatePruchaseId:(NSInteger)pruchaseId
                  param:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(pruchaseId) forKey:@"id"];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:PRUCHASE_UPDATE andParams:params success:success failure:fail];
}

- (void)getPruchasePage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:PRUCHASE_PAGE andParams:params success:success failure:fail];
}

- (void)deletePruchaseById:(NSInteger)pruchaseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", PRUCHASE_DELETE, pruchaseId] andParams:params success:success failure:fail];
}

- (void)detailPruchaseById:(NSInteger)pruchaseId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", PRUCHASE_DETAIL, pruchaseId] andParams:params success:success failure:fail];
}

#pragma mark - 进出口信息

- (void)createPortInfoParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:PORT_INFO_CREATE andParams:params success:success failure:fail];
}

- (void)updatePortInfoId:(NSInteger)portInfoId
                   param:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(portInfoId) forKey:@"id"];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:PORT_INFO_UPDATE andParams:params success:success failure:fail];
}

- (void)getPortInfoPage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:PORT_INFO_PAGE andParams:params success:success failure:fail];
}

- (void)deletePortInfoById:(NSInteger)portInfoId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", PORT_INFO_DELETE, portInfoId] andParams:params success:success failure:fail];
}

- (void)detailPortInfoById:(NSInteger)portInfoId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", PORT_INFO_DETAIL, portInfoId] andParams:params success:success failure:fail];
}

#pragma mark - 税务评级

- (void)createTaxRatingParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:TAX_RATING_CREATE andParams:params success:success failure:fail];
}

- (void)updateTaxRatingId:(NSInteger)taxRatingId
                   param:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(taxRatingId) forKey:@"id"];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:TAX_RATING_UPDATE andParams:params success:success failure:fail];
}

- (void)getTaxRatingPage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:TAX_RATING_PAGE andParams:params success:success failure:fail];
}

- (void)deleteTaxRatingById:(NSInteger)taxRatingId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", TAX_RATING_DELETE, taxRatingId] andParams:params success:success failure:fail];
}

- (void)detailTaxRatingById:(NSInteger)taxRatingId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", TAX_RATING_DETAIL, taxRatingId] andParams:params success:success failure:fail];
}

#pragma mark - 抽查检查

- (void)createSpotCheckParam:(NSDictionary *)param
                attachments:(NSArray *)attachments
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool postWithUrl:SPOT_CHECK_CREATE andParams:params success:success failure:fail];
}

- (void)updateSpotCheckId:(NSInteger)spotCheckId
                   param:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:@(spotCheckId) forKey:@"id"];
    if (attachments.count > 0)[params setObject:attachments forKey:@"attachments"];
    
    [ApiTool putWithUrl:SPOT_CHECK_UPDATE andParams:params success:success failure:fail];
}

- (void)getSpotCheckPage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:SPOT_CHECK_PAGE andParams:params success:success failure:fail];
}

- (void)deleteSpotCheckById:(NSInteger)spotCheckId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", SPOT_CHECK_DELETE, spotCheckId] andParams:params success:success failure:fail];
}

- (void)detailSpotCheckById:(NSInteger)spotCheckId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", SPOT_CHECK_DETAIL, spotCheckId] andParams:params success:success failure:fail];
}

#pragma mark - 债券信息

- (void)getBondPage:(NSInteger)page
               size:(NSInteger)size
              rules:(NSArray *)rules
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:BOND_INFO_PAGE andParams:params success:success failure:fail];
}

- (void)detailBondById:(NSInteger)bondId
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", BOND_INFO_DETAIL, bondId] andParams:params success:success failure:fail];
}

#pragma mark - 购地信息

- (void)getPurchasePage:(NSInteger)page
                   size:(NSInteger)size
                  rules:(NSArray *)rules
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:PURCHASE_LAND_PAGE andParams:params success:success failure:fail];
}

- (void)detailPurchaseById:(NSInteger)purchaseId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", PURCHASE_LAND_DETAIL, purchaseId] andParams:params success:success failure:fail];
}

#pragma mark - 交易跟踪

- (void)getTrackingSituationListById:(NSInteger)memberId
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", TRACKING_SITUATION, memberId] andParams:params success:success failure:fail];
}

#pragma mark - 商务合同

- (void)createContractParam:(NSDictionary *)param
                 attachments:(NSArray *)attachments
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachments"];
    [ApiTool postWithUrl:CONTRACT_CREATE andParams:params success:success failure:fail];
}

- (void)getContractPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:CONTRACT_PAGE andParams:params success:success failure:fail];
}

- (void)deleteContractById:(NSInteger)contractId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:@"%@%ld", CONTRACT_DELETE, contractId] andParams:params success:success failure:fail];
}

- (void)detailContractById:(NSInteger)contractId
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", CONTRACT_DETAIL, contractId] andParams:params success:success failure:fail];
}

#pragma mark - 销售订单

- (void)getOrderPage:(NSInteger)page
                size:(NSInteger)size
               rules:(NSArray *)rules
   specialConditions:(NSArray *)specialConditions
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (specialConditions.count > 0) {
        [params setObject:specialConditions forKey:@"specialConditions"];
    }
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:ORDER_PAGE andParams:params success:success failure:fail];
}

- (void)getOrderSendPage:(NSInteger)page
                toUserId:(NSString *)toUserId
                    size:(NSInteger)size
                   rules:(NSArray *)rules
       specialConditions:(NSArray *)specialConditions
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (specialConditions.count > 0) [params setObject:specialConditions forKey:@"specialConditions"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%@", ORDER_SEND_PAGE, toUserId] andParams:params success:success failure:fail];
}

- (void)detailOrderById:(NSInteger)orderId
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", ORDER_DETAIL, orderId] andParams:params success:success failure:fail];
}

#pragma mark - 发货

- (void)getSapInvoicePage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:SAP_INVOICE_PAGE andParams:params success:success failure:fail];
}

- (void)detailSapInvoiceById:(NSInteger)sapInvoiceId
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", SAP_INVOICE_DETAIL, sapInvoiceId] andParams:params success:success failure:fail];
}

- (void)addSapInvoiceAttachmentListById:(NSInteger)sapInvoiceId
                         attachmentList:(NSArray *)attachmentList
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(sapInvoiceId) forKey:@"id"];
    [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool postWithUrl:SAP_INVOICE_ADD andParams:params success:success failure:fail];
}

#pragma mark - 发票

- (void)getSalesBillingPage:(NSInteger)page
                     size:(NSInteger)size
                    rules:(NSArray *)rules
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:SALES_BILLING_PAGE andParams:params success:success failure:fail];
}

- (void)detailSalesBillingById:(NSInteger)salesBillingId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", SALES_BILLING_DETAIL, salesBillingId] andParams:params success:success failure:fail];
}

- (void)addSalesBillingAttachmentListById:(NSInteger)salesBillingId
                         attachmentList:(NSArray *)attachmentList
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(salesBillingId) forKey:@"id"];
    [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool postWithUrl:SALES_BILLING_ADD andParams:params success:success failure:fail];
}

#pragma mark - 电汇

- (void)getReceiptTrackingPage:(NSInteger)page
                       size:(NSInteger)size
                      rules:(NSArray *)rules
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"zbelnr" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:RECEIPT_TRACKING_PAGE andParams:params success:success failure:fail];
}

- (void)detailReceiptTrackingById:(NSInteger)receiptTrackingId
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", RECEIPT_TRACKING_DETAIL, receiptTrackingId] andParams:params success:success failure:fail];
}

- (void)addReceiptAttachmentListById:(NSInteger)receiptId
                      attachmentList:(NSArray *)attachmentList
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(receiptId) forKey:@"id"];
    [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool postWithUrl:RECEIPT_TRACKING_ADD andParams:params success:success failure:fail];
}

#pragma mark - 外贸

- (void)getForeignPage:(NSInteger)page
                          size:(NSInteger)size
                         rules:(NSArray *)rules
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:FOREIGN_PAGE andParams:params success:success failure:fail];
}

- (void)detailForeignById:(NSInteger)foreignId
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", FOREIGN_DETAIL, foreignId] andParams:params success:success failure:fail];
}

#pragma mark - 对账单

- (void)getMonthyStatementPage:(NSInteger)page
                  size:(NSInteger)size
                 rules:(NSArray *)rules
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"createdDate" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:MONTHY_STATEMENT_PAGE andParams:params success:success failure:fail];
}

- (void)detailMonthyStatementById:(NSInteger)monthyStatementId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", MONTHY_STATEMENT_DETAIL, monthyStatementId] andParams:params success:success failure:fail];
}

- (void)addMonthyStatementAttachmentListById:(NSInteger)monthyStatementId
                              attachmentList:(NSArray *)attachmentList
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(monthyStatementId) forKey:@"id"];
    [params setObject:attachmentList forKey:@"attachmentList"];
    [ApiTool postWithUrl:MONTHY_STATEMENT_ADD andParams:params success:success failure:fail];
}

#pragma mark - 应用大全

- (void)getApplicationPageParam:(NSDictionary *)param
                          rules:(NSArray *)rules
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0)  [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:APPLICATION_PAGE andParams:params success:success failure:fail];
}

- (void)getApplicationItemPageParam:(NSDictionary *)param
                              rules:(NSArray *)rules
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0)  [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:APPLICATION_ITEM_PAGE andParams:params success:success failure:fail];
}

#pragma mark - 任务协作

- (void)createTaskParam:(NSDictionary *)param
            attachments:(NSArray *)attachments
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
//    [params setObject:attachments forKey:@"attachments"];
    [ApiTool postWithUrl:TASK_CREATE andParams:params success:success failure:fail];
}

- (void)getTaskPageParam:(NSDictionary *)param
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0)  [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:TASK_PAGE andParams:params success:success failure:fail];
}

- (void)getTaskConditionList:(NSDictionary *)param
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (rules.count > 0)  [params setObject:rules forKey:@"rules"];
    [ApiTool getWithUrl:TASK_CONDITION_LIST andParams:params success:success failure:fail];
}

- (void)createTaskComment:(NSDictionary *)param
              attachments:(NSArray *)attachments
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachmentList"];
    [ApiTool postWithUrl:TASK_CREATE_COMMENT andParams:params success:success failure:fail];
}

#pragma mark - 我的页面

- (void)getOperationInfoSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:OPERATION_FIND_INDEX andParams:params success:success failure:fail];
}

#pragma mark - 新建工厂

- (void)getFactoryPage:(NSInteger)page
                    size:(NSInteger)size
                   rules:(NSArray *)rules
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {

    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [params setObject:@(size) forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    if (rules.count > 0) [params setObject:rules forKey:@"rules"];
    [ApiTool postWithUrl:FACTORY_PAGE andParams:params success:success failure:fail];
}

- (void)getFindFactoryPage:(NSInteger)page
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:FACTORY_FIND andParams:params success:success failure:fail];
}

#pragma mark - 收藏

- (void)getFavoriteMemberPage:(NSInteger)page
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [ApiTool postWithUrl:FAVORITE_MEMBER andParams:params success:success failure:fail];
}

- (void)getFavoriteOrderPage:(NSInteger)page
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [ApiTool postWithUrl:FAVORITE_ORDER andParams:params success:success failure:fail];
}

- (void)getFavoriteTaskPage:(NSInteger)page
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    [params setObject:@(page) forKey:@"number"];
    [ApiTool postWithUrl:FAVORITE_TASK andParams:params success:success failure:fail];
}

#pragma mark - 签到
- (void)createSignInParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:SIGN_IN_CREATE andParams:params success:success failure:fail];
}

- (void)updateSignInParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:SIGN_IN_UPDATE andParams:params success:success failure:fail];
}

- (void)createCommentApp:(NSDictionary *)param
             attachments:(NSArray *)attachments
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [params setObject:attachments forKey:@"attachmentList"];
    [ApiTool postWithUrl:COMMENT_APP andParams:params success:success failure:fail];
}

- (void)getGatheringPlanFindSort:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:GATHERING_FIND_SORT andParams:params success:success failure:fail];
}

#pragma mark - 修改头像

- (void)memberUpdateAvatorParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:MEMBER_UPDATE_URL andParams:params success:success failure:fail];
}

- (void)operatorAvatorUpdateParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:OPERATOR_UPDATE_AVATOR andParams:params success:success failure:fail];
}

#pragma mark - 修改实控人

- (void)actualUpdateParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
//    [params removeObjectForKey:@"fromClientType"];
    [ApiTool putWithUrl:ACTUAL_UPDATE andParams:params success:success failure:fail];
}

- (void)dunningFailure:(id)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
//    NSMutableDictionary *params = [self baseParams];
//    if (param.count > 0) [params addEntriesFromDictionary:param];
    //    [params removeObjectForKey:@"fromClientType"];
    [ApiTool postWithUrl:DUNNING_FAILURE andParams:param success:success failure:fail];
}


// 修改协助人
- (void)changeAssistByMemberId:(NSInteger)memberId
                       operIds:(id)operIds
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@%ld", CHANGE_ASSIST, memberId] andParams:operIds success:success failure:fail];
}

// 特价
- (void)createSpecialRecordParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:SPECIAL_RECORD andParams:params success:success failure:fail];
}

// 获取批号
- (void)findBatchParam:(NSDictionary *)param
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FIND_BATCH andParams:params success:success failure:fail];
}

// 计划外要货
- (void)createDemandRecordParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:DEMAND_RECORD andParams:params success:success failure:fail];
}

// 升级
- (void)createVersionParam:(NSDictionary *)param
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:VERSION_CREATE andParams:params success:success failure:fail];
}

- (void)checkVersionParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:VERSION_CHECK andParams:params success:success failure:fail];
}

- (void)getDefaultFactorySuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSArray *rules = @[@{@"field": @"member.id",
                         @"values": @[@(TheCustomer.customerMo.id)],
                         @"option": @"EQ"}];
    [[JYUserApi sharedInstance] getFactoryPage:0 size:500 rules:rules success:^(id responseObject) {
        [Utils dismissHUD];
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        if (fail) success(error);
    }];
}

#pragma mark - 客户价值评估
/** 获取客户价值评估 */
- (void)getWorthbeanMemberId:(long long)memberId
                         key:(NSString *)key
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:MEMBER_CENTER_GETWORTHBEAN, memberId, key] andParams:params success:success failure:fail];
}


#pragma mark - 动态表单
/** 获取动态新建表单 */
- (void)getDynmicFormDynamicId:(NSString *)dynamicId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:DYNMIC_CREATE_FORM, dynamicId] andParams:params success:success failure:fail];
}
/** 动态新建 */
- (void)createDynmicFormDynamicId:(NSString *)dynamicId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:DYNMIC_CREATE, dynamicId] andParams:params success:success failure:fail];
}
/** 动态列表 */
- (void)getPageDynmicFormDynamicId:(NSString *)dynamicId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:DYNMIC_PAGE, dynamicId] andParams:params success:success failure:fail];
}

/** 动态获取详情表单 */
- (void)getDynmicFormDynamicId:(NSString *)dynamicId
                      detailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:DYNMIC_UPDATE_FORM, dynamicId, detailId] andParams:params success:success failure:fail];
}

/** 动态获取详情 */
- (void)getObjDetailByDynamicId:(NSString *)dynamicId
                       detailId:(long long)detailId
                          param:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:DYNMIC_DETAIL, dynamicId, detailId] andParams:params success:success failure:fail];
}

/** 动态删除某一条记录 */
- (void)deleteObjDetailByDynamicId:(NSString *)dynamicId
                          detailId:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:DYNMIC_DELETE_DETAIL_ID, dynamicId, detailId] andParams:params success:success failure:fail];
}

/** 动态逻辑删除 */
- (void)batchDeleteObjDetailByDynamicId:(NSString *)dynamicId
                                  param:(NSMutableArray *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
//    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:DYNMIC_BATCH_DELETE, dynamicId] andParams:param success:success failure:fail];
}


/** 动态更新 */
- (void)updateDynmicFormDynamicId:(NSString *)dynamicId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:[NSString stringWithFormat:DYNMIC_UPDATE, dynamicId] andParams:params success:success failure:fail];
}

#pragma mark - 人事组织

- (void)getLinkManOfficeByMemberId:(NSInteger)memberId
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", LINK_MAN_OFFICE, (long)memberId] andParams:params success:success failure:fail];
}

- (void)getLinkManListByMemberParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:LINK_MAN_LIST_MEMBERID andParams:params success:success failure:fail];
}

- (void)getLinkManListByOfficeParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:LINK_MAN_LIST_OFFICEID andParams:params success:success failure:fail];
}

- (void)getLinkManBusinessPageParam:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:LINK_MAN_BUSINESS_CHANCE_PAGE andParams:params success:success failure:fail];
}

- (void)getLinkManPainPointPageParam:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:LINK_MAN_PAIN_POINT_PAGE andParams:params success:success failure:fail];
}

- (void)getLinkManTotalCount:(long long)memberId
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:LINK_MAN_TOTOL_COUNT, memberId] andParams:params success:success failure:fail];
}

#pragma mark - 财务风险

- (void)getFinanceThirdMobileMemberId:(long long)memberId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FINANCE_THIRD_MODULE, memberId] andParams:params success:success failure:fail];
}

- (void)getFinanceBalanceAmountMemberId:(long long)memberId
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FINANCE_BALANCE_AMOUNT, memberId] andParams:params success:success failure:fail];
}

- (void)getFinanceBisdGroupByBurksMemberId:(long long)memberId
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FINANCE_BISD_GROUP_BY_BUKRS, memberId] andParams:params success:success failure:fail];
}

#pragma mark - 采购状况
- (void)getPurchaseSummaryNumberByMemberId:(long long)memberId
                                       key:(NSString *)key
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *url = [NSString stringWithFormat:PURCHASE_SUMMARY_NUMBER, memberId];
    if (![key isEqualToString:@"all"] && key.length != 0) url = [url stringByAppendingString:[NSString stringWithFormat:@"/%@", key]];
    [ApiTool getWithUrl:url andParams:params success:success failure:fail];
}

- (void)getSupplierDirectoryPageByMemberId:(long long)memberId
                                     subId:(NSString *)subId
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = @"";
    if ([subId isEqualToString:@"all"]) {
        urlStr = [NSString stringWithFormat:@"%@/%lld", SUPPLIER_DIRECTORY_PAGE, memberId];
    } else {
        urlStr = [NSString stringWithFormat:@"%@/%lld/%@", SUPPLIER_DIRECTORY_PAGE, memberId, subId];
    }
    [ApiTool getWithUrl:urlStr andParams:params success:success failure:fail];
}

#pragma mark - 生产状况
- (void)getProductSummaryNumberByMemberId:(long long)memberId
                                      key:(NSString *)key
                                    param:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:PRODUCT_SUMMARY_NUMBER, memberId];
    if (![key isEqualToString:@"all"] && key.length != 0) urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/%@", key]];
    [ApiTool getWithUrl:urlStr andParams:params success:success failure:fail];
}

#pragma mark - 销售状况
- (void)getSalesSummaryNumberByMemberId:(long long)memberId
                                    key:(NSString *)key
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:SALES_SUMMARY_NUMBER, memberId];
    if (![key isEqualToString:@"all"] && key.length != 0) urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/%@", key]];
    [ApiTool getWithUrl:urlStr andParams:params success:success failure:fail];
}

#pragma mark - 研发状况
- (void)getDevelopSummaryNumberByMemberId:(long long)memberId
                                      key:(NSString *)key
                                    param:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:DEVLOP_SUMMARY_NUMBER, memberId];
    if (![key isEqualToString:@"all"] && key.length != 0) urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"/%@", key]];
    [ApiTool getWithUrl:urlStr andParams:params success:success failure:fail];
}

#pragma mark - 合同跟踪
- (void)getContractSummaryNumberByMemberId:(long long)memberId
                                    param:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:CONTRACT_SUMMARY_NUMBER, memberId] andParams:params success:success failure:fail];
}

#pragma mark - 商务拜访
- (void)getBusinessVisitActivityCalendarMemberId:(long long)memberId
                                         dateStr:(NSString *)dateStr
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:VISIT_ACTIVITY_CALENDAR, memberId, dateStr] andParams:params success:success failure:fail];
}

- (void)getBusinessVisitActivityListByCalendarMemberId:(long long)memberId
                                               dateStr:(NSString *)dateStr
                                                 param:(NSDictionary *)param
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:VISIT_ACTIVITY_LIST_BY_CALENDAR, memberId, dateStr] andParams:params success:success failure:fail];
}

- (void)getBusinessVisitActivityDetailByDetailId:(long long)detailId
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:VISIT_ACTIVITY_LIST_DETAIL, detailId] andParams:params success:success failure:fail];
}

- (void)deleteBusinessVisitActivityByDetailId:(long long)detailId
                                        param:(NSDictionary *)param
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:VISIT_ACTIVITY_LIST_DELETE, detailId] andParams:params success:success failure:fail];
}

- (void)updateVisitActivityStatus:(NSString *)status
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:status.length==0?VISIT_ACTIVITY_UPDATE_STATUS:[NSString stringWithFormat:@"%@/%@",VISIT_ACTIVITY_UPDATE_STATUS, status] andParams:params success:success failure:fail];
}


- (void)updateVisitActivityCommunicateRecordParam:(NSDictionary *)param
                                          success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:VISIT_ACTIVITY_UPDATE_COMMUNICATERECORD andParams:params success:success failure:fail];
}

#pragma mark - 商务接待
//#define VISIT_RECEPTION_CALENDAR                @"/api/customer-base-reception/calendar-list-mobile/%lld/%@"
//#define VISIT_RECEPTION_LISTBY_CALENDAR         @"/api/customer-base-reception/page"
//#define VISIT_RECEPTION_LIST_BY_CALENDAR        @"/api/customer-base-reception/reception-list-by-calendar/%lld/%@"

- (void)getBusinessVisitReceptionCalendarMemberId:(long long)memberId
                                          dateStr:(NSString *)dateStr
                                            param:(NSDictionary *)param
                                          success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:VISIT_RECEPTION_CALENDAR, memberId, dateStr] andParams:params success:success failure:fail];
}

- (void)getBusinessVisitReceptionListByCalendarMemberId:(long long)memberId
                                                dateStr:(NSString *)dateStr
                                                  param:(NSDictionary *)param
                                                success:(void (^)(id responseObject))success
                                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:VISIT_RECEPTION_LIST_BY_CALENDAR, memberId, dateStr] andParams:params success:success failure:fail];
}


#pragma mark - 商机跟进
- (void)getBusinessFollowSummaryNumberByMemberId:(long long)memberId
                                           param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:BUSINIESS_FOLLOW_SUMMARY_NUMBER, memberId] andParams:params success:success failure:fail];
}

#pragma mark - 附件上传

- (void)fileUploadMultiParam:(NSDictionary *)param
                        list:(NSArray *)list
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool fileUploadWithUrl:FILE_UPLOAD_MULTI andParams:params files:list success:success failure:fail];
}

// 图片语音视频混合上传
- (void)fileUploadMultiParam:(NSDictionary *)param
                    attFiles:(NSArray *)attFiles
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
//    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool fileUploadWithUrl:FILE_UPLOAD_MULTI andParams:param attFiles:attFiles success:success failure:fail];
}

// 图片语音视频混合上传
- (void)downTaskWithUrlStr:(NSString *)urlStr
                    toPath:(NSString *)toPath
                     param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    //    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (urlStr.length == 0) {
        [Utils showToastMessage:@"网络地址为空"];
        return;
    }
    if (toPath.length == 0) {
        [Utils showToastMessage:@"存储路径为空"];
        return;
    }
    [ApiTool downTaskWithUrlStr:urlStr toPath:toPath andParams:params success:success failure:fail];
}

#pragma mark - 动态feed流

- (void)getFeedLowPageTrendParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FEED_FLOW_PAGE_TREND andParams:params success:success failure:fail];
}

- (void)addFeedLikeRecord:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FEED_LIKE_RECORD_ADD andParams:params success:success failure:fail];
}

- (void)removeFeedLikeRecordId:(long long)likeId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:FEED_LIKE_RECORD_REMOVE, likeId] andParams:params success:success failure:fail];
}


#pragma mark - 字典项feed列表

- (void)getDicListByName:(NSString *)name
                  remark:(NSString *)remark
                   param:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (name.length != 0 && remark.length != 0)
        [ApiTool getWithUrl:[NSString stringWithFormat:DICT_LIST_NAME_REMARK, name, remark] andParams:params success:success failure:fail];
}

#pragma mark - 情报大全
/** 情报大全 */
- (void)getFeedBigItemPageType:(NSString *)type
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:FEED_BIG_ITEM_PAGE, type] andParams:params success:success failure:fail];
}

/** 手机端清单 */
- (void)getFeedBigItemPageMobileType:(NSString *)type
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:FEED_BIG_ITEM_PAGE_MOBILE, type] andParams:params success:success failure:fail];
}

/** 新建线索 */
- (void)createClueParam:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FEED_CLUE_CREATE andParams:params success:success failure:fail];
}

/** 修改线索 */
- (void)updateClueParam:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:FEED_CLUE_UPDATE andParams:params success:success failure:fail];
}

/** 关联活动 */
- (void)getMarketActivityPage:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:MARKET_ACTIVITY_PAGE andParams:params success:success failure:fail];
}

/** 关联情报 */
- (void)getMarketIntelligenceItemPage:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:MARKET_INTELLIGENCE_ITEM_PAGE andParams:params success:success failure:fail];
}

/** 关联线索 */
- (void)getClueItemPage:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:GET_CLUE_PAGE andParams:params success:success failure:fail];
}

/** 产品大类 */
- (void)getBigMaterialTypePage:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:GET_MATERIAL_TYPE_PAGE andParams:params success:success failure:fail];
}

/** 获取部门 */
- (void)getDepartmentPage:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:GET_DEPARTMENT_PAGE andParams:params success:success failure:fail];
}

/** 关联情报 */
- (void)createLinkActivityByDetailId:(long long)detailId
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:detailId > 0 ? [NSString stringWithFormat:@"%@/%lld",CREATE_LINK_ACTIVITY_BY_ID, detailId] : CREATE_LINK_ACTIVITY_BY_ID andParams:params success:success failure:fail];
}


/** 关联情报列表 */
- (void)getLinkActivityPageByDetailId:(long long)detailId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:GET_LINK_INTELLIGENCE_ITEM, detailId] andParams:params success:success failure:fail];
}

/** 修改单个关联情报 */
- (void)updateIntelligenceItemDetailParam:(NSDictionary *)param
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:UPDATE_INTELLIGENCE_ITEM andParams:params success:success failure:fail];
}

/** 删除单个关联情报 */
- (void)deleteIntelligenceItemDetailId:(long long)detailId
                                 param:(NSDictionary *)param
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:DELETE_INTELLIGENCE_ITEM, detailId] andParams:params success:success failure:fail];
}


/** 获取单个关联情报详情 */
- (void)getIntelligenceItemDetailId:(long long)detailId
                              param:(NSDictionary *)param
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:DETAIL_INTELLIGENCE_ITEM, detailId] andParams:params success:success failure:fail];
}

/** 获取线索详情 */
- (void)getClueDetailId:(long long)detailId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:GET_CLUE_DETAIL, detailId] andParams:params success:success failure:fail];
}


/** 获取样品详情 */
- (void)getSampleDetailId:(long long)detailId
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:GET_SAMPLE_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取商机详情 */
- (void)getBusinessChangeDetailId:(long long)detailId
                            param:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:GET_BUSINESS_CHANGE_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 修改商机详情 */
- (void)updateBusinessChangeParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:UPDATE_BUSINESS_CHANGE_DETAIL andParams:params success:success failure:fail];
}

/** 新建报价 */
- (void)createQuotedPriceParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CREATE_QUOTED_PRICE andParams:params success:success failure:fail];
}

/** 获取报价详情 */
- (void)getQuotedPriceDetailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:DETAIL_QUOTED_PRICE, detailId] andParams:params success:success failure:fail];
}

/** 修改报价 */
- (void)updateQuotedPriceParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:UPDATE_QUOTED_PRICE andParams:params success:success failure:fail];
}


/** 新建联系人 */
- (void)createPersonalParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:LINK_MAN_CREATE andParams:params success:success failure:fail];
}

/** 联系人详情 */
- (void)getPersonalDetailId:(long long)detailId
                      param:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:LINK_MAN_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 修改联系人 */
- (void)updatePersonalParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:LINK_MAN_UPDATE andParams:params success:success failure:fail];
}


/** 删除联系人 */
- (void)deletePersonalDetailId:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:LINK_MAN_DELETE, detailId] andParams:params success:success failure:fail];
    
}

/** 新建回复 */
- (void)updateReplayPointMessageParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:PAIN_POINT_UPDATEMESSAGE andParams:params success:success failure:fail];
}

/** 新建痛点 */
- (void)createPainPointParam:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CREATE_PAIN_POINT andParams:params success:success failure:fail];
}

/** 获取国家列表 */
- (void)getCountryListParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:GET_COUNTRY_PAGE andParams:params success:success failure:fail];
}

/** 新建工作圈动态 */
- (void)createWorkingCircleParam:(NSDictionary *)param
                           isAll:(BOOL)isAll
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:isAll?[NSString stringWithFormat:@"%@/all", CREATE_WORKING_CIRCLE]:CREATE_WORKING_CIRCLE andParams:params success:success failure:fail];
}

/** 获取用户详情 */
- (void)getOperatorDetail:(NSInteger)contactId
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:@"%@%ld", OPERATOR_DETAIL, contactId] andParams:params success:success failure:fail];
}

/** 获取竞争对手详情 */
- (void)getCompetitorBehaviorDetailId:(long long)detailId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [ApiTool getWithUrl:[NSString stringWithFormat:COMPETITOR_BEHAVIOR_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 修改密码 */
- (void)updatePasswordParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:UPDATE_PASSWORD andParams:params success:success failure:fail];
}


/** 意见反馈 */
- (void)createFeedBackParam:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FEED_BACK_CREATE andParams:params success:success failure:fail];
}

/** 获取用户日历 */
- (void)getCurrentUserVisitCalendarDateStr:(NSString *)dateStr
                                     param:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:CURRENT_USER_VISIT_ACTIVITY_CALENDAR, dateStr] andParams:params success:success failure:fail];
}

/** 获取用户某天日程 */
- (void)getCurrentVisitPageParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CURRENT_USER_VISIT_ACTIVITY_LIST_PAGE andParams:params success:success failure:fail];
}

/** 获取用户接待日历 */
- (void)getCurrentUserReceptionCalendarDateStr:(NSString *)dateStr
                                         param:(NSDictionary *)param
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:CURRENT_USER_RECEPTION_LISTBY_CALENDAR, dateStr] andParams:params success:success failure:fail];
}

/** 获取用户某天接待日程 */
- (void)getCurrentReceptionPageParam:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CURRENT_USER_RECEPTION_LIST_PAGE andParams:params success:success failure:fail];
}


/** 新增浏览记录 */
- (void)viewRecordCreate:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:VIEW_RECORD_CREATE_MULTIPLE andParams:params success:success failure:fail];
}

/** 获取客户协助人列表 */
- (void)getMemberAssistFindOperatorMemberId:(long long)memberId
                                      param:(NSDictionary *)param
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:MEMBER_ASSIST_FIND_OPERATOR, memberId] andParams:params success:success failure:fail];
}

/** 新建客户协助人 */
- (void)createMemberAssistParam:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    [params removeObjectForKey:@"fromClientType"];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:MEMBER_ASSIST_CREATE_APP andParams:params success:success failure:fail];
}

/** 删除客户协助人 */
- (void)deleteMemberAssistId:(long long)deleteId
                       param:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool deleteWithUrl:[NSString stringWithFormat:MEMBER_ASSIST_DELETE, deleteId] andParams:params success:success failure:fail];
}

/** 获取签到记录 */
- (void)getSignInPageParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:SIGN_IN_PAGE andParams:params success:success failure:fail];
}

#pragma mark - 零售工作计划
/** 新建零售工作计划 */
- (void)createRetailChannelParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:RETAIL_CHANNEL_CREATE andParams:params success:success failure:fail];
}

/** 更新零售工作计划 */
- (void)updateRetailChannelParam:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:RETAIL_CHANNEL_UPDATE andParams:params success:success failure:fail];
}

/**  获取零售工作计划详情 */
- (void)getRetailChannelDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:RETAIL_CHANNEL_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取零售工作计划列表 */
- (void)getRetailChannelPageParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:RETAIL_CHANNEL_PAGE andParams:params success:success failure:fail];
}

/** 获取月销售目标 */
- (void)getWorkPlanTargetByOperatorType:(NSString *)type
                                  param:(NSDictionary *)param
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@/%@", WORK_PLAN_TARGET_FINDOPERATOR, type.length==0?@"":type] andParams:params success:success failure:fail];
}

/** 获取月销售目标(省份+品牌) */
- (void)getWorkPlanTargetAreaByOperatorType:(NSString *)type
                                      param:(NSDictionary *)param
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:@"%@/%@", WORK_PLAN_TARGET_AREA, type.length==0?@"":type] andParams:params success:success failure:fail];
}

/** 获取零售渠道单个走访客户详情 */
- (void)getRetailChannelItemDetail:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:RETAIL_CHANNEL_ITEM_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 删除工作计划 */
- (void)detailWorkPlanType:(NSString *)type
                       ids:(NSArray *)ids
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    [ApiTool putWithUrl:[NSString stringWithFormat:DELETE_WORK_PLAN, type] andParams:ids success:success failure:fail];
}

#pragma mark - 渠道开发计划

/** 获取渠道开发工作计划列表 */
- (void)getChannelDevelopPageParam:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CHANNEL_DEVELOPMENT_PAGE andParams:params success:success failure:fail];
}

/**  获取渠道工作计划详情 */
- (void)getChannelDevelopDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:CHANNEL_DEVELOPMENT_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 新建渠道开发工作计划列表 */
- (void)createChannelDevelopParam:(NSDictionary *)param
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CHANNEL_DEVELOPMENT_CREATE andParams:params success:success failure:fail];
}

/** 更新渠道开发工作计划列表 */
- (void)updateChannelDevelopDetailId:(long long)detailId
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool putWithUrl:CHANNEL_DEVELOPMENT_UPDATE andParams:params success:success failure:fail];
}

/** 获取当月累计拜访量 */
- (void)getChannelDevelopSumAccumulateVisitProvince:(NSString *)province
                                              param:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:CHANNEL_DEVELOPMENT_SUM_ACCUMULATEVISIT andParams:params success:success failure:fail];
}


/** 获取当天服务器日期 */
- (void)getDateTodayParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:API_DATE_TODAY andParams:params success:success failure:fail];
}

#pragma mark - 市场部工作计划
/** 获取市场部工作计划详情 */
- (void)getMarketEngineeringDetail:(long long)detailId
                             param:(NSDictionary *)param
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:MARKET_ENGINEER_DETAIL, detailId] andParams:params success:success failure:fail];
}

///** 获取当月累计发货量 */
//- (void)getMarketEngineeringSumAccumulateVisitParam:(NSDictionary *)param
//                                            success:(void (^)(id responseObject))success
//                                            failure:(void (^)(NSError *error))fail {
//    NSMutableDictionary *params = [NSMutableDictionary new];
//    if (param.count > 0) [params addEntriesFromDictionary:param];
//    [ApiTool postWithUrl:MARKET_ENGINEERING_SUM_ACTUALSHIPMENT andParams:params success:success failure:fail];
//}

#pragma mark - 战略部工作计划
/** 获取市场部工作计划详情 */
- (void)getStrategicEngineeringDetail:(long long)detailId
                                param:(NSDictionary *)param
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:STRATEGIC_ENGINEER_DETAIL, detailId] andParams:params success:success failure:fail];
}

#pragma mark - 直营工程部计划
/** 获取直营工程部计划详情 */
- (void)getDirectSalesEngineeringDetail:(long long)detailId
                                  param:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:DIRECT_SALES_ENGINEER_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取当月累计回款 */
- (void)getSumActuallShipmentDirectSaleProvince:(NSString *)province
                                          param:(NSDictionary *)param
                                        success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:WORK_SUM_ACTUAL_SHIPMENT_DIRECT_SALE andParams:params success:success failure:fail];
}

#pragma mark - 能诚计划
/** 获取能诚计划详情 */
- (void)getNengchengDetail:(long long)detailId
                     param:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:NENG_CHENG_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取能诚开发目标 */
- (void)getNengchengSumAccumulateVisitProvince:(NSString *)province
                                         param:(NSDictionary *)param
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", NENG_CHENG_SUM_ACCUMULATEVISIT, province];
    [ApiTool postWithUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] andParams:params success:success failure:fail];
}

/** 获取能诚单个走访客户详情 */
- (void)getNengchengItemDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:NENG_CHENG_ITEM, detailId] andParams:params success:success failure:fail];
}

/** 获取能诚当月累计发货量 */
- (void)getNengchengSumActualShipmentParam:(NSDictionary *)param
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:NENG_CHENG_SUM_ACTUALSHIPMENT andParams:params success:success failure:fail];
}

#pragma mark - 华爵计划
/** 获取华爵计划详情 */
- (void)getHuajueDetail:(long long)detailId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:HUAJUE_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取能诚单个走访客户附件详情 */
- (void)getHuajueItemDetail:(long long)detailId
                      param:(NSDictionary *)param
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:HUA_JUE_ITEM, detailId] andParams:params success:success failure:fail];
}

/** 获取华爵当月累计发货量 */
- (void)getHuajueSumActualShipmentParam:(NSDictionary *)param
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:HUA_JUE_SUM_ACTUALSHIPMENT andParams:params success:success failure:fail];
}

#pragma mark - 金木门
/** 获取金木门计划详情 */
- (void)getJinMuMenDetail:(long long)detailId
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:JINMU_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 获取金木门单个走访客户附件详情 */
- (void)getJinMuMenItemDetail:(long long)detailId
                        param:(NSDictionary *)param
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:JIN_MU_ITEM, detailId] andParams:params success:success failure:fail];
}

#pragma mark - 获取省份
/** 获取省份 */
- (void)getProvincePageByParam:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:QUERY_PROVINCE_PAGE andParams:params success:success failure:fail];
}

/** 获取当月累计发货量 */
- (void)getWorkSumAcutalShipmentType:(NSString *)type
                            province:(NSString *)province
                               param:(NSDictionary *)param
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:WORK_SUM_ACTUAL_SHIPMENT, type, province];
    [ApiTool postWithUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] andParams:params success:success failure:fail];
}

/** 所有获取 当日实际发货量和当月累计发货量 */
- (void)GET_SAP_SALES_BY_BRAND_AND_YEAR_Param:(NSDictionary *)param
                                     success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:GET_SAP_SALES_BY_BRAND_AND_YEAR andParams:params success:success failure:fail];
}

/** 具体某个 当日实际发货量和当月累计发货量 */
- (void)GET_SAP_SALES_BY_BRAND_AND_YEAR_Type:(NSString *)type
                                       param:(NSDictionary *)param
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:[NSString stringWithFormat:GET_SAP_SALES_BY_BRAND_AND_YEAR_TYPE, type] andParams:params success:success failure:fail];
}



/** 获取品牌列表 */
- (void)getBrandPageParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:BRAND_PAGE andParams:params success:success failure:fail];
}

/** 零售计划根据地址带出走访客户 */
- (void)findCarefulAreaParam:(NSDictionary *)param
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:FIND_CAREFUL_AREA andParams:params success:success failure:fail];
}

/** 根据邮编获取行政地址 */
- (void)getChinessAddressParam:(NSDictionary *)param
                          code:(NSString *)code
                      codeType:(NSInteger)codeType
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *typeStr = @"findProvinceByProvinceId";
    if (codeType == 1) typeStr = @"findCityByCityId";
    if (codeType == 2) typeStr = @"findAreaByAreaId";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@", REGION_FIND, typeStr, code];
    [ApiTool postWithUrl:urlStr andParams:params success:success failure:fail];
}

/** 根据id获取客户详情 */
- (void)getMemberDetailParam:(NSDictionary *)param
                    memberId:(long long)memberId
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [params setObject:@"0" forKey:@"number"];
    [params setObject:@"5" forKey:@"size"];
    [params setObject:@"DESC" forKey:@"direction"];
    [params setObject:@"id" forKey:@"property"];
    [params setObject:@[@{@"field":@"id",
                        @"option":@"EQ",
                        @"values":@[@(memberId)]}] forKey:@"rules"];
    [ApiTool postWithUrl:GET_CUSTOMER_LIST_PC andParams:params success:success failure:fail];
}

/** 获取差旅标准 */
- (void)getBxbzFroCrmParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool jspGetUrl:GetBxbzForCRM andParams:params success:success failure:fail];
}


/** 新建门店 */
- (void)createStoreParam:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:STOREM_MANAGE_CREATE andParams:params success:success failure:fail];
}

/** 获取门店详情 */
- (void)getStoreDetailId:(long long)detailId
                   param:(NSDictionary *)param
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:STOREM_MANAGE_DETAIL, detailId] andParams:params success:success failure:fail];
}

/** 根据省id获取省对象 */
- (void)getProvinceByProvinceId:(NSString *)provinceId
                          param:(NSDictionary *)param
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FIND_PROVINCE_BY_PROVINCEID, provinceId] andParams:params success:success failure:fail];
}

/** 根据市id获取市对象 */
- (void)getCityByCityId:(NSString *)cityId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FIND_CITY_BY_CITYID, cityId] andParams:params success:success failure:fail];
}

/** 根据区id获取区对象 */
- (void)getAreaByAreaId:(NSString *)areaId
                  param:(NSDictionary *)param
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:FIND_AREA_BY_AREA, areaId] andParams:params success:success failure:fail];
}


/** 根据省份获取当日发货量 */
- (void)getDailyDeveliveryByWorkType:(NSString *)workType
                        provinceName:(NSString *)provinceName
                               param:(NSDictionary *)param
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:DAILY_DEVELIVERY, workType, provinceName];
    [ApiTool getWithUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] andParams:params success:success failure:fail];
}

/** 根据省份获取未履行工程 */
- (void)getMarketEngineeringRequireEngineerParam:(NSDictionary *)param
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool postWithUrl:MARKET_ENGINEERING_REQUIRE_ENGINEER andParams:params success:success failure:fail];
}

/** 获取差旅到达地 */
- (void)getTravelCityListParam:(NSDictionary *)param
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool jspPostUrl:TRAVEL_GETCITY_LIST andParams:params success:success failure:fail];
}

/** 市接口 */
- (void)queryCityPageType:(NSInteger)type
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    if (type == 1) {
        [ApiTool postWithUrl:QUERY_CITY_INFOR andParams:params success:success failure:fail];
    } else if (type == 2) {
        [ApiTool postWithUrl:QUERY_AREA_INFOR andParams:params success:success failure:fail];
    }
}

/** 获取通用工作计划详情 */
- (void)getCommonWorkPlanById:(long long)workPlanId
                    param:(NSDictionary *)param
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:WORKPLAN_DETAIL_ID, workPlanId] andParams:params success:success failure:fail];
}

/** 获取通用工作计划单个走访客户详情 */
- (void)getWorkPlanItemDetail:(long long)detailId
                         param:(NSDictionary *)param
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    [ApiTool getWithUrl:[NSString stringWithFormat:WORKPLAN_ITEM, detailId] andParams:params success:success failure:fail];
}

/** 获取开发目标 */
- (void)getWorkPlanSumAccumulateVisitProvince:(NSString *)province
                                         param:(NSDictionary *)param
                                       success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [self baseParams];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", WORKPLAN_SUM_ACCUMULATEVISIT, province];
    [ApiTool postWithUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] andParams:params success:success failure:fail];
}

/** 获取当月累计发货量 */
- (void)getWorkPlanSumAcutalShipmentType:(NSString *)workType
                                province:(NSString *)province
                                   param:(NSDictionary *)param
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))fail {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (param.count > 0) [params addEntriesFromDictionary:param];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@", WORKPLAN_SUM_ACTUAL_SHIPMENT, workType, province];
    [ApiTool postWithUrl:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] andParams:params success:success failure:fail];
}

@end

