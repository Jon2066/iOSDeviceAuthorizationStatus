//
//  XCLDeviceAuthorization.h
//  XCLToolDemo
//
//  Created by Jonathan on 2018/7/21.
//  Copyright © 2018年 Jonathan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XCLDeviceAuthorizationState){
    XCLDeviceAuthorizationStateUnknow     = -2, ///< 
    XCLDeviceAuthorizationStateUnset      = -1, ///< 还没有询问过是否授权
    XCLDeviceAuthorizationStateRejected   =  0, ///< 授权被拒绝
    XCLDeviceAuthorizationStateAuthorized =  1, ///< 已授权
};

typedef NS_ENUM(NSUInteger, XCLDeviceUsage){
    XCLDeviceUsagePhotoLibrary      = 1,    ///< 相册
    XCLDeviceUsageCamera            = 1<<1, ///< 相机
    XCLDeviceUsageMicrophone        = 1<<2, ///< 麦克风
    XCLDeviceUsageLocationWhenInUse = 1<<3, ///< 位置app运行期间访问
    XCLDeviceUsageLocationAlways    = 1<<4, ///< 位置始终访问和期间访问
    XCLDeviceUsageContacts          = 1<<5, ///< 通讯录
//    XCLDeviceUsageBluetooth         = 1<<6, ///< 蓝牙
//    XCLDeviceUsagePushNotification  = 1<<7, ///< 推送
//    XCLDeviceUsageCalendars         = 1<<8, ///< 日历
//    XCLDeviceUsageReminders         = 1<<9, ///< 提醒事项
//    XCLDeviceUsageMotion            = 1<<10, ///< 运动数据
};

@interface XCLDeviceAuthorization : NSObject

/**
 单个授权查询

 @param usage XCLDeviceUsage
 @return XCLDeviceAuthorizationState
 */
+ (XCLDeviceAuthorizationState)authorizedWithUsage:(XCLDeviceUsage)usage;


/**
 多个授权一起查询
 
 @param usages XCLDeviceUsage|XCLDeviceUsage
 @return 只要有一个没授权则返回NO 都授权返回YES
 */
+ (BOOL)multiUsagesAuthorized:(XCLDeviceUsage)usages;



/**
 去设置页面
 */
+ (BOOL)openSetting;


/**
 请求授权

 @param usage 授权对象
 @param completion 完成状态返回
 */
+ (void)requestAuthorizeWithUsage:(XCLDeviceUsage)usage
                  completionBlock:(void(^)(XCLDeviceAuthorizationState state))completion;
@end
