//
//  CardModel.h
//  CardSwitchDemo
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerMo.h"

@interface XLCardItem : NSObject

@property (nonatomic, strong) CustomerMo *mo;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@end
