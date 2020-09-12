//
//  SearchHeaderView.h
//  ABCInstitution
//
//  Created by yeqiang on 2017/8/9.
//  Copyright © 2017年 北京暄暄科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - SearchHeaderView

@interface SearchHeaderView : UIView

@property (nonatomic, strong) UILabel *labTitle;

@end

#pragma mark - SearchFooterView

@interface SearchFooterView : UIView

@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIView *baseView;

@end
