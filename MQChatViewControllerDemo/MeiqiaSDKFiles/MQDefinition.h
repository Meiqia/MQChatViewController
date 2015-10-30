//
//  MQDefinition.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * 异常或错误。没有异常时返回-1
 */
typedef enum{
    Exception_Error_Parameter = 0,      //参数错误
    
    Exception_AppKey_Invalid,           //appkey无效
    Exception_Init_Failed,              //初始化中出现错误
    Exception_NotInitialized,           //未初始化
    
    Exception_Client_IsOffline,           //顾客为离线状态，当前操作无法操作
    
    Exception_Connection_Error,         //网络请求错误
    Exception_Agent_NotOnline,         //没有客服在线
    
    Exception_ServiceError,             //服务器出错
    Exception_UnknownError              //未知错误
}kMQExceptionStatus;