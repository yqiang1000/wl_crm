//
//  SapInvoiceViewCtrl.m
//  Wangli
//
//  Created by yeqiang on 2018/6/15.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "SapInvoiceViewCtrl.h"
#import "TrackDetailView.h"
#import "QiNiuUploadHelper.h"
#import "SapInvoiceMo.h"
#import "BillingMo.h"
#import "ReceiptMo.h"
#import "MonthyStatementMo.h"

@interface SapInvoiceViewCtrl ()

@property (nonatomic, strong) TrackDetailView *trackDetailView;

@end

@implementation SapInvoiceViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.trackDetailView.mo = self.mo;
    [self.trackDetailView refreshView];
    NSLog(@"%lu", (unsigned long)_type);
}

- (void)setUI {
    [self.view addSubview:self.trackDetailView];
    [self.trackDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark - event

- (void)clickRightButton:(UIButton *)sender {
    
    AttachmentCell *cell = [self.trackDetailView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.collectionView.attachments.count > 0) {
        // 上传图片
        QiNiuUploadHelper *helper = [[QiNiuUploadHelper alloc] init];
        [helper uploadImages:cell.collectionView.attachments success:^(id responseObject) {
            [self addImages:[Utils filterUrls:responseObject arrFile:_mo.attachments]];
        } failure:^(NSError *error) {
            [Utils dismissHUD];
            [Utils showToastMessage:STRING(error.userInfo[@"message"])];
        }];
    } else {
        // 新建
        [self addImages:@[]];
    }
}

- (void)addImages:(NSArray *)images {
    [Utils showHUDWithStatus:nil];
    if (_type == kSapInvoiceType) {
        [self sapInvoiceAdd:images];
    } else if (_type == kBillingType) {
        [self billingAdd:images];
    } else if (_type == kReceiptType) {
        [self receiptTAdd:images];
    } else if (_type == kMonthyStatement) {
        [self monthyStatementAdd:images];
    }
}

- (void)sapInvoiceAdd:(NSArray *)attachments {
    [[JYUserApi sharedInstance] addSapInvoiceAttachmentListById:_modelId attachmentList:attachments success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)billingAdd:(NSArray *)attachments {
    [[JYUserApi sharedInstance] addSalesBillingAttachmentListById:_modelId attachmentList:attachments success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)receiptTAdd:(NSArray *)attachments {
    [[JYUserApi sharedInstance] addReceiptAttachmentListById:_modelId attachmentList:attachments success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

- (void)monthyStatementAdd:(NSArray *)attachments {
    [[JYUserApi sharedInstance] addMonthyStatementAttachmentListById:_modelId attachmentList:attachments success:^(id responseObject) {
        [Utils dismissHUD];
        [Utils showToastMessage:@"保存成功"];
    } failure:^(NSError *error) {
        [Utils dismissHUD];
        [Utils showToastMessage:STRING(error.userInfo[@"message"])];
    }];
}

#pragma mark - setter getter

- (TrackDetailView *)trackDetailView {
    if (!_trackDetailView) {
        _trackDetailView = [[TrackDetailView alloc] initWithFrame:CGRectZero];
        _trackDetailView.layer.cornerRadius = 5;
        _trackDetailView.clipsToBounds = YES;
        _trackDetailView.backgroundColor = COLOR_B4;
        if (_type == kSapInvoiceType || _type == kBillingType || _type == kReceiptType || _type == kMonthyStatement) {
            _trackDetailView.showAttachments = YES;
        } else {
            _trackDetailView.showAttachments = NO;
        }
        __weak typeof(self) weakself = self;
        _trackDetailView.countChange = ^(NSInteger x) {
            weakself.rightBtn.hidden = NO;
        };
    }
    return _trackDetailView;
}

@end
