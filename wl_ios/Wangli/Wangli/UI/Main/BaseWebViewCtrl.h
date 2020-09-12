//
//  BaseWebViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/6/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "JYWebView.h"

@interface BaseWebViewCtrl : BaseViewCtrl

@property (nonatomic, assign) BOOL isFile;
@property (nonatomic, strong) JYWebView *jyWebView;
@property (nonatomic, assign) BOOL iHiddenNav;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;

- (void)reloadWebView;

@end
