//
//  JYMessageDataModel.h
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYMessageDataTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYMessageDataModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *businessDate;
@property (nonatomic, copy) NSString *abstracts;
@property (nonatomic, copy) NSString *abstractsLink;
@property (nonatomic, copy) NSString *fromAccount;
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, strong) NSArray <JYMessageDataTableModel *> *table;

@end

NS_ASSUME_NONNULL_END
