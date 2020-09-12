//
//  Node.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupMo.h"
#import "JYUserMo.h"
#import "LinkManOfficeMo.h"

/**
 *  每个节点类型
 */
@interface Node : NSObject

@property (nonatomic, strong) GroupMo *groupMo;         // 部门
@property (nonatomic, strong) JYUserMo *userMo;         // 用户
@property (nonatomic, strong) LinkManOfficeMo *linkManOfficeMo;         // 用户

@property (nonatomic , assign) NSInteger parentId;      //父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , assign) NSInteger nodeId;        //本节点的id

@property (nonatomic , copy) NSString *name;            //本节点的名称

@property (nonatomic , assign) NSInteger depth;         //该节点的深度

@property (nonatomic , assign) BOOL expand;             //该节点是否处于展开状态

@property (nonatomic, copy) NSString *url;              //图片地址

@property (nonatomic, copy) NSString *msg;              //部门信息

@property (nonatomic, copy) NSString *imgName;          //默认图片

@property (nonatomic , assign) BOOL isEnd;              //是否最低层，用户

@property (nonatomic , assign) BOOL isOpen;             //是否展开

@property (nonatomic, assign) BOOL isSelect; //是否被选中 LinkManOfficeMo 用

/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId:(NSInteger)parentId nodeId:(NSInteger)nodeId name:(NSString *)name msg:(NSString *)msg url:(NSString *)url depth:(NSInteger)depth expand:(BOOL)expand isEnd:(BOOL)isEnd;

@end
