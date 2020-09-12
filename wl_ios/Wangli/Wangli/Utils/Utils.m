//
//  Utils.m
//  Wangli
//
//  Created by yeqiang on 2018/3/29.
//  Copyright © 2018年 yeqiang. All rights reserved.
//

#import "Utils.h"
#import "SVProgressHUD_Extension.h"
#import "RiskFollowMo.h"
#import "NSDate+Extension.h"

@implementation Utils

// 获取顶层控制器
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [Utils _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [Utils _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [Utils _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [Utils _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    return mobileNum.length > 0 ? YES : NO;
    NSString *mobileRegex = @"[1]\\d{10}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    
    return [mobileTest evaluateWithObject:mobileNum];
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    //    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //
    //    return [regextestmobile evaluateWithObject:mobileNum];
}

+ (void)showToastMessage:(NSString *)strMsg
{
    if (strMsg.length > 0) {
        [[UIApplication sharedApplication].keyWindow makeToast:strMsg duration:1 position:CSToastPositionCenter];
    }
}

+ (void)showToastMessage:(NSString *)strMsg position:(NSString *)position {
    [[UIApplication sharedApplication].keyWindow makeToast:strMsg duration:1 position:CSToastPositionBottom];
}

+ (UIView *)getLineView
{
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_LINE;
    
    return view;
}

//+ (void)changeViewRound:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = view.bounds;
//    maskLayer.path = maskPath.CGPath;
//    view.layer.mask = maskLayer;
//}

+ (CAShapeLayer *)drawContentFrame:(CGRect)frame corners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
+ (BOOL)urlValidation:(NSString *)string {
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    //    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    for (NSTextCheckingResult *matchin in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:matchin.range];
        NSLog(@"匹配");
        return YES;
    }
    return NO;
}


//根据文字内容和大小得到文字大小
+ (CGSize)getStringSize:(NSString *)string
                   font:(UIFont *)font
{
    return [string sizeWithAttributes:@{NSFontAttributeName:font}];
}

//根据文字内容和大小以及最大宽度得到文字大小
+ (CGSize)getStringSize:(NSString *)string
                   font:(UIFont *)font
                maxSize:(CGSize)maxSize
{
    CGRect rect = [string boundingRectWithSize:maxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

#pragma mark - 获取按A~Z顺序排列的所有联系人
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo arrPerson:(NSArray *)arrPerson {
    
    // 将耗时操作放到子线程
    dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        
        for (int i = 0 ; i < arrPerson.count; i++) {
            id mo = arrPerson[i];
            NSString *firstLetterString = [[NSString alloc] init];
            if ([arrPerson[i] isKindOfClass:[ContactMo class]]) {
                ContactMo *tmpMo = (ContactMo *)arrPerson[i];
                firstLetterString = [Utils getFirstLetterFromString:tmpMo.name];
            } else if ([arrPerson[i] isKindOfClass:[JYUserMo class]]) {
                JYUserMo *tmpMo = (JYUserMo *)arrPerson[i];
                firstLetterString = [Utils getFirstLetterFromString:tmpMo.name];
            }
            
            //获取到姓名的大写首字母
//            NSString *firstLetterString = [Utils getFirstLetterFromString:mo.name];
            //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
            if (addressBookDict[firstLetterString])
            {
                [addressBookDict[firstLetterString] addObject:mo];
            }
            //没有出现过该首字母，则在字典中新增一组key-value
            else
            {
                //创建新发可变数组存储该首字母对应的联系人模型
                NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:mo];
                //将首字母-姓名数组作为key-value加入到字典中
                [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
            }
        }
        
        // 将addressBookDict字典中的所有Key值进行排序: A~Z
        NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 将 "#" 排列在 A~Z 的后面
        if ([nameKeys.firstObject isEqualToString:@"#"])
        {
            NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
            [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
            [mutableNamekeys removeObjectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                addressBookInfo ? addressBookInfo(addressBookDict,mutableNamekeys) : nil;
            });
            return;
        }
        
        // 将排序好的通讯录数据回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookInfo ? addressBookInfo(addressBookDict,nameKeys) : nil;
        });
        
    });
    
}


