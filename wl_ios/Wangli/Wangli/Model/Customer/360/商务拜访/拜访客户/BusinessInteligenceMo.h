//
//  BusinessInteligenceMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN


@interface IntelligenceItemSet : JSONModel

@property (nonatomic, assign) long long  id;
@property (nonatomic, copy) NSString <Optional> *intelligenceTypeKey;//;    //"  情报类型key",
@property (nonatomic, copy) NSString <Optional> *intelligenceTypeValue; //;    //"情报类型的value",
@property (nonatomic, copy) NSString <Optional> *intelligenceInfoKey;//;    //"信息类型key",
@property (nonatomic, copy) NSString <Optional> *intelligenceInfoValue;//;    //"信息类型value",
@property (nonatomic, copy) NSString <Optional> *content;//;    //"内容",
@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;

@property (nonatomic, strong) NSMutableArray <Optional> *attachmentDicList;

@property (nonatomic, copy) NSString <Optional> *intelligenceTypeDesp;

@property (nonatomic, strong) DicMo <Optional> *intelligenceType;
@property (nonatomic, strong) DicMo <Optional> *intelligenceInfo;

// 本地自己处理的字段
@property (nonatomic, strong) NSMutableArray <Optional> *images;
@property (nonatomic, strong) NSMutableArray <Optional> *voices;
@property (nonatomic, strong) NSMutableArray <Optional> *videos;
@property (nonatomic, strong) NSMutableArray <Optional> *userMos;
@property (nonatomic, copy) NSString <Optional> *showText;
@property (nonatomic, assign) BOOL isSelected;


@property (nonatomic, strong) NSDictionary <Optional> *member;    // {},
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, copy) NSString <Optional> *itemStatusValue;    // "待验证",
@property (nonatomic, strong) NSDictionary <Optional> *intelligence;  // 上一层   // {
//        "id;    // 99,
//        "sort;    // 10,
//        "createdDate;    // "2019-01-17 15:00:20",
//        "lastModifiedDate;    // "2019-01-17 15:00:20",
//        "createdBy;    // "曹康",
//        "lastModifiedBy;    // "曹康",
//        "member;    // {},
//        "operator;    // {
//            "id;    // 22,
//            "sort;    // 10,
//            "createdDate;    // "2018-11-29 21:15:42",
//            "lastModifiedDate;    // "2019-01-17 12:12:44",
//            "createdBy;    // "15167156690",
//            "lastModifiedBy;    // "曹康",
//            "name;    // "曹康",
//            "username;    // "1003825",
//            "department;    // {
//                "id;    // 75,
//                "sort;    // 200,
//                "createdDate;    // "2018-12-12 00:00:00",
//                "lastModifiedDate;    // "2019-01-10 12:05:27",
//                "createdBy;    // "13901565517",
//                "lastModifiedBy;    // "费婷",
//                "name;    // "国内销售部（Z）",
//                "oaDepartmentId;    // "411",
//                "desp;    // ""
//            },
//            "title;    // "销售总监(z)",
//            "oaCode;    // "1003825",
//            "departmentName;    // "",
//            "oaId;    // "648"
//        },
//        "statusKey;    // "",
//        "statusValue;    // "",
//        "bigCategoryKey;    // "technology_trend",
//        "businessTypeKey;    // "battery",
//        "bigCategoryValue;    // "技术趋势",
//        "businessTypeValue;    // "电池",
//        "collectDate;    // ""
//    },
@property (nonatomic, copy) NSString <Optional> *itemStatusKey;    // "draft"

- (void)uploadAttementCompleted:(void(^)(NSMutableArray *))uploadSuccess;
- (void)configAttachmentList;

@end

@interface BusinessInteligenceMo : JSONModel

@property (nonatomic, assign) long long id;

@property (nonatomic, copy) NSString <Optional> *bigCategoryKey;
@property (nonatomic, copy) NSString <Optional> *bigCategoryValue;
@property (nonatomic, copy) NSString <Optional> *businessTypeKey;
@property (nonatomic, copy) NSString <Optional> *businessTypeValue;
@property (nonatomic, strong) NSDictionary <Optional> *member;

@property (nonatomic, copy) NSString <Optional> *collectDate;
@property (nonatomic, strong) NSMutableArray <Optional> *intelligenceItemSet;

@end

NS_ASSUME_NONNULL_END

