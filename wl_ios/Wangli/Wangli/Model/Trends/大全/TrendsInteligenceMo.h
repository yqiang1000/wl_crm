//
//  TrendsInteligenceMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/14.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsInteligenceMo : TrendsBaseMo

//@property (nonatomic, copy) NSString <Optional> *id;    //;    // 155,
//@property (nonatomic, copy) NSString <Optional> *sort;    // 10,
@property (nonatomic, copy) NSString <Optional> *createdDate;    // "2019-01-13 18:01:22",
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;    // "2019-01-13 18:01:22",
@property (nonatomic, copy) NSString <Optional> *createdBy;    // "潘梦洋",
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;    // "潘梦洋",
@property (nonatomic, copy) NSString <Optional> *content;    // "测试附件",
@property (nonatomic, strong) NSDictionary <Optional> *member;
@property (nonatomic, strong) NSDictionary <Optional> *intelligence;
@property (nonatomic, copy) NSString <Optional> *itemStatusKey;    // "draft",
@property (nonatomic, strong) NSMutableArray <Optional> *attachmentList;    // [],
@property (nonatomic, copy) NSString <Optional> *intelligenceTypeKey;    // "purchase_supplier_chanage",
@property (nonatomic, copy) NSString <Optional> *intelligenceInfoKey;    // "purchare_type",
@property (nonatomic, copy) NSString <Optional> *intelligenceInfoValue;    // "采购类",
@property (nonatomic, copy) NSString <Optional> *intelligenceTypeValue;    // "供应商名录变动",
@property (nonatomic, copy) NSString <Optional> *itemStatusValue;    // "待审核",
@property (nonatomic, strong) NSDictionary <Optional> *operator;
@property (nonatomic, assign) NSInteger viewedCount;
// 自己处理的字段
@property (nonatomic, strong) NSMutableArray <Optional> *images;
@property (nonatomic, strong) NSMutableArray <Optional> *voices;
@property (nonatomic, strong) NSMutableArray <Optional> *videos;
- (void)configAttachmentList;

@end

NS_ASSUME_NONNULL_END
