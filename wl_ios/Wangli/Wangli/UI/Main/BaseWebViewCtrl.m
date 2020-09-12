//
//  BaseWebViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseWebViewCtrl.h"
//#import "WKWebViewJavascriptBridge.h"

@interface BaseWebViewCtrl ()

@property (nonatomic, strong) UILabel *labResult;
//@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;

@end

@implementation BaseWebViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBtn.hidden = NO;
    self.naviView.lineView.backgroundColor = COLOR_C1;
    self.title = _titleStr;
    [self setWebUI];
    
    if ([Utils urlValidation:_urlStr]) {
        [self setWebUI];
        self.urlStr = [self dfStringByAddingPercentEncoding:self.urlStr];
        [self.jyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
//        [self setupJsMethod];
    } else {
        [self setTextUI];
        self.labResult.text = _urlStr;
    }
}

//- (void)dealloc {
//    [_jsBridge removeHandler:@"getiosVersion"];
//}
//
//- (void)setupJsMethod {
//    [WKWebViewJavascriptBridge enableLogging];
//    _jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.jyWebView];
//    [_jsBridge setWebViewDelegate:self.jyWebView];
//
//    // JS调用OC方法
//    [_jsBridge registerHandler:@"getiosVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        NSDictionary *back = @{@"version":STRING(version)};
//        if (responseCallback) responseCallback(back);
//    }];
//}

// 处理url里包含#等特殊字符的情况
- (NSString *)dfStringByAddingPercentEncoding:(NSString *)urlstr {
    NSString *encodeStr = @"";
    if (urlstr.length > 0) {
        //针对中文和`%^{}\"[]|\\<> 进行转义，#作为H5路由标志，不处理
        encodeStr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`%^{}\"[]|\\<> "].invertedSet];
    }
    return encodeStr;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSSet *websiteDataTypes = [NSSet setWithArray:@[(WKWebsiteDataTypeLocalStorage)]];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
    }];
}

- (void)setWebUI {
    _jyWebView = [[JYWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_jyWebView];
    
    [_jyWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(!_iHiddenNav) {
            make.top.equalTo(self.naviView.mas_bottom);
        } else {
            make.top.equalTo(self.naviView.mas_top).offset(STATUS_BAR_HEIGHT);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)setTextUI {
    [self.view addSubview:self.labResult];
    
    [self.labResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
    }];
}

- (void)reloadWebView {
    [self.jyWebView reload];
}

#pragma mark - setter getter

- (UILabel *)labResult {
    if (!_labResult) {
        _labResult = [[UILabel alloc] init];
        _labResult.textColor = COLOR_B1;
        _labResult.font = FONT_F16;
        _labResult.numberOfLines = 0;
        _labResult.textAlignment = NSTextAlignmentCenter;
    }
    return _labResult;
}

@end
