//
//  JYWebView.h
//  Wangli
//
//  Created by yeqiang on 2018/10/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <WebKit/WebKit.h>

@class JYWebView;
@protocol JYWebViewDelegate <NSObject>

- (void)jyWebView:(JYWebView *)jyWebView didFinishNavigation:(WKNavigation *)navigation;

- (void)jyWebView:(JYWebView *)jyWebView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;

@end

@interface JYWebView : WKWebView

@property (nonatomic, assign) BOOL hidenProgress;
@property (nonatomic, weak) id <JYWebViewDelegate> jyWebViewDelegate;

@end
