//
//  LeftLabel.h
//  Wangli
//
//  Created by yeqiang on 2018/5/6.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftLabel : UILabel

@property (nonatomic, assign) NSInteger totalLength;
@property (nonatomic, assign) NSInteger leftLength;

- (void)setLeftLength:(NSInteger)leftLength totalLength:(NSInteger)totalLength;

@end
