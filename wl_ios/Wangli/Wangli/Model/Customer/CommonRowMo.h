//
//  CommonRowMo.h
//  Wangli
//
//  Created by yeqiang on 2018/11/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DicMo.h"
#import "QiniuFileMo.h"
#import "MaterialMo.h"

// 单元格类型
/**  输入框 */
static NSString *K_INPUT_TEXT = @"INPUT_TEXT";
/** 下拉选择框 */
static NSString *K_INPUT_SELECT = @"INPUT_SELECT";
/** 日期选择框 */
static NSString *K_DATE_SELECT = @"DATE_SELECT";
/** 附件输入框 */
static NSString *K_FILE_INPUT = @"FILE_INPUT";
/** 客户选择 */
static NSString *K_INPUT_MEMBER = @"INPUT_MEMBER";
/** 标题类型 */
static NSString *K_INPUT_TITLE = @"INPUT_TITLE";
/** 产品大类 */
static NSString *K_INPUT_PRODUCT_TYPE = @"INPUT_PRODUCT_TYPE";
/** 部门 */
static NSString *K_INPUT_DEPARTMENT = @"INPUT_DEPARTMENT";
/** 负责人 */
static NSString *K_INPUT_OPERATOR = @"INPUT_OPERATOR";
/** 简单单选 */
static NSString *K_INPUT_RADIO = @"INPUT_RADIO";
/** 其他特殊的选择框(本地的) */
static NSString *K_INPUT_SELECT_OTHER = @"INPUT_SELECT_OTHER";
/** 确定(本地的) */
static NSString *K_INPUT_BUTTON = @"INPUT_BUTTON";
/** Switch按钮 */
static NSString *K_INPUT_TOGGLEBUTTON = @"INPUT_TOGGLEBUTTON";
/** 品牌 */
static NSString *K_INPUT_BRAND_SELECT = @"INPUT_BRAND_SELECT";
/** 链接 */
static NSString *K_INPUT_LINK = @"INPUT_LINK";
/** 地址 */
static NSString *K_INPUT_ADDRESS = @"INPUT_ADDRESS";

// 输入框类型
/** 短文本 && 默认 */
static NSString *K_SHORT_TEXT = @"SHORT_TEXT";
/** 长文本 */
static NSString *K_LONG_TEXT = @"LONG_TEXT";
/** 数字框A */
static NSString *K_NUMBER_A_TEXT = @"NUMBER_A_TEXT";
/** 数字框B */
static NSString *K_NUMBWE_B_TEXT = @"NUMBWE_B_TEXT";
/** 手机框 */
static NSString *K_PHONE_TEXT = @"PHONE_TEXT";
/** 邮箱 */
static NSString *K_EMAIL_TEXT = @"EMAIL_TEXT";

// 键盘类型
/** 默认 */
static NSString *K_DEFAULT = @"KBDEFAULT";
/** 非小数 */
static NSString *K_INTEGER = @"KBINTEGER";
/** 小数 */
static NSString *K_DOUBLE = @"KBDOUBLE";

// 王力CRM工作计划限制
static NSString *K_BEFORE_WORKPLAN_DATE = @"beforeWorkPlanDate";
static NSString *K_HANDLE_WORKPLAN_DATE = @"handleWorkPlanDate";
static NSString *K_BEYOND_SETTIME = @"beyondSetTime";

@protocol DicMo;
@protocol QiniuFileMo;
@protocol MaterialMo;

@interface CommonRowMo : JSONModel

/** 是否必填    YES：不必填  NO，必填 */
@property (nonatomic, assign) BOOL nullAble;                            // 是否必填 默认必填
/** 是否可编辑    YES：可编辑  NO，不可编辑 */
@property (nonatomic, assign) BOOL editAble;                            // 是否可修改
/** 单元格高度，客户端自己初始化 */
@property (nonatomic, assign) CGFloat rowHeight;                        // 高度
/** 改行所处的序号 */
@property (nonatomic, assign) NSInteger index;                          // 序号
/**
 *  单元格字类型字符串
 *  K_INPUT_TEXT
 *  K_INPUT_SELECT
 *  K_DATE_SELECT
 *  K_FILE_INPUT
 *  K_INPUT_MEMBER
 *  K_RADIO_INPUT
 *  K_INPUT_TITLE
 */
@property (nonatomic, copy) NSString <Optional> *rowType;               // 单元格类型
/** 左侧标题 */
@property (nonatomic, copy) NSString <Optional> *leftContent;           // 左侧标题
/** 右侧标题 */
@property (nonatomic, copy) NSString <Optional> *rightContent;          // 右侧标题
/** 上传字段key */
@property (nonatomic, copy) NSString <Optional> *key;                   // 上传字段
/** 上传的值 strValue */
@property (nonatomic, copy) NSString <Optional> *strValue;              // 输入值
/** 接收列表时的对象id类型 value */
@property (nonatomic, strong) id <Optional> value;

// 编辑
/**
 *  键盘类型字符串
 *  K_DEFAULT
 *  K_INTEGER
 *  K_DOUBLE
 */
@property (nonatomic, copy) NSString <Optional> *keyBoardType;          // 键盘类型

/**
 *  输入框类型字符串
 *  K_SHORT_TEXT
 *  K_LONG_TEXT
 *  K_NUMBER_A_TEXT
 *  K_NUMBWE_B_TEXT
 *  K_PHONE_TEXT
 *  K_EMAIL_TEXT
 */
@property (nonatomic, copy) NSString <Optional> *inputType;             // 输入框类型

/** 字典项字段 */
@property (nonatomic, copy) NSString <Optional> *dictName;              // 字典项字段
/** 字典项数组（多选） */
@property (nonatomic, strong) NSMutableArray <DicMo *> <DicMo, Optional> *mutipleValue;     // 字典项数组
/** 字典项单选 */
@property (nonatomic, strong) DicMo <DicMo, Optional> *singleValue;     // 字典项单选
/** 是否多选 YES:多选， NO:单选 */
@property (nonatomic, assign) BOOL mutiAble;                            // 是否多选

/** 日期格式  "yyyy-MM", "yyyy-MM-dd", "yyyy-MM-dd hh", "yyyy-MM-dd HH:mm:ss"等 */
@property (nonatomic, copy) NSString <Optional> *pattern;               // 日期格式

/** 附件 */
@property (nonatomic, strong) NSMutableArray <QiniuFileMo *> <QiniuFileMo, Optional> *attachments;   // 附件

/** 客户 */
@property (nonatomic, strong) CustomerMo <Optional> *member;            // 客户
/** 产品大全 */
@property (nonatomic, strong) id <Optional> m_obj;                        // 产品大全
/** 产品大全数组（多选） */
@property (nonatomic, strong) NSMutableArray <Optional> *m_objs;          // 字典项数组

/** 其他标志 */
@property (nonatomic, copy) NSString <Optional> *otherTag;              // 其他标志

/** 其他参数 */
@property (nonatomic, strong) NSMutableDictionary <Optional> *otherParam;

/** 文字备注，提醒开发人员的文字 */
@property (nonatomic, copy) NSString <Optional> *remark;                // 文字备注，提醒开发人员的文字

/** 键盘类型 */
@property (nonatomic, assign) UIKeyboardType iosKeyBoardType;           // 键盘类型

/** 真值 */
@property (nonatomic, copy) NSString <Optional> *trueDesp;
/** 假值 */
@property (nonatomic, copy) NSString <Optional> *falseDesp;
/** 默认值 */
@property (nonatomic, assign) BOOL defaultValue;


@end
