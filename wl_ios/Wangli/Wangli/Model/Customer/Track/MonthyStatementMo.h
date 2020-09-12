//
//  MonthyStatementMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/14.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MonthyStatementMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *accountNumber;
@property (nonatomic, strong) NSDictionary <Optional> *status;
@property (nonatomic, copy) NSString <Optional> *sendDate;
@property (nonatomic, copy) NSString <Optional> *receiveDate;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *yearMonth;
@property (nonatomic, copy) NSString <Optional> *currentMonthOrderQuantity;
@property (nonatomic, copy) NSString <Optional> *currentMonthOrderAmount;
@property (nonatomic, copy) NSString <Optional> *lastMonthRemainAmount;
@property (nonatomic, copy) NSString <Optional> *currentMonthPayAmount;
@property (nonatomic, copy) NSString <Optional> *currentMonthOweAmount;
@property (nonatomic, strong) NSDictionary <Optional> *company;
@property (nonatomic, strong) NSArray <Optional> *attachmentList;
@property (nonatomic, strong) NSArray <Optional> *balanceAccountItemSet;

@end
