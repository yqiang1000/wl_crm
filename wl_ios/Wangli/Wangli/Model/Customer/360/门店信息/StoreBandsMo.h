//
//  StoreBandsMo.h
//  Wangli
//
//  Created by 杜文杰 on 2019/7/15.
//  Copyright © 2019 jiuyisoft. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreBandsMo : JSONModel

//@property (nonatomic, copy) NSString <Optional> *createdBy; //"guanliyuan",
//@property (nonatomic, copy) NSString <Optional> *createdDate; //"2019-04-09 14:08:12",
//@property (nonatomic, copy) NSString <Optional> *lastModifiedBy; //"guanliyuan",
//@property (nonatomic, copy) NSString <Optional> *lastModifiedDate; //"2019-04-09 14:08:17",
//@property (nonatomic, copy) NSString <Optional> *fromClientType; //null,
//@property (nonatomic, copy) NSString <Optional> *searchContent; //null,
//@property (nonatomic, copy) NSString <Optional> *deleted; //null,
//@property (nonatomic, copy) NSString <Optional> *sort; //0,
//@property (nonatomic, strong) NSMutableArray <Optional> *optionGroup; //[],
//@property (nonatomic, copy) NSString <Optional> *brandDesc; //"能诚"
@property (nonatomic, assign) NSInteger id; //4,
@property (nonatomic, copy) NSString <Optional> *brandName; //"能诚",

@end

NS_ASSUME_NONNULL_END
