//
//  IntelligenceItemBeanMo.h
//  Wangli
//
//  Created by yeqiang on 2019/1/7.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntelligenceItemBeanMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *intelligenceId;    //": 50,
@property (nonatomic, copy) NSString <Optional> *intelligenceItemId;    //": 105,
@property (nonatomic, copy) NSString <Optional> *intelligenceType;    //": "投产状况",
@property (nonatomic, copy) NSString <Optional> *intelligenceInfoValue;    //": "生产类",
@property (nonatomic, copy) NSString <Optional> *content;    //": "呜呜呜呜"

@end

NS_ASSUME_NONNULL_END
