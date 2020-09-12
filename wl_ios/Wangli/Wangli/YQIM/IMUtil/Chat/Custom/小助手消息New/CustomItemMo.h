//
//  CustomItemMo.h
//  Wangli
//
//  Created by yeqiang on 2020/5/27.
//  Copyright © 2020 yeqiang. All rights reserved.
//

#import "YQBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - CustomItemMo

@interface CustomItemMo : YQBaseModel

@property (nonatomic, copy) NSString *leftContent;
@property (nonatomic, copy) NSString *rightContent;
@property (nonatomic, copy) NSString *rightColor;
@property (nonatomic, copy) NSString *rightUrl;

@property (nonatomic, assign) CGFloat location;
@property (nonatomic, assign) CGFloat length;

@end

#pragma mark - ContentTextMo

@interface ContentTextMo : YQBaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) CGFloat location;
@property (nonatomic, assign) CGFloat length;

@end

#pragma mark - MoreInfoMo

@interface MoreInfoMo : YQBaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) CGFloat location;
@property (nonatomic, assign) CGFloat length;

@end

NS_ASSUME_NONNULL_END
