//
//  CommonRowMo.m
//  Wangli
//
//  Created by yeqiang on 2018/11/7.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "CommonRowMo.h"
#import "DepartmentMo.h"

@implementation CommonRowMo

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        [self dealWithValueClass:_value];
    }
    return self;
}

+ (NSMutableArray *)arrayOfModelsFromDictionaries:(NSArray *)array error:(NSError *__autoreleasing *)err {
    NSMutableArray *result = [super arrayOfModelsFromDictionaries:array error:err];
    for (CommonRowMo *tmpMo in result) {
        [tmpMo dealWithValueClass:tmpMo.value];
    }
    return result;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"nullAble"]||
        [propertyName isEqualToString:@"editAble"]||
        [propertyName isEqualToString:@"rowHeight"]||
        [propertyName isEqualToString:@"index"]||
        [propertyName isEqualToString:@"mutiAble"]||
        [propertyName isEqualToString:@"defaultValue"]||
        [propertyName isEqualToString:@"iosKeyBoardType"])
    return YES;
    
    return NO;
}

- (void)dealWithValueClass:(id)value {
    if (value == nil) {
        return;
    }
    if ([_rowType isEqualToString:K_INPUT_TEXT]) {
        if ([value isKindOfClass:[NSString class]]) {
            _strValue = (NSString *)(STRING(value));
        } else {
            _strValue = [NSString stringWithFormat:@"%@", value];
        }
    } else if ([_rowType isEqualToString:K_INPUT_SELECT]) {
        NSError *error = nil;
        // 多选
        if (_mutiAble) {
            NSString *valueStr = @"";
            _mutipleValue = (NSMutableArray<DicMo *><DicMo,Optional> *)[DicMo arrayOfModelsFromDictionaries:value error:&error];
            for (int i = 0; i < _mutipleValue.count; i++) {
                DicMo *tmpMo = _mutipleValue[i];
                valueStr = [valueStr stringByAppendingString:STRING(tmpMo.value)];
                if (i < _mutipleValue.count - 1) {
                    valueStr = [valueStr stringByAppendingString:@","];
                }
            }
            _strValue = valueStr;
        } else {
            // 单选
            _singleValue = (DicMo<DicMo,Optional> *)[[DicMo alloc] initWithDictionary:value error:&error];
            _strValue = _singleValue.value;
        }
    } else if ([_rowType isEqualToString:K_DATE_SELECT]) {
        if ([value isKindOfClass:[NSString class]]) {
            _strValue = (NSString *)(STRING(value));
        } else {
            _strValue = [NSString stringWithFormat:@"%@", value];
        }
    } else if ([_rowType isEqualToString:K_FILE_INPUT]) {
        NSError *error = nil;
        _attachments = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)[QiniuFileMo arrayOfModelsFromDictionaries:value error:&error];
    } else if ([_rowType isEqualToString:K_INPUT_MEMBER]) {
        NSError *error = nil;
        _member = [[CustomerMo alloc] initWithDictionary:value error:&error];
        _strValue = _member.orgName;
    } else if ([_rowType isEqualToString:K_INPUT_PRODUCT_TYPE]) {
        NSError *error = nil;
        // 多选
        if (_mutiAble) {
            NSString *valueStr = @"";
            _m_objs = [MaterialMo arrayOfModelsFromDictionaries:value error:&error];
            for (int i = 0; i < _m_objs.count; i++) {
                MaterialMo *tmpMo = _m_objs[i];
                valueStr = [valueStr stringByAppendingString:STRING(tmpMo.name)];
                if (i < _m_objs.count - 1) {
                    valueStr = [valueStr stringByAppendingString:@","];
                }
            }
            _strValue = valueStr;
        } else {
            // 单选
            _m_obj = [[MaterialMo alloc] initWithDictionary:value error:&error];
            _strValue = ((MaterialMo *)_m_obj).name;
        }
    } else if ([_rowType isEqualToString:K_INPUT_DEPARTMENT]) {
        NSError *error = nil;
        _m_obj = [[DepartmentMo alloc] initWithDictionary:value error:&error];
        _strValue = ((DepartmentMo *)_m_obj).name;
    } else if ([_rowType isEqualToString:K_INPUT_RADIO]) {
        _strValue = _defaultValue ? STRING(_trueDesp) : STRING(_falseDesp);
    // 操作员
    } else if ([_rowType isEqualToString:K_INPUT_OPERATOR]) {
        NSError *error = nil;
        _m_obj = [[JYUserMo alloc] initWithDictionary:value error:&error];
        _strValue = ((JYUserMo *)_m_obj).name;
    }
    // 品牌
    else if ([_rowType isEqualToString:K_INPUT_BRAND_SELECT]) {
//        NSError *error = nil;
//        _m_obj = [[JYUserMo alloc] initWithDictionary:value error:&error];
//        _strValue = ((JYUserMo *)_m_obj).name;
    }
    else if ([_rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
        _defaultValue = [value boolValue];
    }
    else if ([_rowType isEqualToString:K_INPUT_LINK]) {
        
    }
    else {
        _strValue = (NSString *)(STRING(value));
    }
}

