//
//  AppDelegate.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <IQKeyboardManager.h>
#import "payRequsestHandler.h"

#import "IndexController.h"
#import "AnnounceController.h"
#import "AllGoodsController.h"
#import "ShopCartController.h"
#import "PersonalController.h"
#import "Database.h"
@interface AppDelegate ()<WXApiDelegate,ontdelegater>
@property(retain,nonatomic)UITabBarController *arr;
@property (retain,nonatomic) NSMutableArray *shopCartArray;
@property (retain,nonatomic) UITabBarItem *shopCartItem;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘收起
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //控制整个功能是否启用
    manager.enable = YES;
    //控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    //控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    //控制是否显示键盘上的工具条
    manager.enableAutoToolbar = YES;
    //APP_ID 这里我写成了宏的形式，如果你按照我的文档方法添加了WXPay的文件夹，你这里可以直接点击宏进去查看里面其他的宏
    [WXApi registerApp:APP_ID withDescription:@"1元商城"];
    [ShareSDK registerApp:@"dade7bf06aaa"];
    [self initShareSDKRegisit];
    [self tabRootView];
    return YES;
}

-(void)tabRootView{
    //tab
    //修改选中后的字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1],UITextAttributeTextColor, nil]forState:UIControlStateSelected];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    IndexController *indexController = [storyboard instantiateViewControllerWithIdentifier:@"HomeView"];//首页
    UINavigationController *indexNav=[[UINavigationController alloc]initWithRootViewController:indexController];
    indexNav.navigationBar.barTintColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    indexController.delegate=self;
    AllGoodsController *allController = [storyboard instantiateViewControllerWithIdentifier:@"AllGoodsView"];//所有商品
    UINavigationController *allNav=[[UINavigationController alloc]initWithRootViewController:allController];
    allNav.navigationBar.barTintColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    AnnounceController *announceController = [storyboard instantiateViewControllerWithIdentifier:@"Announce"];//最新揭晓
    UINavigationController *annNav=[[UINavigationController alloc]initWithRootViewController:announceController];
    annNav.navigationBar.barTintColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    ShopCartController *shopCartController = [storyboard instantiateViewControllerWithIdentifier:@"ShopCart"];//购物车
    UINavigationController *shopCartNav=[[UINavigationController alloc]initWithRootViewController:shopCartController];
    shopCartNav.navigationBar.barTintColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    PersonalController *perController = [storyboard instantiateViewControllerWithIdentifier:@"PersonalView"];//个人中心
    UINavigationController *perNav=[[UINavigationController alloc]initWithRootViewController:perController];
    perNav.navigationBar.barTintColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
    //设置首页选中和非选中状态下的图片
    UITabBarItem *homeItem=[[UITabBarItem alloc ] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_page_nomal"] selectedImage:[[UIImage imageNamed:@"tab_home_page_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    indexController.tabBarItem=homeItem;
    //设置所有商品选中和非选中状态下的图片
    UITabBarItem *goodsItem=[[UITabBarItem alloc ] initWithTitle:@"所有商品" image:[UIImage imageNamed:@"tab_product_list_nomal"] selectedImage:[[UIImage imageNamed:@"tab_product_list_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    allController.tabBarItem=goodsItem;
    //设置最新揭晓选中和非选中状态下的图片
    UITabBarItem *annItem=[[UITabBarItem alloc ] initWithTitle:@"最新揭晓" image:[UIImage imageNamed:@"tab_latest_ann_nomal"] selectedImage:[[UIImage imageNamed:@"tab_latest_ann_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    announceController.tabBarItem=annItem;
    //设置购物车选中和非选中状态下的图片
    self.shopCartItem=[[UITabBarItem alloc ] initWithTitle:@"购物车" image:[UIImage imageNamed:@"tab_shopping_cart_nomal"] selectedImage:[[UIImage imageNamed:@"tab_shopping_cart_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    shopCartController.tabBarItem=_shopCartItem;
    //数据
    Database *db=[[Database alloc]init];
    _shopCartArray=[db getList];
    if (_shopCartArray.count>0) {
        _shopCartItem.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)_shopCartArray.count];
    }
    //设置个人中心选中和非选中状态下的图片
    UITabBarItem *perItem=[[UITabBarItem alloc ] initWithTitle:@"我的云购" image:[UIImage imageNamed:@"tab_my_cloud_nomal"] selectedImage:[[UIImage imageNamed:@"tab_my_cloud_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    perController.tabBarItem=perItem;
    self.arr =[[UITabBarController alloc]init];
    self.arr.tabBar.tintColor=[UIColor redColor];
    self.arr.viewControllers=@[indexNav,allNav,annNav,shopCartNav,perNav];
    self.window.rootViewController=self.arr;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCart:) name:@"addCart" object:nil];
    
}
#pragma mark 监听通知
- (void)tongzhi:(NSNotification *)data{
    self.arr.selectedIndex=[data.userInfo[@"Index"] intValue];
}
-(void)addCart:(NSNotification *)data{
    //数据
    Database *db=[[Database alloc]init];
    _shopCartArray=[db getList];
    _shopCartItem.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)_shopCartArray.count];
}
/**
 *  tab跳转代理
 *
 *  @param a <#a description#>
 */
-(void)nsdd:(int)a
{
    self.arr.selectedIndex=a;
}
- (void)initShareSDKRegisit
{
    //微信朋友
    [ShareSDK connectWeChatSessionWithAppId:APP_ID
                                  appSecret:APP_SECRET
                                  wechatCls:[WXApi class]];
    //微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:APP_ID
                                   wechatCls:[WXApi class]];
    
    //QQ
    [ShareSDK connectQZoneWithAppKey:@"101282385"
                           appSecret:@"6b9b1cb215686a40a5cff1da1c3fe6a6"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQQWithQZoneAppKey:@"QQ6097251"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
//        return [ShareSDK handleOpenURL:url
//                            wxDelegate:self];
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
        return [ShareSDK handleOpenURL:url wxDelegate:self];;
    }
    
}

#pragma mark - IOS9.0以后废弃了这两个方法的调用  改用上边这个方法了，请注意、
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{

        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
//    这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",APP_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else
    {
//        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:self];
    }
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
-(void) onResp:(BaseResp*)resp
{
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"成功"];
                break;
                
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                break;
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        NSLog(@"result = %@",resultDic);
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];
//        
//    }];
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    return YES;
//}
@end
