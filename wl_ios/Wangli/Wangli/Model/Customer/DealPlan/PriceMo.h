//
//  PriceMo.h
//  Wangli
//
//  Created by yeqiang on 2018/7/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PriceMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *datab;
@property (nonatomic, copy) NSString <Optional> *datbi;
@property (nonatomic, copy) NSString <Optional> *guidePrice;
@property (nonatomic, copy) NSString <Optional> *kmein;
@property (nonatomic, copy) NSString <Optional> *kondm;
@property (nonatomic, copy) NSString <Optional> *kondmtext;
@property (nonatomic, copy) NSString <Optional> *konwa;
@property (nonatomic, copy) NSString <Optional> *kpein;
@property (nonatomic, copy) NSString <Optional> *max;
@property (nonatomic, copy) NSString <Optional> *min;

@end