#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    // 如果是空则返回#
    if (aString.length == 0) {
        return @"#";
    }
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}

/**
 多音字处理
 */
+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

+ (UIImage *) imageWithImages:(NSArray<UIImage *> *) images duration:(double) duration
{
    UIImage *animatedImage;
    if (!duration) {
        duration = (1.0f / 10.0f) * images.count;
    }
    animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    return animatedImage;
}

+ (void) showHUDWithStatus:(NSString *) status
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
//    NSArray *imageNames = @[@"360_basic_information",
//                            @"360_real_controller_data",
//                            @"360_contacts",
//                            @"360_address",
//                            @"360_credit",
//                            @"360_risk_warning",
//                            @"360_demand_plan",
//                            @"360_collection_plan",
//                            @"360_production_status",
//                            @"360_market_dynamics",
//                            @"360_transaction_tracking",
//                            @"360_system_message"];
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i=0; i< imageNames.count; i++) {
//        [images addObject:[UIImage imageNamed:imageNames[i]]];
//    }
//
//
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];//colorWithColor:[UIColor blackColor] alpha:0.2]];
//    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
//    [SVProgressHUD setInfoImage:[Utils imageWithImages:images duration:1]];
//    UIImageView *svImgView = [[SVProgressHUD sharedView] valueForKey:@"imageView"];
//    CGRect imgFrame = svImgView.frame;
//    // 设置图片的显示大小
//    imgFrame.size = CGSizeMake(139/2, 77/2);
//    svImgView.frame = imgFrame;
//    [SVProgressHUD showInfoWithStatus:status];
}

+ (void) showHUDWithStatusMaskNone:(NSString *) status
{
    NSArray *imageNames = @[@"c_basic_information",
                            @"c_personnel_organization",
                            @"c_financial_risk",
                            @"c_purchase",
                            @"c_production_status",
                            @"c_sales",
                            @"c_research",
                            @"c_visit",
                            @"c_business",
                            @"c_contract",
                            @"c_complain",
                            @"c_cost"];
    NSMutableArray *images = [NSMutableArray array];
    for (int i=0; i< imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:imageNames[i]]];
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];//colorWithColor:[UIColor blackColor] alpha:0.2]];
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setInfoImage:[Utils imageWithImages:images duration:1]];
    UIImageView *svImgView = [[SVProgressHUD sharedView] valueForKey:@"imageView"];
    CGRect imgFrame = svImgView.frame;
    // 设置图片的显示大小
    imgFrame.size = CGSizeMake(139/2, 77/2);
    svImgView.frame = imgFrame;
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)dismissHUD {
    [SVProgressHUD dismiss];
}

//获得中英文字符串的长度
+ (NSInteger)getToLength:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

+ (NSString *)showText:(NSString *)text length:(NSInteger)length {
    if (text.length <= length) {
        return text;
    } else {
        text = [text substringToIndex:length];
        text = [text stringByAppendingString:@"..."];
        return text;
    }
}

+ (ShowTextMo *)showTextRightStr:(NSString *)rightStr valueStr:(NSString *)valueStr {
    
    ShowTextMo *mo = [[ShowTextMo alloc] init];
    mo.text = ([valueStr isEqualToString:@"demo"] || valueStr.length == 0) ? rightStr : valueStr;
    mo.color = ([valueStr isEqualToString:@"demo"] || valueStr.length == 0) ? COLOR_B2 : COLOR_B1;
    return mo;
}

+ (NSString *)saveToValues:(NSString *)string {
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str.length == 0 ? @"" : str;
}

