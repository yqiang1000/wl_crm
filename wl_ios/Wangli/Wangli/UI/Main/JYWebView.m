//
//  JYWebView.m
//  Wangli
//
//  Created by yeqiang on 2018/10/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "JYWebView.h"

@interface JYWebView () <WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end;

@implementation JYWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.navigationDelegate = self;
        [self addSubview:self.progressView];
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationDelegate = self;
        [self addSubview:self.progressView];
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKNavigationDelegate

//* 判断链接是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * str = navigationAction.request.URL.absoluteString;
    NSLog(@"url地址：%@", str);
    [self remarkAction:str];
    BOOL goToWeb = YES;
    if ([str containsString:@"//action:"]) {
        NSRange range = [str rangeOfString:@"://action:"];
        if (range.location == NSNotFound) {
            goToWeb = YES;
        }
        str = [str substringFromIndex:range.location];
        str = [[Utils bundleId] stringByAppendingString:str];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        goToWeb = NO;
    }
    
    if(decisionHandler)
    {
        decisionHandler(goToWeb?WKNavigationActionPolicyAllow: WKNavigationActionPolicyCancel);
    }
}

//* 拿到响应后决定是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//* 链接开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.progressView.hidden = _hidenProgress;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self bringSubviewToFront:self.progressView];
}

//* 收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

//* 加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    if (_jyWebViewDelegate && [_jyWebViewDelegate respondsToSelector:@selector(jyWebView:didFailProvisionalNavigation:withError:)]) {
        [_jyWebViewDelegate jyWebView:self didFailProvisionalNavigation:navigation withError:error];
    }
}

//* 当内容开始到达主帧时被调用（即将完成）
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

//* 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.progressView.hidden = YES;
    if (_jyWebViewDelegate && [_jyWebViewDelegate respondsToSelector:@selector(jyWebView:didFinishNavigation:)]) {
        [_jyWebViewDelegate jyWebView:self didFinishNavigation:navigation];
    }
}

//* 在提交的主帧中发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if(error.code==NSURLErrorCancelled) {
        [self webView:webView didFinishNavigation:navigation];
    } else {
        self.progressView.hidden = YES;
    }
}

//* 当webView需要响应身份验证时调用(如需验证服务器证书)
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge    completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable   credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//* 当webView的web内容进程被终止时调用。(iOS 9.0之后)
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}

- (void)remarkAction:(NSString *)str {
//    [LocalRemarkHelp dealWithUrlStr:str complete:^(NSString *key, NSString *value) {
//        NSLog(@"%@:%@", key, value);
//    } failed:^(NSString *str) {
//        NSLog(@"%@", str);
//    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.estimatedProgress;
        if (self.progressView.progress == 1)
        {
            __weak typeof(JYWebView *) weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^ {
                 weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
             } completion:^(BOOL finished) {
                 weakSelf.progressView.hidden = YES;
             }];
        }
    }
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        _progressView.backgroundColor = UIColor.clearColor;
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        _progressView.progressTintColor = COLOR_EAB201;
        _progressView.hidden = _hidenProgress;
    }
    return _progressView;
}


@end
