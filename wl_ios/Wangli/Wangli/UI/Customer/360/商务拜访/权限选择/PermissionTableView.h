//
//  PermissionTableView.h
//  Wangli
//
//  Created by yeqiang on 2019/3/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionTableView : UITableView

-(instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)data;

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic, strong) NSMutableArray *arrSelectData;

@end

NS_ASSUME_NONNULL_END


//{
//    "createdBy": "guanliyuan",
//    "createdDate": "2019-01-25 19:45:45",
//    "lastModifiedBy": "guanliyuan",
//    "lastModifiedDate": "2019-01-26 19:31:32",
//    "id": 139,
//    "deleted": false,
//    "sort": 0,
//    "fromClientType": null,
//    "optionGroup": [],
//    "searchContent": null,
////    "parent": ,
//    "name": "审计(a)",
//    "desp": "",
//    "oaDepartmentId": "222",
//    "approval": null,
//    "path": "-45-31-",
//    "totalCount": 2,
//    "subDepartmentCount": 0,
//    "sapVkbur": null,
//    "salesOffice": null,
//    "officeOrderApprovalConfigs": null,
//    "checked": false
//}