// 字符串规则转数组
+ (id)rulesValue:(NSString *)rulesValue {
    if ([rulesValue containsString:@","]) {
        NSArray *arr = [rulesValue componentsSeparatedByString:@","];
        return arr;
    } else {
        NSArray *arr = [[NSArray alloc] initWithObjects:rulesValue, nil];
        return arr;
    }
}

+ (NSString *)pieceStringByArray:(NSArray *)arrSource appendString:(NSString *)appendString {
    // 标签拼接
    NSString *tagStr = [[NSString alloc] init];
    appendString = appendString ? appendString : @" ";
    for (int i = 0; i < arrSource.count; i++) {
        
        id obj = arrSource[i];
        if ([obj isKindOfClass:[TagMo class]]) {
            tagStr = [tagStr stringByAppendingString:((TagMo *)obj).desp];
        } else {
            tagStr = [tagStr stringByAppendingString:arrSource[i]];
        }
        
        if (i < arrSource.count-1) {
            tagStr = [tagStr stringByAppendingString:appendString];
        }
    }
    return tagStr;
}

+ (NSMutableArray *)filterUrls:(NSArray *)urls arrFile:(NSArray *)arrFile  {
    NSMutableArray *newUrls = [[NSMutableArray alloc] initWithArray:urls];
    NSMutableArray *qiniuKeys = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in urls) {
        [qiniuKeys addObject:dic[@"qiniuKey"]];
    }
    
    for (int i = 0; i < arrFile.count; i++) {
        QiniuFileMo *mo = arrFile[i];
        if ([qiniuKeys containsObject:mo.thumbnail]) {
            NSInteger index = [qiniuKeys indexOfObject:mo.thumbnail];
            [newUrls replaceObjectAtIndex:index withObject:@{@"qiniuKey":STRING(mo.qiniuKey)}];
        }
    }
    
    for (int i = 0; i < newUrls.count; i++) {
        NSDictionary *dic = newUrls[i];
        NSString *str = [dic objectForKey:@"qiniuKey"];
        if ([str hasPrefix:@"http"]) {
            [newUrls removeObject:dic];
        }
    }
    
    return newUrls;
}

+ (NSMutableArray *)filterCustomUrls:(NSArray *)urls arrFile:(NSArray *)arrFile  {
    NSMutableArray *newUrls = [[NSMutableArray alloc] initWithArray:urls];
    NSMutableArray *qiniuKeys = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in urls) {
        [qiniuKeys addObject:dic[@"qiniuKey"]];
    }
    
    for (int i = 0; i < arrFile.count; i++) {
        QiniuFileMo *mo = arrFile[i];
        if ([qiniuKeys containsObject:mo.thumbnail]) {
            NSInteger index = [qiniuKeys indexOfObject:mo.thumbnail];
            [newUrls replaceObjectAtIndex:index withObject:@{@"qiniuKey":STRING(mo.qiniuKey)}];
        }
    }
    
    for (int i = 0; i < newUrls.count; i++) {
        NSDictionary *dic = newUrls[i];
        NSString *str = [dic objectForKey:@"qiniuKey"];
        if ([str hasPrefix:@"http"]) {
            [newUrls removeObject:dic];
        }
    }
    
    return newUrls;
}

+ (NSDictionary *)field:(NSString *)field option:(NSString *)option values:(NSArray *)values {
    return @{@"field":STRING(field),
             @"option":(option.length == 0 ? @"EQ" :option),
             @"values":STRING(values)
             };
}

+ (NSArray *)dateStr:(NSString *)dateStr {
    return [dateStr componentsSeparatedByString:@"-"];
}

+ (NSMutableDictionary *)specialConditions:(NSArray *)indexPathArr {
    NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
    for (int i = 0 ; i < indexPathArr.count; i++) {
        NSIndexPath *indexPath = indexPathArr[i];
        //获取section
        NSString *section = [NSString stringWithFormat:@"%ld", indexPath.section];
        //如果section不为空,则将indexpath添加到此数组中
        if (addressBookDict[section])
        {
            [addressBookDict[section] addObject:indexPath];
        }
        //没有出现过该首字母，则在字典中新增一组key-value
        else
        {
            //创建新发可变数组存储该首字母对应的联系人模型
            NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:indexPath];
            //将首字母-姓名数组作为key-value加入到字典中
            [addressBookDict setObject:arrGroupNames forKey:section];
        }
    }
    return addressBookDict;
}

