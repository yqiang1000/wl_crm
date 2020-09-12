//
//  TrendsFeedMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/8.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrendsFeedMo : JSONModel

@property (nonatomic, assign) long long id;
//@property (nonatomic, copy) NSString <Optional> *sort;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, copy) NSString <Optional> *createdBy;         // "系统自动创建",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;         // "系统自动创建",
@property (nonatomic, copy) NSString <Optional> *content;         // "订单30023914已经创建",
@property (nonatomic, copy) NSString <Optional> *url;         // "",
@property (nonatomic, copy) NSString <Optional> *departmentName;         // "",
@property (nonatomic, copy) NSString <Optional> *childCategoryId;         // 3733,
@property (nonatomic, copy) NSString <Optional> *childPrimaryKey;         // 0,
@property (nonatomic, copy) NSString <Optional> *iconDictNameUrl;
@property (nonatomic, copy) NSString <Optional> *createdDateStr;         // "",
@property (nonatomic, strong) NSArray <Optional> *vdieoAttachmentList;         // [],
@property (nonatomic, strong) NSArray <Optional> *imageAttachmentList;         // [],
@property (nonatomic, strong) NSArray <Optional> *voiceAttachmentList;         // [],
@property (nonatomic, copy) NSString <Optional> *title;         // "订单创建",
@property (nonatomic, copy) NSString <Optional> *abbreviation;         // "",
@property (nonatomic, copy) NSString <Optional> *orgName;         // "",
@property (nonatomic, copy) NSString <Optional> *fkType;         // "SALES_CONTRACT",
@property (nonatomic, copy) NSString <Optional> *iconDictName;         // "contract_follow_icon",
@property (nonatomic, copy) NSString <Optional> *operatorName;         // "系统自动创建",
@property (nonatomic, copy) NSString <Optional> *bigCategory;         // "contract",
@property (nonatomic, copy) NSString <Optional> *fkTypeValue;         // "合同",
@property (nonatomic, copy) NSString <Optional> *iconUrl;         // "",
@property (nonatomic, assign) BOOL deleteAble;         // false,
@property (nonatomic, assign) long long favorited;         // -8,
@property (nonatomic, assign) NSInteger viewed;         // -8,
@property (nonatomic, assign) NSInteger viewedCount;         // 0,
@property (nonatomic, assign) NSInteger liked;         // -8,
@property (nonatomic, assign) NSInteger likedCount;         // 0
@property (nonatomic, copy) NSString <Optional> *avatarUrl;

@property (nonatomic, copy) NSString <Optional> *operatorNameSrFrAr;

@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;

// 自己处理的字段
@property (nonatomic, strong) NSMutableArray <Optional> *images;
@property (nonatomic, strong) NSMutableArray <Optional> *voices;
@property (nonatomic, strong) NSMutableArray <Optional> *videos;
- (void)configAttachmentList;

@end

NS_ASSUME_NONNULL_END
