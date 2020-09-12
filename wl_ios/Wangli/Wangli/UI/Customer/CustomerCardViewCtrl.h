//
//  CustomerCardViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/4/9.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "CustomerMo.h"

@interface CustomerCardViewCtrl : BaseViewCtrl

@property (nonatomic, strong) CustomerMo *mo;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, assign) BOOL forbidRefresh;

- (void)delayGotoCurrentIndex;

@end