// 订单
+ (NSString *)orderState:(NSString *)state {
    if ([state isEqualToString:@"SAVED"]) return @"待确认";
    if ([state isEqualToString:@"CANCEL"]) return @"已撤销";
    if ([state isEqualToString:@"CRM_COMMIT"]) return @"已提交";
    if ([state isEqualToString:@"OA_REVIEW"]) return @"价格审核中";
    if ([state isEqualToString:@"OA_REJECT"]) return @"价格审核未通过";
    if ([state isEqualToString:@"OA_APPROVE"]) return @"价格审核通过";
    if ([state isEqualToString:@"SAP_COMMIT"]) return @"SAP提交";
    if ([state isEqualToString:@"DELIVERYED"]) return @"已发货";
    if ([state isEqualToString:@"RECEIVED"]) return @"已收货";
    if ([state isEqualToString:@"CREDIT_REJECT"]) return @"信用审核未通过";
    if ([state isEqualToString:@"SAP_DELETE"]) return @"已取消";
    if ([state isEqualToString:@"OFFICE_REVIEW"]) return @"办事处确认中";
    else return @"";
}

// 发票
+ (NSString *)billingState:(NSString *)state {
    if ([state isEqualToString:@"SUSPENDING"]) return @"待处理";
    if ([state isEqualToString:@"READY"]) return @"待邮寄";
    if ([state isEqualToString:@"HANDLING"]) return @"邮寄中";
    if ([state isEqualToString:@"SOLVED"]) return @"已完成";
    else return @"";
}

// 发货
+ (NSString *)sapInvoiceState:(NSString *)state {
    if ([state isEqualToString:@"SUSPENDING"]) return @"待处理";
    if ([state isEqualToString:@"READY"]) return @"待邮寄";
    if ([state isEqualToString:@"HANDLING"]) return @"邮寄中";
    if ([state isEqualToString:@"SOLVED"]) return @"已完成";
    else return @"";
}

// 对账单
+ (NSString *)monthyStatementState:(NSString *)state {
    if ([state isEqualToString:@"SUSPENDING"]) return @"待处理";
    if ([state isEqualToString:@"READY"]) return @"待邮寄";
    if ([state isEqualToString:@"HANDLING"]) return @"邮寄中";
    if ([state isEqualToString:@"SOLVED"]) return @"已完成";
    else return @"";
}

// 电汇
+ (NSString *)receiptState:(NSString *)state {
    if ([state isEqualToString:@"ALREADY_PAID"]) return @"已打款";
    if ([state isEqualToString:@"TO_BE_CLAIMED"]) return @"待认领";
    if ([state isEqualToString:@"CLAIMED"]) return @"已认领";
    if ([state isEqualToString:@"ALREADY_ARRIVED"]) return @"已到账";
    if ([state isEqualToString:@"BOOKED"]) return @"已入账";
    else return @"";
}

+ (NSString *)receiptType:(NSString *)type {
    if ([type isEqualToString:@"ELECTRONIC"]) return @"电子承兑";
    if ([type isEqualToString:@"PAPER"]) return @"纸质承兑";
    if ([type isEqualToString:@"WIRE_TRANSFER"]) return @"电汇";
    else return @"";
}

