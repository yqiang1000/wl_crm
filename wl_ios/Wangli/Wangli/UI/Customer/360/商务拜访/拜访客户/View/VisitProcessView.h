//
//  VisitProcessView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTabItemBaseView.h"
#import "BusinessVisitActivityMo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateReportBlock)(void);

@interface VisitProcessView : YXTabItemBaseView

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) BusinessVisitActivityMo *model;

@property (nonatomic, copy) UpdateReportBlock updateReportBlock;

@end

NS_ASSUME_NONNULL_END
