//
//  YXTabConfigMo.m
//  Wangli
//
//  Created by yeqiang on 2018/12/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "YXTabConfigMo.h"

@implementation YXTabConfigMo

- (void)setYxTabItemBaseView:(YXTabItemBaseView *)yxTabItemBaseView {
    if (yxTabItemBaseView) {
        _yxTabItemBaseView = yxTabItemBaseView;
        self.title = _yxTabItemBaseView.titleText;
        self.position = _yxTabItemBaseView.position;
    }
}

@end