// 外贸
+ (NSString *)foreignState:(NSString *)state {
    if ([state isEqualToString:@"INVOICE"]) return @"发货";
    if ([state isEqualToString:@"BOOKING"]) return @"贸带订舱";
    if ([state isEqualToString:@"LOADING"]) return @"装柜";
    if ([state isEqualToString:@"CUSTOMS"]) return @"报关";
    if ([state isEqualToString:@"SHIPMENT"]) return @"出运";
    if ([state isEqualToString:@"LOADINGBILL"]) return @"接受提单";
    if ([state isEqualToString:@"PAYMENT"]) return @"收款";
    if ([state isEqualToString:@"DELIVERY"]) return @"交单(客户接受)";
    if ([state isEqualToString:@"PICKUP"]) return @"提货";
    else return @"";
}

// 外贸
+ (NSString *)monthyState:(NSString *)state {
    if ([state isEqualToString:@"MAILED"]) return @"已邮寄";
    if ([state isEqualToString:@"CONFIRMED"]) return @"已确认";
    else return @"";
}

// 客户状态
+ (NSString *)memberState:(NSString *)state {
    if ([state isEqualToString:@"POTENTIAL"]) return @"潜在";
    if ([state isEqualToString:@"OFFICIAL"]) return @"正式";
    if ([state isEqualToString:@"FROZEN"]) return @"冻结";
    else return @"";
    
}

// 通用的弹框方法
+ (void)commonDeleteTost:(NSString *)tost
                     msg:(NSString *)msg
             cancelTitle:(NSString *)cancelTitle
            confirmTitle:(NSString *)confirmTitle
                 confirm:(void (^)(void))confirm
                  cancel:(void (^)(void))cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tost.length == 0? GET_LANGUAGE_KEY(@"提示"):tost message:msg.length == 0 ? GET_LANGUAGE_KEY(@"确定删除该条信息？"):msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:cancelTitle.length == 0? GET_LANGUAGE_KEY(@"取消") :cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) cancel();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:confirmTitle.length == 0?GET_LANGUAGE_KEY(@"继续"):confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Utils showHUDWithStatus:nil];
        if (confirm) confirm();
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [[Utils topViewController] presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)token {
    if (TheUser.userMo.id_token) {
        return [NSString stringWithFormat:@"Bearer %@",TheUser.userMo.id_token];
    }
    return nil;
}

+ (NSString *)officeName {
    NSString *officeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_OFFICENAME"];
    return officeName;
}

