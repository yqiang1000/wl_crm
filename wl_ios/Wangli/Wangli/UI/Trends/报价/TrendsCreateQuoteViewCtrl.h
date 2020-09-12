//
//  TrendsCreateQuoteViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CommonRowMo.h"
#import "QiniuFileMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsCreateQuoteViewCtrl : BaseViewCtrl

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

@end

NS_ASSUME_NONNULL_END
