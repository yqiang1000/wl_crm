//
//  AddressPickerView.m
//  Wangli
//
//  Created by yeqiang on 2018/5/21.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "AddressPickerView.h"
#import <ActionSheetPicker_3_0/ActionSheetCustomPicker.h>
#import "AreaMo.h"

typedef void(^ItemClickBlock)(NSArray *arrResult);
typedef void(^CancelClickBlock)(AddressPickerView *obj);

@interface AddressPickerView () <ActionSheetCustomPickerDelegate>

@property (nonatomic,strong) ActionSheetCustomPicker *picker; // 选择器
@property (nonatomic,strong) NSMutableArray <ProvinceMo *> *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSMutableArray *provinceArr; // 省
@property (nonatomic,strong) NSMutableArray *countryArr; // 市
@property (nonatomic,strong) NSMutableArray *districtArr; // 区

@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标


@property (nonatomic, strong) NSArray *arrDefault;

@property (nonatomic, copy) ItemClickBlock itemClick;
@property (nonatomic, copy) CancelClickBlock cancelClick;

@end

@implementation AddressPickerView

- (instancetype)initWithDefaultItem:(NSArray *)arrDefault
                          itemClick:(void (^)(NSArray *arrResult))itemClick
                        cancelClick:(void (^)(AddressPickerView *obj))cancelClick {
    self = [super init];
    if (self) {
        _arrDefault = arrDefault;
        _itemClick = itemClick;
        _cancelClick = cancelClick;
        [self config];
        [self setUI];
    }
    return self;
}

- (void)config {
    // 拿出省的数组
    [self loadFirstData];
    [self calculateFirstData];
}

- (void)setUI {
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
    
    self.picker.tapDismissAction  = TapActionCancel;
    // 可以自定义左边和右边的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_B1 forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 setTitleColor:COLOR_1893D5 forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    [self.picker showActionSheetPicker];
}

// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    // 省
    ProvinceMo *provinceMo = self.addressArr[self.index1];
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    
    for (CityMo *cityMo in provinceMo.citylist) {
        [cityNameArr addObject:STRING(cityMo.cityName)];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
    // 市
    CityMo *cityMo = provinceMo.citylist[self.index2];
    NSMutableArray *areaNameArr = [NSMutableArray new];
    for (AreaMo *areaMo in cityMo.arealist) {
        [areaNameArr addObject:areaMo.areaName];
    }
    self.districtArr = areaNameArr;
}

- (void)loadFirstData
{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:path];
    self.addressArr = [ProvinceMo arrayOfModelsFromDictionaries:arr error:nil];
    NSMutableArray *provinceNameArr = [NSMutableArray new];
    // 第一层是省份 分解出整个省份数组
    for (ProvinceMo *provinceMo in self.addressArr)
    {
        [provinceNameArr addObject:STRING(provinceMo.provinceName)];
    }
    self.provinceArr = provinceNameArr;
    
    __block NSInteger index11 = 0;
    __block NSInteger index22 = 0;
    __block NSInteger index33 = 0;
    
    [self.addressArr enumerateObjectsUsingBlock:^(ProvinceMo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:_arrDefault[0]]) {
            index11 = idx;
            [obj.citylist enumerateObjectsUsingBlock:^(CityMo * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
                if ([obj.id isEqualToString:_arrDefault[1]]) {
                    index22 = idx1;
                    [obj.arealist enumerateObjectsUsingBlock:^(AreaMo * _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
                        if ([obj.id isEqualToString:_arrDefault[2]]) {
                            index33 = idx2;
                            *stop = YES;
                        }
                    }];
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    _index1 = index11;
    _index2 = index22;
    _index3 = index33;
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        case 2: return self.districtArr.count;
        default:break;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate Implementation

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component)
//    {
//        case 0: return SCREEN_WIDTH /4;
//        case 1: return SCREEN_WIDTH *3/8;
//        case 2: return SCREEN_WIDTH *3/8;
//        default:break;
//    }
//
//    return 0;
//}

/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        case 2:return self.districtArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        case 2: title =   self.districtArr[row];break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:
        {
            self.index2 = row;
            self.index3 = 0;
            //            [self calculateData];
            [self calculateFirstData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:break;
    }
}
//
//- (void)calculateData
//{
//    [self loadFirstData];
//    NSDictionary *provincesDict = self.addressArr[self.index1];
//    NSMutableArray *countryArr1 = [[NSMutableArray alloc] init];
//    for (NSDictionary *contryDict in provincesDict.allValues.firstObject) {
//        NSString *name = contryDict.allKeys.firstObject;
//        [countryArr1 addObject:name];
//    }
//    self.countryArr = countryArr1;
//
//    self.districtArr = [provincesDict.allValues.firstObject[self.index2] allValues].firstObject;
//
//}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}

// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin {
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    NSMutableArray *arrIds = [NSMutableArray new];
    NSMutableArray *arrNames = [NSMutableArray new];
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        [detailAddress appendString:firstAddress];
        
        NSString *ids = self.addressArr[_index1].id;
        [arrIds addObject:STRING(ids)];
        [arrNames addObject:firstAddress];
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        [detailAddress appendString:secondAddress];
        
        NSString *ids = self.addressArr[_index1].citylist[_index2].id;
        [arrIds addObject:STRING(ids)];
        [arrNames addObject:secondAddress];
    }
    if (self.index3 < self.districtArr.count) {
        NSString *thirfAddress = self.districtArr[self.index3];
        [detailAddress appendString:thirfAddress];
        
        NSString *ids = self.addressArr[_index1].citylist[_index2].arealist[_index3].id;
        [arrIds addObject:STRING(ids)];
        [arrNames addObject:thirfAddress];
    }
    
    if (self.itemClick) {
        self.itemClick(@[arrIds, arrNames, detailAddress]);
    }
    if (self.cancelClick) {
        self.cancelClick(self);
    }
}

- (void)actionSheetPickerDidCancel:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin {
    if (self.cancelClick) {
        self.cancelClick(self);
    }
}

- (NSMutableArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSMutableArray alloc] init];
    }
    return _provinceArr;
}

-(NSMutableArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSMutableArray alloc] init];
    }
    return _countryArr;
}

- (NSMutableArray *)districtArr
{
    if (_districtArr == nil) {
        _districtArr = [[NSMutableArray alloc] init];
    }
    return _districtArr;
}

- (NSMutableArray<ProvinceMo *> *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSMutableArray alloc] init];
    }
    return _addressArr;
}

@end
