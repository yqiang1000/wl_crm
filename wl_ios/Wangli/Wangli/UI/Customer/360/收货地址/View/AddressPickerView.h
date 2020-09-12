//
//  AddressPickerView.h
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerView : UIView

// arrDefault : 邮编
// arrResult : 分别是省市区的邮编和中文名，以及总的地址字符串
- (instancetype)initWithDefaultItem:(NSArray *)arrDefault
                          itemClick:(void (^)(NSArray *arrResult))itemClick
                        cancelClick:(void (^)(AddressPickerView *obj))cancelClick;

@end

