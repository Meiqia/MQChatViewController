//
//  MQAgent.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/23.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQAgent : NSObject

/** 客服id */
@property (nonatomic, copy  ) NSString * agentId;

/** 客服昵称 */
@property (nonatomic, copy  ) NSString * nickname;

/** 权限 */
@property (nonatomic, copy  ) NSString * privilege;

/** 头像的URL */
@property (nonatomic, copy  ) NSString * avatarPath;

/** 公开的手机号 */
@property (nonatomic, copy  ) NSString * publicCellphone;

/** 个人手机号 */
@property (nonatomic, copy  ) NSString * cellphone;

/** 座机号 */
@property (nonatomic, copy  ) NSString * telephone;

/** 邮箱 */
@property (nonatomic, copy  ) NSString * publicEmail;

/** 状态 */
@property (nonatomic, copy  ) NSString * status;

/** 个人签名 */
@property (nonatomic, copy  ) NSString * signature;

/** 是否在线 */
@property (nonatomic, assign) BOOL     * isOnline;

@end
