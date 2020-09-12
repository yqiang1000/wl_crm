//
//  BusinessClueView.h
//  Wangli
//
//  Created by yeqiang on 2018/12/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessClueView : UIView

@property (nonatomic, strong) NSMutableArray *arrData;
- (void)loadData:(NSMutableArray *)data;

@end


@interface BusinessClueCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;
- (void)loadData:(id)model;

@end

NS_ASSUME_NONNULL_END
