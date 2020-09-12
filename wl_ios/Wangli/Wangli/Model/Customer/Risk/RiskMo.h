//
//  RiskMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RiskMo : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString <Optional> *type;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *content;
@property (nonatomic, copy) NSString <Optional> *riskManageComments;
@property (nonatomic, copy) NSString <Optional> *riskManageHandleDate;


//{
//    "id": 2,
//    "type": "10",
//    "title": "高风险客户",
//    "content": "客户资金紧张，有多笔银行未结清的贷款",
//    "riskManageComments": "增加说明备注",
//    "riskManageHandleDate":"2018-04-28"
//}

@end
