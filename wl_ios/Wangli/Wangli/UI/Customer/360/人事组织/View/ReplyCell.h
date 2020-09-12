//
//  ReplyCell.h
//  Wangli
//
//  Created by yeqiang on 2018/12/12.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyCell : UITableViewCell

- (void)loadData:(NSString *)reply content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
