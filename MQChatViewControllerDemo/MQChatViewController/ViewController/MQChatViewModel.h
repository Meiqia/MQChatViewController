//
//  MQChatViewModel.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 聊天界面的ViewModel
 *
 * MQChatViewModel管理者MQChatViewController中的数据
 */
@interface MQChatViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *cellModels;

@end
