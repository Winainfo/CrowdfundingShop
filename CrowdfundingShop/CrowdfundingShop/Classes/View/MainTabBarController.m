//
//  MainTabBarController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/24.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeNavController.h"
#import "PerNavController.h"
#import "ShopNavController.h"
#import "GoodsNavController.h"
#import "AnnNavController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //未选中后的字体
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:50/255.0 green:185/255.0 blue:170/255.0 alpha:1], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //修改选中后的字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0/255.0 green:152.0/255.0 blue:255.0/255.0 alpha:1],UITextAttributeTextColor, nil]forState:UIControlStateSelected];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeNavController *homeNavController = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavView"];//首页
    GoodsNavController *goodsNavController=[storyboard instantiateViewControllerWithIdentifier:@"GoodsNavView"];//所有商品
    AnnNavController *annNavController=[storyboard instantiateViewControllerWithIdentifier:@"AnnNavView"];//最新揭晓
    ShopNavController *shopCartNavController=[storyboard instantiateViewControllerWithIdentifier:@"ShopNavView"];//购物车
    PerNavController *perNavController=[storyboard instantiateViewControllerWithIdentifier:@"PerNavView"];//个人中心
    
    //设置首页选中和非选中状态下的图片
    UITabBarItem *homeItem=[[UITabBarItem alloc ] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_home_page_nomal"] selectedImage:[[UIImage imageNamed:@"tab_home_page_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    homeNavController.tabBarItem=homeItem;
    //设置所有商品选中和非选中状态下的图片
    UITabBarItem *goodsItem=[[UITabBarItem alloc ] initWithTitle:@"所有商品" image:[UIImage imageNamed:@"tab_product_list_nomal"] selectedImage:[[UIImage imageNamed:@"tab_product_list_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    goodsNavController.tabBarItem=goodsItem;
    //设置最新揭晓选中和非选中状态下的图片
    UITabBarItem *annItem=[[UITabBarItem alloc ] initWithTitle:@"最新揭晓" image:[UIImage imageNamed:@"tab_latest_ann_nomal"] selectedImage:[[UIImage imageNamed:@"tab_latest_ann_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    annNavController.tabBarItem=annItem;
    //设置购物车选中和非选中状态下的图片
    UITabBarItem *shopCartItem=[[UITabBarItem alloc ] initWithTitle:@"购物车" image:[UIImage imageNamed:@"tab_shopping_cart_nomal"] selectedImage:[[UIImage imageNamed:@"tab_shopping_cart_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    shopCartNavController.tabBarItem=shopCartItem;
    //设置个人中心选中和非选中状态下的图片
    UITabBarItem *perItem=[[UITabBarItem alloc ] initWithTitle:@"我的云购" image:[UIImage imageNamed:@"tab_my_cloud_nomal"] selectedImage:[[UIImage imageNamed:@"tab_my_cloud_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    perNavController.tabBarItem=perItem;
    
    
    self.viewControllers=[[NSArray alloc]initWithObjects:homeNavController,goodsNavController,annNavController,shopCartNavController,perNavController,nil];
    //设置默认选中
    self.selectedViewController=homeNavController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
