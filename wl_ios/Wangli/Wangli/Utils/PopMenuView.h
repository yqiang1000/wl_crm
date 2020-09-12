//
//  PopMenuView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/12.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum ArrowPosition{
    ArrowPosition_LeftTop,
    ArrowPosition_RightTop
}ArrowPosition;

@interface PopMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     position:(ArrowPosition)positipon
                     arrTitle:(NSArray *)arrTitle
                     arrImage:(NSArray *)arrImage
                  defaultItem:(NSInteger)defaultIndex
                    itemClick:(void (^)(NSInteger index))itemClick
                  cancelClick:(void (^)(id))cancelClick;

@end