+ (UIImage *)createNameImage:(CGRect)rect name:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"client_default_avatar"]];
    imageView.frame = rect;
    imageView.backgroundColor = COLOR_B0;
    UIImage *image = imageView.image;
    CGSize size = CGSizeMake(image.size.width, image.size.height);//画布大小
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawAtPoint:CGPointMake(0, 0)];
    // 获得一个位图图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    if (name.length > 2) {
        name = [name substringToIndex:2];
    }
    CGFloat leftX = name.length < 2 ? size.width * 0.25 : size.width * 0.1;
    CGFloat topY = name.length < 2 ? size.height * 0.25 : size.height * 0.25;
    CGFloat fontSize = name.length < 2 ? size.height * 0.25 : size.height * 0.5;
    [name drawInRect:CGRectMake(leftX, topY, size.width, size.height*0.5) withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
//    [name drawAtPoint:CGPointMake(size.width*0.1,size.height*0.35) withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            
            // 原始字符串 key=value=others
            NSMutableString *mutStr = [[NSMutableString alloc] initWithString:keyValuePair];
            NSString *value = [mutStr substringFromIndex:key.length+1];
//            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

+ (NSString *)getURLTag:(NSString *)urlStr {
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    NSRange httpsRange = [urlStr rangeOfString:@"action:"];
    if (range.location == NSNotFound || httpsRange.location == NSNotFound) {
        return nil;
    }
    
    NSString *string = [urlStr substringWithRange:NSMakeRange(httpsRange.location+httpsRange.length, range.location-httpsRange.length - httpsRange.location)];
    return string ? string : nil;
}

+ (NSString *)getPrice:(CGFloat)price {
    NSString *priceStr = nil;
    if (price - 0.001 < 0) {
        return @"0";
    }
    if (price / 10000 > 1) {
        // 大于1万
        priceStr = [NSString stringWithFormat:@"%@ 万", [Utils getPriceFrom:price/10000]];
    } else {
        // 小于1万
        priceStr = [NSString stringWithFormat:@"%@", [Utils getPriceFrom:price]];
        return priceStr;
    }
//     亿    万
//    10000，0000，0000
    // 千万
    if (price / 100000000 > 1) {
        priceStr = [NSString stringWithFormat:@"%@亿", [Utils getPriceFrom:price/100000000]];
    }
    // 千亿
    if (price / 1000000000000 > 1) {
        priceStr = [NSString stringWithFormat:@"%@千亿", [Utils getPriceFrom:price/1000000000000]];
    }
    
    return priceStr;
}

+ (NSString *)getKGToTon:(CGFloat)price {
    NSString *priceStr = nil;
    if (price - 0.001 < 0) {
        return @"0";
    }
    price = price / 1000; // 吨
    
    if (price / 10000 > 1) {
        // 大于1万
        priceStr = [NSString stringWithFormat:@"%@ 万", [Utils getPriceFrom:price/10000]];
    } else {
        // 小于1万
        priceStr = [NSString stringWithFormat:@"%@", [Utils getPriceFrom:price]];
        return priceStr;
    }
    //     亿    万
    //    10000，0000，0000
    // 千万
    if (price / 100000000 > 1) {
        priceStr = [NSString stringWithFormat:@"%@亿",[Utils getPriceFrom:price/100000000]];
    }
    // 千亿
    if (price / 1000000000000 > 1) {
        priceStr = [NSString stringWithFormat:@"%@千亿", [Utils getPriceFrom:price/1000000000000]];
    }
    
    return priceStr;
}

+ (NSDate *)getNextMonthDate {
    
    //获取前一个月的时间
    NSDate *nextMonth = [Utils getPriousorLaterDateFromDate:[NSDate date] withMonth:1];
//    NSString *nextStr = [nextMonth stringWithFormat:@"YYYY-MM"];
    return nextMonth;
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}


+ (NSMutableArray *)uploadText:(NSMutableArray *)arrValues {
    NSMutableArray *newValue = [NSMutableArray new];
    for (int i = 0 ; i < arrValues.count; i++) {
        id obj = arrValues[i];
        if ([obj isKindOfClass:[NSString class]]) {
            [newValue addObject:[arrValues[i] isEqualToString:@"demo"]?@"":arrValues[i]];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [newValue addObject:obj];
        }
    }
    return newValue;
}

+ (BOOL)uploadToValues:(NSString *)string {
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str isEqualToString:@"demo"] || str.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)getPriceFrom:(CGFloat)price {
    CGFloat income = price;
    NSString *incomeStr = nil;
    if (fmodf(income, 1) == 0) {//如果有一位小数点
        incomeStr = [NSString stringWithFormat:@"%.0f",income];
    } else if (fmodf(income * 10, 1) == 0) {//如果有两位小数点
        incomeStr = [NSString stringWithFormat:@"%.1f",income];
    } else {
        incomeStr = [NSString stringWithFormat:@"%.2f",income];
    }
    return incomeStr;
}

+ (NSString *)bundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)getTimeByCount:(NSInteger)count {
    if (count <= 0) {
        return @"00:00";
    } else {
        long ss = count%60;         // 秒
        long mm = (count%3600)/60;  // 分
        long hh = count/3600;       // 时
        if (hh == 0) {
            return [NSString stringWithFormat:@"%02ld:%02ld", mm, ss];
        } else {
            return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hh, mm, ss];
        }
    }
}

+ (NSString *)insertShowText:(NSString *)showText idStr:(NSString *)idStr {
    if (showText.length == 0) {
        return @"出错了";
    } else {
        NSMutableString *str = [[NSMutableString alloc] initWithString:showText];
        NSString *urlStr = [NSString stringWithFormat:@"=%@=", idStr];
        [str insertString:urlStr atIndex:1];
        return str;
    }
}


