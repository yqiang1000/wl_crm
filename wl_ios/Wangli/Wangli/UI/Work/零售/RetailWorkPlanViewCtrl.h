//
//  RetailWorkPlanViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2019/4/17.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "RetailChannelMo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RetailWorkPlanViewCtrl : BaseViewCtrl

@property (nonatomic, strong) RetailChannelMo *model;

//CommonRowMo *rowMo0 = [[CommonRowMo alloc] init];
//rowMo0.rowType = K_INPUT_OPERATOR;
//rowMo0.leftContent = @"业务员";
//rowMo0.inputType = K_SHORT_TEXT;
//rowMo0.rightContent = @"请选择";
//rowMo0.editAble = YES;
//rowMo0.key = @"operator";
//NSError *error = nil;
//if (self.model) {
//    JYUserMo *userMo = [[JYUserMo alloc] initWithDictionary:self.model.operator error:&error];
//    rowMo0.m_obj = userMo;
//    rowMo0.strValue = self.model.operator[@"name"];
//}
//[self.arrData addObject:rowMo0];
//
//CommonRowMo *rowMoPro = [[CommonRowMo alloc] init];
//rowMoPro.rowType = K_INPUT_TEXT;
//rowMoPro.leftContent = @"省份";
//rowMoPro.inputType = K_SHORT_TEXT;
//rowMoPro.rightContent = @"请选择";
//rowMoPro.editAble = YES;
//rowMoPro.key = @"province";
//if (self.model) rowMoPro.strValue = STRING(self.model.province);
//[self.arrData addObject:rowMoPro];
//
//CommonRowMo *rowMo1 = [[CommonRowMo alloc] init];
//rowMo1.rowType = K_INPUT_TEXT;
//rowMo1.leftContent = @"当月销售目标";
//rowMo1.inputType = K_SHORT_TEXT;
//rowMo1.rightContent = @"自动带出";
//rowMo1.editAble = NO;
//rowMo1.key = @"salesTarget";
//if (self.model.salesTarget > 0) {
//    rowMo1.strValue = [Utils getPriceFrom:_model.salesTarget];
//    rowMo1.m_obj = [Utils getPriceFrom:_model.salesTarget];
//    rowMo1.value = [Utils getPriceFrom:_model.salesTarget];
//}
//[self.arrData addObject:rowMo1];
//
//CommonRowMo *rowMo2 = [[CommonRowMo alloc] init];
//rowMo2.rowType = K_INPUT_TEXT;
//rowMo2.leftContent = @"当月累计发货量";
//rowMo2.inputType = K_SHORT_TEXT;
//rowMo2.rightContent = @"自动带出";
//rowMo2.editAble = NO;
//rowMo2.key = @"cumulativeShipments";
//if (self.model.cumulativeShipments > 0) {
//    rowMo2.strValue = [Utils getPriceFrom:_model.cumulativeShipments];
//    rowMo2.m_obj = [Utils getPriceFrom:_model.cumulativeShipments];
//    rowMo2.value = [Utils getPriceFrom:_model.cumulativeShipments];
//}
//[self.arrData addObject:rowMo2];
//
//CommonRowMo *rowMo3 = [[CommonRowMo alloc] init];
//rowMo3.rowType = K_INPUT_TEXT;
//rowMo3.leftContent = @"当日预计发货量";
//rowMo3.inputType = K_SHORT_TEXT;
//rowMo3.rightContent = @"请输入";
//rowMo3.editAble = YES;
//rowMo3.nullAble = YES;
//rowMo3.keyBoardType = K_DOUBLE;
//rowMo3.key = @"projectedShipment";
//if (self.model.projectedShipment > 0) {
//    rowMo3.strValue = [Utils getPriceFrom:self.model.projectedShipment];
//    rowMo3.m_obj = [Utils getPriceFrom:self.model.projectedShipment];
//    rowMo3.value = [Utils getPriceFrom:self.model.projectedShipment];
//}
//[self.arrData addObject:rowMo3];
//
//CommonRowMo *rowMo4 = [[CommonRowMo alloc] init];
//rowMo4.rowType = K_INPUT_TEXT;
//rowMo4.leftContent = @"当日实际发货量";
//rowMo4.inputType = K_SHORT_TEXT;
//rowMo4.rightContent = @"请输入";
//rowMo4.editAble = YES;
//rowMo4.nullAble = YES;
//rowMo4.keyBoardType = K_DOUBLE;
//rowMo4.key = @"actualShipment";
//if (self.model.actualShipment > 0) {
//    rowMo4.strValue = [Utils getPriceFrom:self.model.actualShipment];
//    rowMo4.m_obj = [Utils getPriceFrom:self.model.actualShipment];
//    rowMo4.value = [Utils getPriceFrom:self.model.actualShipment];
//}
//[self.arrData addObject:rowMo4];
//
//CommonRowMo *rowMo5 = [[CommonRowMo alloc] init];
//rowMo5.rowType = K_INPUT_TEXT;
//rowMo5.leftContent = @"月目标完成率(%)";
//rowMo5.inputType = K_SHORT_TEXT;
//rowMo5.rightContent = @"自动计算";
//rowMo5.editAble = NO;
//rowMo5.key = @"ompletionRate";
//if (self.model) {
//    rowMo5.strValue = [Utils getPriceFrom:self.model.ompletionRate];
//    rowMo5.m_obj = [Utils getPriceFrom:self.model.ompletionRate];
//    rowMo5.value = [Utils getPriceFrom:self.model.ompletionRate];
//}
//[self.arrData addObject:rowMo5];
//
//CommonRowMo *rowMo6 = [[CommonRowMo alloc] init];
//rowMo6.rowType = K_INPUT_TEXT;
//rowMo6.leftContent = @"走访市场";
//rowMo6.inputType = K_SHORT_TEXT;
//rowMo6.rightContent = @"请选择";
//rowMo6.editAble = YES;
//rowMo6.nullAble = YES;
//rowMo6.key = @"address";
//if (self.model) {
//    _arrAddIds = nil;
//    _arrAddNames = nil;
//    NSString *address = @"";
//    if (self.model.provinceName.length > 0) address = [address stringByAppendingString:self.model.provinceName];
//    if (self.model.cityName.length > 0) address = [address stringByAppendingString:self.model.cityName];
//    if (self.model.areaName.length > 0) address = [address stringByAppendingString:self.model.areaName];
//    rowMo6.strValue = STRING(address);
//}
//[self.arrData addObject:rowMo6];
//
//CommonRowMo *rowMo7 = [[CommonRowMo alloc] init];
//rowMo7.rowType = K_INPUT_TEXT;
//rowMo7.leftContent = @"预计走访客户";
//rowMo7.inputType = K_SHORT_TEXT;
//rowMo7.rightContent = @"自动带出";
//rowMo7.editAble = NO;
//rowMo7.key = @"expectVisit";
//if (self.model.expectVisit > 0) {
//    rowMo7.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.expectVisit];
//    rowMo7.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.expectVisit];
//    rowMo7.value = [NSString stringWithFormat:@"%ld", (long)self.model.expectVisit];
//}
//[self.arrData addObject:rowMo7];
//
//CommonRowMo *rowMo8 = [[CommonRowMo alloc] init];
//rowMo8.rowType = K_INPUT_TEXT;
//rowMo8.leftContent = @"实际走访客户";
//rowMo8.inputType = K_SHORT_TEXT;
//rowMo8.rightContent = @"自动带出";
//rowMo8.editAble = NO;
//rowMo8.key = @"actualVisit";
//if (self.model.actualVisit > 0) {
//    rowMo8.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.actualVisit];
//    rowMo8.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.actualVisit];
//    rowMo8.value = [NSString stringWithFormat:@"%ld", (long)self.model.actualVisit];
//}
//[self.arrData addObject:rowMo8];
//
//CommonRowMo *rowMo9 = [[CommonRowMo alloc] init];
//rowMo9.rowType = K_INPUT_TEXT;
//rowMo9.leftContent = @"售后未处理事项";
//rowMo9.inputType = K_SHORT_TEXT;
//rowMo9.rightContent = @"请输入";
//rowMo9.editAble = YES;
//rowMo9.nullAble = YES;
//rowMo9.key = @"afterSaleUnprocessed";
//rowMo9.strValue = self.model.afterSaleUnprocessed;
//[self.arrData addObject:rowMo9];
//
//CommonRowMo *rowMo10 = [[CommonRowMo alloc] init];
//rowMo10.rowType = K_INPUT_TEXT;
//rowMo10.leftContent = @"活动";
//rowMo10.inputType = K_SHORT_TEXT;
//rowMo10.rightContent = @"请输入";
//rowMo10.editAble = YES;
//rowMo10.nullAble = YES;
//rowMo10.key = @"activity";
//rowMo10.strValue = self.model.activity;
//[self.arrData addObject:rowMo10];
//
//CommonRowMo *rowMo11 = [[CommonRowMo alloc] init];
//rowMo11.rowType = K_INPUT_TOGGLEBUTTON;
//rowMo11.leftContent = @"活动是否完成";
////    rowMo11.inputType = K_SHORT_TEXT;
//rowMo11.rightContent = @"请选择";
//rowMo11.editAble = self.isUpdate;
//rowMo11.defaultValue = self.model.finish;
//rowMo11.strValue = self.model.finish ? @"YES" : @"NO";
//rowMo11.key = @"finish";
//[self.arrData addObject:rowMo11];
//
//CommonRowMo *rowMoPro1 = [[CommonRowMo alloc] init];
//rowMoPro1.rowType = K_INPUT_TEXT;
//rowMoPro1.leftContent = @"省份";
//rowMoPro1.inputType = K_SHORT_TEXT;
//rowMoPro1.rightContent = @"请选择";
//rowMoPro1.editAble = YES;
//rowMoPro1.key = @"developmentProvince";
//if (self.model) rowMoPro1.strValue = STRING(self.model.developmentProvince);
//[self.arrData addObject:rowMoPro1];
//
//CommonRowMo *rowMo12 = [[CommonRowMo alloc] init];
//rowMo12.rowType = K_INPUT_TEXT;
//rowMo12.leftContent = @"当月开发目标";
//rowMo12.inputType = K_SHORT_TEXT;
//rowMo12.rightContent = @"自动带出";
//rowMo12.editAble = NO;
//rowMo12.key = @"developmentProject";
//if (self.model.developmentProject > 0) {
//    rowMo12.strValue = [Utils getPriceFrom:self.model.developmentProject];
//    rowMo12.m_obj = [Utils getPriceFrom:self.model.developmentProject];
//    rowMo12.value = [Utils getPriceFrom:self.model.developmentProject];
//}
//[self.arrData addObject:rowMo12];
//
//CommonRowMo *rowMo121 = [[CommonRowMo alloc] init];
//rowMo121.rowType = K_INPUT_TEXT;
//rowMo121.leftContent = @"当月累计拜访";
//rowMo121.inputType = K_SHORT_TEXT;
//rowMo121.rightContent = @"自动带出";
//rowMo121.editAble = NO;
//rowMo121.key = @"accumulateVisit";
//if (self.model.accumulateVisit > 0) {
//    rowMo121.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.accumulateVisit];
//    rowMo121.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.accumulateVisit];
//    rowMo121.value = [NSString stringWithFormat:@"%ld", (long)self.model.accumulateVisit];
//}
//[self.arrData addObject:rowMo121];
//
//CommonRowMo *rowMo13 = [[CommonRowMo alloc] init];
//rowMo13.rowType = K_INPUT_TEXT;
//rowMo13.leftContent = @"当日拜访意向客户";
//rowMo13.inputType = K_SHORT_TEXT;
//rowMo13.rightContent = @"自动带出";
//rowMo13.editAble = NO;
//rowMo13.key = @"visitIntentional";
//if (self.model.visitIntentional > 0) {
//    rowMo13.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.visitIntentional];
//    rowMo13.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.visitIntentional];
//    rowMo13.value = [NSString stringWithFormat:@"%ld", (long)self.model.visitIntentional];
//}
//[self.arrData addObject:rowMo13];
//
//CommonRowMo *rowMo14 = [[CommonRowMo alloc] init];
//rowMo14.rowType = K_INPUT_TEXT;
//rowMo14.leftContent = @"当日完成拜访";
//rowMo14.inputType = K_SHORT_TEXT;
//rowMo14.rightContent = @"自动带出";
//rowMo14.editAble = NO;
//rowMo14.key = @"finishVisit";
//if (self.model.finishVisit > 0) {
//    rowMo14.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.finishVisit];
//    rowMo14.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.finishVisit];
//    rowMo14.value = [NSString stringWithFormat:@"%ld", (long)self.model.finishVisit];
//}
//[self.arrData addObject:rowMo14];
//
//CommonRowMo *rowMo15 = [[CommonRowMo alloc] init];
//rowMo15.rowType = K_INPUT_TEXT;
//rowMo15.leftContent = @"月目标完成率(%)";
//rowMo15.inputType = K_SHORT_TEXT;
//rowMo15.rightContent = @"自动计算";
//rowMo15.editAble = NO;
//rowMo15.key = @"completionRate";
//if (self.model) {
//    rowMo15.strValue = [Utils getPriceFrom:self.model.completionRate];
//    rowMo15.m_obj = [Utils getPriceFrom:self.model.completionRate];
//    rowMo15.value = [Utils getPriceFrom:self.model.completionRate];
//}
//[self.arrData addObject:rowMo15];
//
//CommonRowMo *rowMo16 = [[CommonRowMo alloc] init];
//rowMo16.rowType = K_INPUT_TEXT;
//rowMo16.leftContent = @"报备工程跟进";
//rowMo16.inputType = K_SHORT_TEXT;
//rowMo16.rightContent = @"请输入";
//rowMo16.editAble = YES;
//rowMo16.nullAble = YES;
//rowMo16.key = @"followUpReportingProject";
//if (self.model.followUpReportingProject > 0) {
//    rowMo16.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.followUpReportingProject];
//    rowMo16.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.followUpReportingProject];
//    rowMo16.value = [NSString stringWithFormat:@"%ld", (long)self.model.followUpReportingProject];
//}
//[self.arrData addObject:rowMo16];
//
//CommonRowMo *rowMo17 = [[CommonRowMo alloc] init];
//rowMo17.rowType = K_INPUT_TEXT;
//rowMo17.leftContent = @"未履行工程跟进";
//rowMo17.inputType = K_SHORT_TEXT;
//rowMo17.rightContent = @"请输入";
//rowMo17.editAble = YES;
//rowMo17.nullAble = YES;
//rowMo17.key = @"followUpUnfulfilledProject";
//if (self.model.followUpUnfulfilledProject > 0) {
//    rowMo17.strValue = [NSString stringWithFormat:@"%ld", (long)self.model.followUpUnfulfilledProject];
//    rowMo17.m_obj = [NSString stringWithFormat:@"%ld", (long)self.model.followUpUnfulfilledProject];
//    rowMo17.value = [NSString stringWithFormat:@"%ld", (long)self.model.followUpUnfulfilledProject];
//}
//[self.arrData addObject:rowMo17];
//
//CommonRowMo *rowMo18 = [[CommonRowMo alloc] init];
//rowMo18.rowType = K_DATE_SELECT;
//rowMo18.leftContent = @"填写日期";
//rowMo18.inputType = K_SHORT_TEXT;
//rowMo18.rightContent = @"请输入";
//rowMo18.pattern = @"yyyy-MM-dd";
//rowMo18.editAble = YES;
//rowMo18.key = @"date";
//rowMo18.strValue = self.model?self.model.date:[[NSDate date] stringWithFormat:rowMo18.pattern];
//[self.arrData addObject:rowMo18];
//
//CommonRowMo *rowMo19 = [[CommonRowMo alloc] init];
//rowMo19.rowType = K_INPUT_TEXT;
//rowMo19.leftContent = @"其他";
//rowMo19.inputType = K_SHORT_TEXT;
//rowMo19.rightContent = @"请输入";
//rowMo19.editAble = YES;
//rowMo19.nullAble = YES;
//rowMo19.key = @"remark";
//rowMo19.strValue = self.model.remark;
//[self.arrData addObject:rowMo19];

@end

NS_ASSUME_NONNULL_END
