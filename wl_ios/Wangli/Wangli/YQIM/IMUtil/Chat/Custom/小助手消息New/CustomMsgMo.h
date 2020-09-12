//
//  CustomMsgMo.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"
#import "SummaryMo.h"
#import "OfflinePushInfoMo.h"
#import "CustomItemMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomMsgMo : YQBaseModel

@property (nonatomic, copy) NSString *FormatType;
@property (nonatomic, copy) NSString *HelperType;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *BusinessDate;
@property (nonatomic, copy) NSString *Url;

@property (nonatomic, strong) NSArray <CustomItemMo *> *Cells;
@property (nonatomic, strong) NSArray <ContentTextMo *> *Contents;
@property (nonatomic, strong) SummaryMo *Summary;
@property (nonatomic, strong) MoreInfoMo *MoreInfo;
@property (nonatomic, strong) OfflinePushInfoMo *OfflinePushInfo;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
