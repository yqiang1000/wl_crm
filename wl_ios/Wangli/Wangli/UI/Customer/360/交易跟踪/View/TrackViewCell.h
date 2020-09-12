//
//  TrackViewCell.h
//  Wangli
//
//  Created by yeqiang on 2018/6/8.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger potion;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSString *title;

// type :0 底部有间距; 1 底部没有边距
// cornerType 0:无圆角。1:上两角 2:下边两角 3:四圆角
- (void)loadData:(NSDictionary *)dicData type:(NSInteger)type cornerType:(NSInteger)cornerType hidenTitle:(BOOL)hidenTitle;

@end
