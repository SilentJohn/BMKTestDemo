//
//  AppDelegate.m
//  BMKTestDemo
//
//  Created by john.jiang on 2019/4/16.
//  Copyright © 2019 john.jiang. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BMKLocationKit/BMKLocationAuth.h>

static NSString * const baiduSDKKey = @"gdaTr1OgG7G242GZ5EKTgKkqCMfe6rGF";

@interface AppDelegate () <BMKGeneralDelegate, BMKLocationAuthDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [BMKLocationAuth.sharedInstance checkPermisionWithKey:baiduSDKKey authDelegate:self];
    //要使用百度地图，请先启动BMKMapManager
    _mapManager = [[BMKMapManager alloc] init];
    
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    //启动引擎并设置AK并设置delegate
    BOOL result = [_mapManager start:baiduSDKKey generalDelegate:self];
    if (!result) {
        NSLog(@"启动引擎失败");
    }
    return YES;
}

#pragma mark - BMKGeneralDelegate
/**
 联网结果回调
 
 @param iError 联网结果错误码信息，0代表联网成功
 */
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"联网失败：%d", iError);
    }
}

/**
 鉴权结果回调
 
 @param iError 鉴权结果错误码信息，0代表鉴权成功
 */
- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"地图授权成功");
    } else {
        NSLog(@"地图授权失败：%d", iError);
    }
}

#pragma mark - BMKLocationAuthDelegate

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (0 == iError) {
        NSLog(@"定位授权成功");
    } else {
        NSLog(@"定位授权失败：%zd", iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 停止引擎
    [_mapManager stop];
}


@end
