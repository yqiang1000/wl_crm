//
//  VisitNoteMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BusinessVisitActivityMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface VisitNoteMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *title;
@property (nonatomic, copy) NSString <Optional> *content;

//@property (nonatomic, strong) NSMutableArray <Optional> *files;
//@property (nonatomic, strong) NSMutableArray <Optional> *urls;
//@property (nonatomic, strong) NSMutableArray <Optional> *thumbnails;

@property (nonatomic, strong) BusinessVisitActivityMo <Optional> *model;

@end

NS_ASSUME_NONNULL_END
