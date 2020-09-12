//
//  ServiceConsultationReplyCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/22.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceConsultationReplyCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;

- (void)loadDataName:(NSString *)name reply:(NSString *)reply time:(NSString *)time content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
