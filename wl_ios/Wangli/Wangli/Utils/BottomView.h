//
//  BottomView.h
//  Wangli
//
//  Created by yeqiang on 2018/5/3.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                        items:(NSArray *)items
                  defaultItem:(NSInteger)defaultIndex
                    itemClick:(void (^)(NSInteger index))itemClick
                  cancelClick:(void (^)(BottomView *obj))cancelClick;

- (void)show;

@end
