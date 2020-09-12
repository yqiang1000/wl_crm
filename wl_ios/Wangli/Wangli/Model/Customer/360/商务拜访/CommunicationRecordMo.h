//
//  CommunicationRecordMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/17.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JYVoiceMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunicationRecordMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *text;

@property (nonatomic, strong) NSMutableArray <Optional> *images;

@property (nonatomic, strong) NSMutableArray <Optional> *voices;

@property (nonatomic, strong) NSMutableArray <Optional> *videos;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
