//
//  ContenBeansMo.h
//  Wangli
//
//  Created by yeqiang on 2018/6/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ContenBeansMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *date;
@property (nonatomic, copy) NSString <Optional> *totalAmount;
@property (nonatomic, copy) NSString <Optional> *dueAmount;

@end
