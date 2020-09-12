//
//  SwitchUrlUtil.h
//  Wangli
//
//  Created by yeqiang on 2019/1/25.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchUrlUtilMo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *staticUrl;
@property (nonatomic, copy) NSString *mutableUrl;
@property (nonatomic, copy) NSString *urlKey;

+ (SwitchUrlUtilMo *)setupWithStaticUrl:(NSString *)staticUrl;

@end


@interface SwitchUrlUtil : NSObject

+ (instancetype)sharedInstance;

- (NSString *)DOMAIN_NAME;

- (NSString *)H5_URL;

- (NSString *)imgUrlWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