- (CGFloat)rowHeight {
    if (_rowHeight > 10) {
        return _rowHeight;
    }
    if ([_rowType isEqualToString:K_INPUT_TEXT]) {
        if ([_inputType isEqualToString:K_SHORT_TEXT]) {
            _rowHeight = 45.0;
        } else if ([_inputType isEqualToString:K_LONG_TEXT]) {
            _rowHeight = 110.0;
        } else if ([_inputType isEqualToString:K_NUMBER_A_TEXT]) {
            _rowHeight = 45.0;
        } else if ([_inputType isEqualToString:K_PHONE_TEXT]) {
            _rowHeight = 45.0;
        } else if ([_inputType isEqualToString:K_EMAIL_TEXT]) {
            _rowHeight = 45.0;
        } else {
            _rowHeight = 45.0;
        }
    } else if ([_rowType isEqualToString:K_INPUT_SELECT]) {
        _rowHeight = 45.0;
    } else if ([_rowType isEqualToString:K_DATE_SELECT]) {
        _rowHeight = 45.0;
    } else if ([_rowType isEqualToString:K_FILE_INPUT]) {
        _rowHeight = 120.0;
    } else if ([_rowType isEqualToString:K_INPUT_MEMBER]) {
        _rowHeight = 45.0;
    } else if ([_rowType isEqualToString:K_INPUT_TOGGLEBUTTON]) {
        _rowHeight = 45.0;
    } else if ([_rowType isEqualToString:K_INPUT_BUTTON]) {
        _rowHeight = 100.0;
    }  else if ([_rowType isEqualToString:K_INPUT_BRAND_SELECT]) {
        _rowHeight = 45.0;
    }  else {
        _rowHeight = 45.0;
    }
    return _rowHeight;
}

- (void)setKeyBoardType:(NSString *)keyBoardType {
    _keyBoardType = keyBoardType;
    if ([_keyBoardType isEqualToString:K_DEFAULT]) {
        _iosKeyBoardType = UIKeyboardTypeDefault;
    } else if ([_keyBoardType isEqualToString:K_INTEGER]) {
        _iosKeyBoardType = UIKeyboardTypeNumberPad;
    } else if ([_keyBoardType isEqualToString:K_DOUBLE]) {
        _iosKeyBoardType = UIKeyboardTypeDecimalPad;
    }
}

//- (void)setAttachments:(NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)attachments {
//    NSError *error = nil;
//    _attachments = (NSMutableArray<QiniuFileMo *><QiniuFileMo,Optional> *)[QiniuFileMo arrayOfModelsFromDictionaries:attachments error:&error];
//}

@end
