//
//  YXTabConfigMo.h
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTabItemBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXTabConfigMo : NSObject

@property (nonatomic, strong) YXTabItemBaseView *yxTabItemBaseView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger position;   //tag && position

@end

NS_ASSUME_NONNULL_END
