//
//  CommonItemMo.h
//  Wangli
//
//  Created by yeqiang on 2018/4/28.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommonItemMo : JSONModel

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *imgUrl;
@property (nonatomic, copy) NSString <Optional> *imgName;
@property (nonatomic, assign) NSInteger statisticsCount;
@property (nonatomic, copy) NSString <Optional> *type;


@end