+ (NSString *)changeDate:(long long)date formatterStr:(NSString *)formatterStr {
    NSTimeInterval interval = date / 1000.0;
    NSDate *tagDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr.length==0?@"yyyy-MM-dd":formatterStr];
    NSString *dateString = [formatter stringFromDate:tagDate];
    return dateString;
}


////时间范围
////表达方式
////今年
////今天
////<=60分钟
////XX分钟前（最小单位1分钟前）
////>60分钟
////显示日期和时间，例：今天 15:33
////其他天
////显示日期和时间，例：12-05 15:33
////往年
////显示日期和时间，例：2009-02-05 15:33
//
+ (NSString *)getLastUpdateInfoLastDateStr:(NSString *)lastDateStr {
    NSDateFormatter *lastDataFormatter = [[NSDateFormatter alloc] init];
    [lastDataFormatter setDateStyle:NSDateFormatterFullStyle];
    [lastDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lastDate = [lastDataFormatter dateFromString:lastDateStr];
    NSDate *curDate = [NSDate date];
    
    NSTimeInterval dateoff = [curDate timeIntervalSinceDate:lastDate];
    if (dateoff > 0)
    {
        if (dateoff < 60*60)
        {
            NSInteger minute = (NSInteger)(dateoff/60) + 1;
            return [NSString stringWithFormat:@"%ld%@", (long)minute, @"分钟前"];
        }
        else
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;

            NSDateComponents *components = [gregorian components:unitFlags fromDate:lastDate toDate:curDate options:0];
            
            // @"2019-01-01 11:11"
            if (components.year != 0) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *lastStr = [dateFormatter stringFromDate:lastDate];
                return [NSString stringWithFormat:@"%@", lastStr];
            }
            else {
                // 判断是否还是今天的时间
                NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
                [todayFormatter setDateStyle:NSDateFormatterFullStyle];
                [todayFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *todayBegin = [curDate dateWithYMD];
                
                // 今天零点 - 定时间
                // 如果 > 0 切小于24小时 , 昨天的时间
                // 如果 < 0 , 今天的时间
                NSTimeInterval todayOff = [todayBegin timeIntervalSinceDate:lastDate];
                if (todayOff > 0 && todayOff < (60*60*24)) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *lastdateStr = [dateFormatter stringFromDate:lastDate];
                    return [NSString stringWithFormat:@"昨天 %@", lastdateStr];
                } else if (todayOff < 0) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *lastdateStr = [dateFormatter stringFromDate:lastDate];
                    return [NSString stringWithFormat:@"今天 %@", lastdateStr];
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
                    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                    NSString *lastStr = [dateFormatter stringFromDate:lastDate];
                    return [NSString stringWithFormat:@"%@", lastStr];
                }
            }
            
            
//            if (components.year == 0 && components.month == 0)// && components.day == 0)
//            {
//                // 判断是否还是今天的时间
//                NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
//                [todayFormatter setDateStyle:NSDateFormatterFullStyle];
//                [todayFormatter setDateFormat:@"yyyy-MM-dd"];
//                NSDate *todayBegin = [curDate dateWithYMD];
//
//                NSTimeInterval todayOff = [todayBegin timeIntervalSinceDate:lastDate];
//                if (todayOff > 0) {
//                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
//                    [dateFormatter setDateFormat:@"HH:mm"];
//                    NSString *lastdateStr = [dateFormatter stringFromDate:lastDate];
//                    return [NSString stringWithFormat:@"昨天 %@", lastdateStr];
//                } else {
//                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
//                    [dateFormatter setDateFormat:@"HH:mm"];
//                    NSString *lastdateStr = [dateFormatter stringFromDate:lastDate];
//                    return [NSString stringWithFormat:@"今天 %@", lastdateStr];
//                }
//            }
        }
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *lastStr = [dateFormatter stringFromDate:lastDate];
    return [NSString stringWithFormat:@"%@", lastStr];

}

