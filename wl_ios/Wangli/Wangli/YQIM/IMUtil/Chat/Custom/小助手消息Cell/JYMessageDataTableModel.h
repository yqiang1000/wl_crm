//
//  JYMessageDataTableModel.h
//  TUIKitDemo
//
//  Created by yeqiang on 2020/1/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYMessageDataTableModel : NSObject

@property (nonatomic, copy) NSString *left;
@property (nonatomic, copy) NSString *right;
@property (nonatomic, copy) NSString *rightLink;
@property (nonatomic, copy) NSString *rightStyle;


//@property (nonatomic, assign) CGFloat location;
//@property (nonatomic, assign) CGFloat length;

@end

NS_ASSUME_NONNULL_END
