//
//  SearchTopView.h
//  Wangli
//
//  Created by yeqiang on 2018/4/11.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTopView;
@protocol SearchTopViewDelegate <NSObject>

@optional
- (void)searchTopView:(SearchTopView *)searchTopView textFieldDidBeginEditing:(UITextField *)textField;

- (void)searchTopView:(SearchTopView *)searchTopView textFieldShouldReturn:(UITextField *)textField;

- (void)searchTopViewVoiceClick:(SearchTopView *)searchTopView;

@end

@interface SearchTopView : UIView

@property (nonatomic, strong) UIButton *btnSearch;
@property (nonatomic, strong) UITextField *searchTxtField;
@property (nonatomic, strong) UIImageView *imgLeft;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, assign) BOOL hasAudio;

@property (nonatomic, weak) id <SearchTopViewDelegate> delegate;

- (instancetype)initWithAudio:(BOOL)hasAudio;

@end