+ (UIImage *)changeGrayImage:(UIImage *)oldImage {
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage *)grayscaleImageForImage:(UIImage *)image {
    // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height),[image CGImage]);
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
            
        }
    }
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
     // we're done with image now too
    CGImageRelease(imageRef);
    return resultUIImage;
}

// 获取简称
+ (NSString *)getFeedIconText:(NSString *)iconText {
    NSString *orgStr = iconText;
    if ([orgStr containsString:@"AR/"] ||
        [orgStr containsString:@"SR/"] ||
        [orgStr containsString:@"FR/"]) {
        orgStr = [orgStr substringFromIndex:3];
    }
    
    if ([iconText containsString:@"("]){
        NSArray *urlComponents = [iconText componentsSeparatedByString:@"("];
        orgStr = [urlComponents firstObject];
    } else if([orgStr containsString:@"（"]) {
        NSArray *urlComponents = [iconText componentsSeparatedByString:@"（"];
        orgStr = [urlComponents firstObject];
    }
    if (orgStr.length > 2) {
        orgStr = [orgStr substringWithRange:NSMakeRange(1, 2)];
    }
    return orgStr;
}

+ (NSString *)imgUrlWithKey:(NSString *)key {
    return [[SwitchUrlUtil sharedInstance] imgUrlWithKey:key];
}

+ (NSString *)rootPath {
    
//    if (_rootPath.length == 0) {
//        //获取本地沙盒路径
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        //获取完整路径
//        NSString *documentsPath = [path objectAtIndex:0];
//        _rootPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userId_%@/video",[NSString stringWithFormat:@"%ld", (long)TheUser.userMo.id]]];
//        if (![[NSFileManager defaultManager] fileExistsAtPath:_rootPath]) {
//            [[NSFileManager defaultManager] createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//    }
//    return _rootPath;
    return @"";
}

// 获取偏移时间
+ (NSDate *)getDateDayOffset:(NSInteger)offset mydate:(NSDate *)mydate {
    // date转化为string
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // 正值加日期、负值减日期
    [comps setDay:offset];
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:mydate options:0];
    return newdate;
}

+ (NSString *)getPriceFromStr:(NSString *)str {
    if (str.length == 0 || [str isEqualToString:@"(null)"]) {
        return @"";
    }
    if (![str containsString:@"."]) {
        return str;
    }
    NSArray *pointArr = [str componentsSeparatedByString:@"."];
    if (pointArr.count <= 1) {
        return pointArr[0];
    } else {
        NSString *strBig = pointArr[0];
        NSString *strSmall = pointArr[1];
        if (strSmall.length > 2) {
            strSmall = [strSmall substringToIndex:2];
        }
        return [NSString stringWithFormat:@"%@.%@", strBig, strSmall];
    }
    
    
    //    for (NSString *keyValuePair in urlComponents) {
    //    NSString *incomeStr = nil;
    //    if (fmodf(income, 1) == 0) {//如果有一位小数点
    //        incomeStr = [NSString stringWithFormat:@"%.0f",income];
    //    } else if (fmodf(income * 10, 1) == 0) {//如果有两位小数点
    //        incomeStr = [NSString stringWithFormat:@"%.1f",income];
    //    } else {
    //        incomeStr = [NSString stringWithFormat:@"%.2f",income];
    //    }
    //    return incomeStr;
}

// 时间转时间戳
+ (long long)formateDateChangeToLong:(NSString *)orgDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:orgDate];
    NSTimeInterval stamp = [date timeIntervalSince1970];
    return stamp;
}

+ (void)goToSettingPage:(NSString *)tost {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GET_LANGUAGE_KEY(@"提示") message:tost preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GET_LANGUAGE_KEY(@"设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *privacyUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
            [[UIApplication sharedApplication] openURL:privacyUrl];
        }
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [[Utils topViewController] presentViewController:alert animated:YES completion:nil];
}

@end
