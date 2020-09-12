//
//  BaseTableView.m
//  Wangli
//
//  Created by yeqiang on 2018/12/26.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mj_footer.ignoredScrollViewContentInsetBottom = KMagrinBottom;
    }
    return self;
}

@end
