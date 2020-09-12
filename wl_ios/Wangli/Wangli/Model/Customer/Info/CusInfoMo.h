//
//  CusInfoMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CusInfoDetailMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *leftContent;
@property (nonatomic, copy) NSString <Optional> *rightContent;
@property (nonatomic, copy) NSString <Optional> *field;
@property (nonatomic, assign) BOOL change;
@property (nonatomic, copy) NSString <Optional> *dictField;
@property (nonatomic, copy) NSString <Optional> *url;
@property (nonatomic, copy) NSString <Optional> *rightValue;
@property (nonatomic, copy) NSString <Optional> *placeHolder;

// 任意类型
@property (nonatomic, strong) id <Optional> m_obj;
@property (nonatomic, strong) NSMutableArray <Optional> *m_objs;

@end

@protocol CusInfoDetailMo;

@interface CusInfoMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, strong) NSMutableArray <CusInfoDetailMo *> <Optional> *data;
@property (nonatomic, strong) NSMutableArray <QiniuFileMo *> <Optional> *attachments;

@end
