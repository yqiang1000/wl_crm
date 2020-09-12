//
//  Node.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)initWithParentId:(NSInteger)parentId nodeId:(NSInteger)nodeId name:(NSString *)name msg:(NSString *)msg url:(NSString *)url depth:(NSInteger)depth expand:(BOOL)expand isEnd:(BOOL)isEnd {
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.url = url;
        self.msg = msg;
        self.isEnd = isEnd;
        self.isOpen = NO;
        self.isSelect = NO;
    }
    return self;
}

- (NSString *)imgName {
    if (_url.length != 0) {
        return _url;
    }
    return self.isOpen ? @"cn_address_book_less" : @"cn_address_book_plus";
}

@end
