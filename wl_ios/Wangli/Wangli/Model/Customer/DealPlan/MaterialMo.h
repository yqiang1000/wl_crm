//
//  MaterialMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MaterialMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *createdBy;
@property (nonatomic, copy) NSString <Optional> *createdDate;
@property (nonatomic, copy) NSString <Optional> *lastModifiedBy;
@property (nonatomic, copy) NSString <Optional> *lastModifiedDate;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString <Optional> *fromClientType;
@property (nonatomic, strong) NSArray <Optional> *optionGroup;
@property (nonatomic, copy) NSString <Optional> *factoryCode;
@property (nonatomic, copy) NSString <Optional> *factoryName;
@property (nonatomic, copy) NSString <Optional> *batchNumber;
@property (nonatomic, copy) NSString <Optional> *weight;
@property (nonatomic, copy) NSString <Optional> *productLevel;
@property (nonatomic, copy) NSString <Optional> *productLevelName;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString <Optional> *matnr;
@property (nonatomic, copy) NSString <Optional> *spec;
@property (nonatomic, copy) NSString <Optional> *grade;

@property (nonatomic, copy) NSString <Optional> *quantity;


//@property (nonatomic, copy) NSString <Optional> *createdBy; //; //"18021647031",
//@property (nonatomic, copy) NSString <Optional> *createdDate; //"2018-12-19 21:05:22",
//@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"18021647031",
//@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2018-12-19 21:05:22",
//@property (nonatomic, copy) NSString <Optional> *id; //8,
//@property (nonatomic, copy) NSString <Optional> *deleted; //false,
//@property (nonatomic, copy) NSString <Optional> *sort; //1,
//@property (nonatomic, copy) NSString <Optional> *fromClientType; //null,
//@property (nonatomic, copy) NSString <Optional> *optionGroup; //[],
@property (nonatomic, copy) NSString <Optional> *name; //"叠瓦单晶",
@property (nonatomic, copy) NSString <Optional> *remark; //""


@end


