//
//  TaskMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/20.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "QiniuFileMo.h"

@protocol QiniuFileMo;
@interface TaskMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;   //"1004613",
@property (nonatomic, copy) NSString <Optional> *createdDate;   //"2019-01-25 16:02:41",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;   //"1004613",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;   //"2019-01-25 16:04:02",
@property (nonatomic, assign) long long id;   //40,
@property (nonatomic, copy) NSString <Optional> *deleted;   //false,
@property (nonatomic, copy) NSString <Optional> *sort;   //10,
@property (nonatomic, copy) NSString <Optional> *fromClientType;   //null,
@property (nonatomic, strong) NSArray <Optional> *optionGroup;   //[],
@property (nonatomic, copy) NSString <Optional> *typeKey;   //"assingn",
@property (nonatomic, copy) NSString <Optional> *typeValue;   //"指派任务",
@property (nonatomic, strong) NSDictionary <Optional> *founder;
@property (nonatomic, copy) NSString <Optional> *taskNumber;   //"RW20190125002",
@property (nonatomic, copy) NSString <Optional> *title;   //"请提供客户检测报告",
@property (nonatomic, strong) NSDictionary <Optional> *receiver;
@property (nonatomic, strong) NSArray <Optional> *receiverSet;   //null,
@property (nonatomic, strong) NSArray <Optional> *collaboratorSet;   //[],
@property (nonatomic, copy) NSString <Optional> *collaboratorSetStr;   //"",
@property (nonatomic, copy) NSString <Optional> *statusKey;   //"received",
@property (nonatomic, copy) NSString <Optional> *statusValue;   //"处理中",
@property (nonatomic, copy) NSString <Optional> *startTime;   //"2019-01-25 16:01:00",
@property (nonatomic, assign) BOOL updateAble;   //false,
@property (nonatomic, assign) BOOL favoriteAble;   //false,
@property (nonatomic, copy) NSString <Optional> *endTime;   //"2019-01-30 16:02:00",
@property (nonatomic, copy) NSString <Optional> *remark;   //"无",
@property (nonatomic, copy) NSString <Optional> *finishTime;   //null,
@property (nonatomic, copy) NSString <Optional> *remindTimeKey;   //"three_hour",
@property (nonatomic, copy) NSString <Optional> *remindTimeValue;   //"3",
@property (nonatomic, assign) NSInteger favoriteId;   //-1,
@property (nonatomic, strong) NSMutableArray <QiniuFileMo *> <QiniuFileMo,Optional> *attachmentList;   //null,
@property (nonatomic, strong) NSArray <Optional> *comments;   //null,
@property (nonatomic, copy) NSString <Optional> *rejectDesp;   //null

@end
