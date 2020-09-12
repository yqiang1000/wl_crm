//
//  BusinessVisitActivityMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/11.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessVisitActivityMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;      //;      // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;      // "2019-01-08 16:07:49",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;      // "2019-01-11 13:47:15",
@property (nonatomic, copy) NSString <Optional> *createdBy;      // "潘梦洋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;      // "潘梦洋",
@property (nonatomic, copy) NSString <Optional> *address;      // "",
@property (nonatomic, copy) NSString <Optional> *status;      // "",
@property (nonatomic, copy) NSString <Optional> *endDate;      // "2019-01-09 16:07:00",
@property (nonatomic, copy) NSString <Optional> *beginDate;      // "2019-01-01 16:07:00",
@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;      // [],
@property (nonatomic, copy) NSString <Optional> *statusValue;      // "",
@property (nonatomic, copy) NSString <Optional> *visitNumber;      // "AXBF20190108001",
@property (nonatomic, copy) NSString <Optional> *purpose;      // "拜访1",
@property (nonatomic, copy) NSString <Optional> *signInRecord;      // "",
@property (nonatomic, copy) NSString <Optional> *signInInfo;      // "1111",
@property (nonatomic, copy) NSString <Optional> *visitReport;      // "测得",
@property (nonatomic, strong) NSDictionary <Optional> *visitor;
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, copy) NSString <Optional> *remark;      // "433322222 俄",
@property (nonatomic, strong) NSArray <Optional> *intelligenceItemList;      // [],
@property (nonatomic, copy) NSString <Optional> *communicateRecord;      // "22"


@property (nonatomic, copy) NSString <Optional> *showText;      // "22"
// 本地自己处理的字段
@property (nonatomic, strong) NSMutableArray <Optional> *images;
@property (nonatomic, strong) NSMutableArray <Optional> *voices;
@property (nonatomic, strong) NSMutableArray <Optional> *videos;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray <Optional> *userMos;
@property (nonatomic, strong) NSMutableArray <Optional> *memberMos;
// 初始化附件，将附件进行归类处理
- (void)configAttachmentList;

@end

NS_ASSUME_NONNULL_END
