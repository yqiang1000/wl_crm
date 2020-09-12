//
//  MemberCardViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/3/18.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberCardViewCtrl : BaseViewCtrl

@property (nonatomic, strong) CustomerMo *mo;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) BOOL forbidRefresh;

- (void)delayGotoCurrentIndex;

@end

NS_ASSUME_NONNULL_END
