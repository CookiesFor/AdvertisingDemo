//
//  AppDelegate.m
//  advertisingDemo
//
//  Created by SIMPLE PLAN on 2017/2/17.
//  Copyright © 2017年 SIMPLE PLAN. All rights reserved.
//

#import "AppDelegate.h"
#import "XHLaunchAd.h"
#import "AdvertisingViewController.h"
#import "GWebViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [self startPage];
    
    
    return YES;
}

/**
 *  启动页广告
 */
-(void)startPage
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        //launchAd.noDataDuration = 4;
        
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            
            /**
             *  2.设置广告数据
             */
            
            //定义一个weakLaunchAd
            __weak __typeof(launchAd) weakLaunchAd = launchAd;
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                //weakLaunchAd.adFrame = ...;
                
            } click:^{
                
                //1.用浏览器打开
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                
                //2.在webview中打开
                GWebViewController *VC = [[GWebViewController alloc] init];
                VC.URLString = openUrl;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
                
                [weakLaunchAd.navigationController presentViewController:nav animated:YES completion:nil];
                
            }];
            
        }];
        
    } showFinish:^{
        
        //广告展示完成回调,设置window根控制器
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[AdvertisingViewController alloc]init]];
        
        self.window.rootViewController = nav;
        
      
        
    }];
}

/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    if(imageData)
    {
        //设置广告图片，展示时间，跳转链接
        imageData(@"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg",3,@"http://www.baidu.com");
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
}


@end
