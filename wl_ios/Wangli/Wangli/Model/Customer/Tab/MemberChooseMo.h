//
//  MemberChooseMo.h
//  Wangli
//
//  Created by yeqiang on 2018/5/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ChooseBeansMo : JSONModel

@property (nonatomic, strong) NSString <Optional> *key;
@property (nonatomic, strong) NSString <Optional> *value;
@property (nonatomic, strong) NSString <Optional> *option;

@end

@protocol ChooseBeansMo;

@interface MemberChooseMo : JSONModel

@property (nonatomic, copy) NSString <Optional> *name;
@property (nonatomic, strong) NSMutableArray <ChooseBeansMo *> <Optional> *chooseBeans;
@property (nonatomic, copy) NSString <Optional> *memberFeild;
@property (nonatomic, assign) BOOL hidden;          //是否隐藏
@property (nonatomic, assign) BOOL multiSelect;     //是否多选
@property (nonatomic, assign) BOOL special;         //是否特殊字符
@property (nonatomic, assign) NSInteger selectTag;  //选中的标记

@end
