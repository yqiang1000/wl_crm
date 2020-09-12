//
//  TrendsCreateBusinessViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CommonRowMo.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsCreateBusinessViewCtrl : BaseViewCtrl

/** 来源 默认NO:来自360（不可修改客户） YES:来自Tab（可修改客户） */
@property (nonatomic, assign) BOOL fromTab;                 // 来源
/** 是否更新 默认NO:新建 YES:更新 */
@property (nonatomic, assign) BOOL isUpdate;                // 来源
@property (nonatomic, copy) NSString *dynamicId;            // 动态表单Id
@property (nonatomic, assign) long long detailId;           // 详情id
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrData;      // 表单模型数组
@property (nonatomic, strong) NSMutableArray *attachments;  // 缩略图
@property (nonatomic, strong) NSMutableArray *attachUrls;   // 图片


//商机标题：title
//商机来源：resourceKey，resourceValue
//关联活动：activity，activityTitle
//关联线索：clue , clueTitle
//提交人：operator，提交人姓名：operatorName（默认）
//提交日期：submitDate
//客户：member，客户简称：abbreviation
//预计成交日期：transactionDate
//商机金额：amount
//商机内容：content
//商机类型：typeKey，typeValue
//号码 customerTel
//
// competitorBehaviorset 子表
//[
//友商：member ， 友商简称：abbreviation
//负责人姓名：principalName
//负责人职位：principalJob
//负责人电话：principalTel
//备注：content
//]


@end

NS_ASSUME_NONNULL_END


//商机标题：title
//重要程度：importantValue  importantKey
//
//商机来源：resourceValue，resourceKey
//关联线索：clue{
//    id,
//    title
//}
//关联活动：activity{
//    id,
//    title
//}
//提交时间：submitDate
//客户：member{
//    id
//    abbreviation
//}
//商机来源中老客户推荐对应的相关客户
//regularCustomer{
//    id
//    abbreviation
//}
//客户联系人：customerContact
//联系人电话：customerTel
//联系人职位：customerJob
//预计成交日期：transactionDate
//商机金额：amount
//商机内容：content
//商机状态：statusKey，statusValue
//商机类型：typeValue，typeKey

