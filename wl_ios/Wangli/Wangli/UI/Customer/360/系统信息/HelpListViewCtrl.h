//
//  HelpListViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/5/10.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"

@interface HelpListViewCtrl : BaseViewCtrl

// JYUserMo
@property (nonatomic, strong) NSMutableArray *defaultValues;

@end


@interface HelpListMo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long moId;
@property (nonatomic, assign) BOOL isSelected;

@end

