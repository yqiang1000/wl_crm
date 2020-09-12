//
//  DepartmentMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/16.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DepartmentMo : JSONModel

@property (nonatomic, assign) long long id; // 本部门及下属部门人员统计
@property (nonatomic, strong) NSDictionary <Optional> *parent; //上级部门
//@ExcelField(fieldName = "name", desp = "部门", isExport = false)
@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, copy) NSString <Optional> *desp;
@property (nonatomic, copy) NSString <Optional> *oaDepartmentId;//oa部门id

@property (nonatomic, assign) BOOL approval; //办事处订单是否需要审批

@property (nonatomic, copy) NSString <Optional> *path; // 记录上级路径，以-分隔
@property (nonatomic, assign) long long totalCount; // 本部门及下属部门人员统计
@property (nonatomic, assign) long long subDepartmentCount; //下级部门数量

@property (nonatomic, copy) NSString <Optional> *sapVkbur; //SAP销售部门编号
@property (nonatomic, strong) NSDictionary <Optional> *salesOffice; //SAP销售部门绑定

@property (nonatomic, strong) NSArray <Optional> *children; //下级部门
@property (nonatomic, strong) NSArray <Optional> *operators;//下属操作员
@property (nonatomic, strong) NSArray <Optional> *visibleArticles; // 可见文章
@property (nonatomic, strong) NSArray <Optional> *officeOrderApprovalConfigs;

@property (nonatomic, assign) BOOL checked ; //是否选中

@end

NS_ASSUME_NONNULL_END
