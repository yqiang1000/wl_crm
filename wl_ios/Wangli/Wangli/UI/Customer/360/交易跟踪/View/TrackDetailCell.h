//
//  TrackDetailCell.h
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusInfoMo.h"

@interface TrackDetailCell : UITableViewCell

@property (nonatomic, strong) CusInfoDetailMo *mo;

- (void)loadData:(CusInfoDetailMo *)mo;

@end
