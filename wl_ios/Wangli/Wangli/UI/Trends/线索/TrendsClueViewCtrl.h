//
//  TrendsClueViewCtrl.h
//  Wangli
//
//  Created by yeqiang on 2018/12/25.
//  Copyright © 2018年 jiuyisoft. All rights reserved.
//

#import "TrendsBaseViewCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendsClueViewCtrl : TrendsBaseViewCtrl

@end

/** * 线索编号 / private String clueNumber; /* * 线索标题 / @JyNotEmpty(message = "线索标题不能为空") private String title; /* * 线索来源value / private String resourceValue; /* * 线索来源key / @JyNotEmpty(message = "线索来源不能为空") private String resourceKey; /* * 关联活动 / private MarketActivity marketActivity; /* * 活动标题 / private String marketActivityTitle; /* * 关联情报明细 / private IntelligenceItem intelligenceItem; /* * 情报内容 / private String intelligenceContent; /* * 相关老客户介绍 / private Member oldMember; /* * 相关老客户名称 / private Member oldMemberAbbreviation; /* * 客户 / private Member member; /* * 客户简称 / private String abbreviation; /* * 客户联系人 / @JyNotEmpty(message = "客户联系人不能为空") private String memberContactor; /* * 客户联系电话 / @JyNotEmpty(message = "客户联系电话不能为空") private String memberContactorPhone; /* * 提交人 / private Operator submitter; /* * 提交人姓名 / private String submitterName; /* * 负责人 / private Operator principal; /* * 负责人姓名 / private String principalName; /* * 重要程度value / private String importantValue; /* * 重要程度key / @JyNotEmpty(message = "重要程度不能为空") private String importantKey; /* * 状态value / private String statusValue; /* * 状态key / @JyNotEmpty(message = "状态不能为空") private String statusKey; /* * 审批状态 / private String ApprovalStatusDesp; /* * 审批状态 / private String approvalStatus; /* * 审批状态描述 / private String statusDesp; /* * 审批节点标识 / private String approvalNodeIdentifier; /* * 提交日期 / @JyNotEmpty(message = "提交日期不能为空") private Date submitDate; /* * 反馈 / private String coupleBack; /* * 关闭线索说明 / private String closeDesp; /* * 线索内容 / @JyNotEmpty(message = "线索内容不能为空") private String content; /* * 附件 / private List attachments; /* * 产品大类 */ // private Set productBigCategories;


NS_ASSUME_NONNULL_END
