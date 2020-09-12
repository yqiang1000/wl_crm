//
//  Utils.h
//  Wangli
//
//  Created by yeqiang on 2018/3/29.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContactMo.h"
#import "ShowTextMo.h"

/**
 *  获取原始顺序的所有联系人的Block
 */
typedef void(^AddressBookArrayBlock)(NSArray *addressBookArray);

/**
 *  获取按A~Z顺序排列的所有联系人的Block
 *  @param addressBookDict 装有所有联系人的字典->每个字典key对应装有多个联系人模型的数组->每个模型里面包含着用户的相关信息.
 *  @param peopleNameKey   联系人姓名的大写首字母的数组
 */
typedef void(^AddressBookDictBlock)(NSMutableDictionary *addressBookDict,NSMutableArray *nameKeys);


@interface Utils : NSObject

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// 获取顶层控制器
+ (UIViewController *)topViewController;

// tost提示
+ (void)showToastMessage:(NSString *)strMsg;

+ (void)showToastMessage:(NSString *)strMsg position:(NSString *)position;

// 分割线
+ (UIView *)getLineView;

// 绘制圆角
//+ (void)changeViewRound:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;
+ (CAShapeLayer *)drawContentFrame:(CGRect)frame corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

/**
 * 网址正则验证 1或者2使用哪个都可以
 *  @param string 要验证的字符串
 *  @return 返回值类型为BOOL
 */
+ (BOOL)urlValidation:(NSString *)string;

//根据文字内容和大小得到文字大小
+ (CGSize)getStringSize:(NSString *)string
                   font:(UIFont *)font;

//根据文字内容和大小以及最大宽度得到文字大小
+ (CGSize)getStringSize:(NSString *)string
                   font:(UIFont *)font
                maxSize:(CGSize)maxSize;

//根据联系人获取排序列表
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo arrPerson:(NSArray *)arrPerson;

// 显示等待动画
+ (void) showHUDWithStatus:(NSString *) status;

+ (void) showHUDWithStatusMaskNone:(NSString *) status;

+ (void) dismissHUD;

//获得中英文字符串的长度
+ (NSInteger)getToLength:(NSString*)strtemp;

// 显示前几位字符
+ (NSString *)showText:(NSString *)text length:(NSInteger)length;

// 显示占位或者文本
+ (ShowTextMo *)showTextRightStr:(NSString *)rightStr valueStr:(NSString *)valueStr;

// 保存编辑文本
+ (NSString *)saveToValues:(NSString *)string;

// 字符串规则转数组
+ (id)rulesValue:(NSString *)rulesValue;

// 拼接字符串
+ (NSString *)pieceStringByArray:(NSArray *)arrSource appendString:(NSString *)appendString;

// 附件去掉历史上传的
+ (NSMutableArray *)filterUrls:(NSArray *)urls arrFile:(NSArray *)arrFile;

// rules
+ (NSDictionary *)field:(NSString *)field option:(NSString *)option values:(NSArray *)values;

// 时间截取 年月
+ (NSArray *)dateStr:(NSString *)dateStr;

// 处理多选筛选
+ (NSMutableDictionary *)specialConditions:(NSArray *)indexPathArr;

// 订单状态
+ (NSString *)orderState:(NSString *)state;

// 发票
+ (NSString *)billingState:(NSString *)state;

// 发货状态
+ (NSString *)sapInvoiceState:(NSString *)state;

// 电汇状态
+ (NSString *)receiptState:(NSString *)state;

// 电汇类型
+ (NSString *)receiptType:(NSString *)type;

// 外贸
+ (NSString *)foreignState:(NSString *)state;

// 外贸
+ (NSString *)monthyState:(NSString *)state;

// 客户状态
+ (NSString *)memberState:(NSString *)state;

// 通用的弹框方法
+ (void)commonDeleteTost:(NSString *)tost
                     msg:(NSString *)msg
             cancelTitle:(NSString *)cancelTitle
            confirmTitle:(NSString *)confirmTitle
                 confirm:(void (^)(void))confirm
                  cancel:(void (^)(void))cancel;

// 获取token
+ (NSString *)token ;

+ (NSString *)officeName;

// 画文字图片
+ (UIImage *)createNameImage:(CGRect)rect name:(NSString *)name;

// 获取URL参数
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

// 获取URL传递功能模块
+ (NSString *)getURLTag:(NSString *)urlStr;

+ (NSString *)getPrice:(CGFloat)price;

// 获取下一个月时间
+ (NSDate *)getNextMonthDate;

// 处理非必填选项
+ (NSMutableArray *)uploadText:(NSMutableArray *)arrValues;

// 是否可以保存
+ (BOOL)uploadToValues:(NSString *)string;

// 获取价格
+ (NSString *)getPriceFrom:(CGFloat)price;

// 获取bundleId
+ (NSString *)bundleId;

// 获取重量单位吨
+ (NSString *)getKGToTon:(CGFloat)price;

// 获取重量单位吨
+ (NSString *)getTimeByCount:(NSInteger)count;

// 获取原始数据
+ (NSString *)insertShowText:(NSString *)showText idStr:(NSString *)idStr;

// 服务器时间戳转显示时间
+ (NSString *)changeDate:(long long)date formatterStr:(NSString *)formatterStr;

// 显示几分钟前
+ (NSString *)getLastUpdateInfoLastDateStr:(NSString *)lastDateStr;

// 图片置灰
+ (UIImage *)changeGrayImage:(UIImage *)oldImage;

// 图片置灰
+ (UIImage *)grayscaleImageForImage:(UIImage *)image;

// 获取简称
+ (NSString *)getFeedIconText:(NSString *)iconText;

// 图片URL
+ (NSString *)imgUrlWithKey:(NSString *)key;

// 获取偏移时间
+ (NSDate *)getDateDayOffset:(NSInteger)offset mydate:(NSDate *)mydate;

// 文本转小数，在转文本，省略后面0
+ (NSString *)getPriceFromStr:(NSString *)str;

// 时间转时间戳
+ (long long)formateDateChangeToLong:(NSString *)orgDate;

// 跳转到隐私设置页面
+ (void)goToSettingPage:(NSString *)tost;
@end
