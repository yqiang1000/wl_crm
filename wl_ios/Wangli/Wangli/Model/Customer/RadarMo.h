//
//  RadarMo.h
//  Wangli
//
//  Created by yeqiang on 2018/11/2.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RadarMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *field;
@property (nonatomic, copy) NSString <Optional> *fieldTitle;
@property (nonatomic, assign) CGFloat fieldValue;

@end
