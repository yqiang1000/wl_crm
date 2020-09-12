//
//  CreateQuoteDetailViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/1/15.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "CommonAutoViewCtrl.h"
#import "TrendsQuoteMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateQuoteDetailViewCtrl : CommonAutoViewCtrl

@property (nonatomic, strong) TrendsQuoteDetailMo *detailMo;

@end

///**
// * 报价单
// */
//private QuotedPrice quotedPrice;
///**
// * 产品大类
// */
//private MaterialType materialType;
///**
// *档位
// */
//@JyNotEmpty(message = "档位不能为空")
//private String gears;
///**
// *报价数量
// */
//@JyNotEmpty(message = "报价数量不能为空")
//@JyMin(value = 0, message = "报价数量不能为负值")
//private BigDecimal quantity;
///**
// * 报价单位value(W、pc默认w)
// */
//@JyNotEmpty(message = "报价单位不能为空")
//private String unitValue;
///**
// * 报价单位key(W、pc默认w)
// */
//private String unitKey;
///**
// *单价
// */
//@JyNotEmpty(message = "单价不能为空")
//@JyMin(value = 0, message = "单价不能为负值")
//private BigDecimal price;
///**
// *小计
// */
//@JyNotEmpty(message = "小计不能为空")
//@JyMin(value = 0, message = "小计不能为负值")
//private BigDecimal totalPrice;
///**
// *备注
// */
//private String remark;

NS_ASSUME_NONNULL_END
