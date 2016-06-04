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
#import "AccountTool.h"
#import "Database.h"
#import "IndexController.h"
@interface MainTabBarController ()<ontdelegater>
@property (retain,nonatomic) NSMutableArray *shopCartArray;
@property(retain,nonatomic)UITabBarController *arr;
@end

@implementation MainTabBarController
-(void)viewWillAppear:(BOOL)animated{
    [self flagLogin];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self flagLogin];
}

/**
 *  判断是否有登录
 */
-(void)flagLogin
{    //修改选中后的字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1],UITextAttributeTextColor, nil]forState:UIControlStateSelected];
    
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

    //设置个人中心选中和非选中状态下的图片
    UITabBarItem *perItem=[[UITabBarItem alloc ] initWithTitle:@"我的云购" image:[UIImage imageNamed:@"tab_my_cloud_nomal"] selectedImage:[[UIImage imageNamed:@"tab_my_cloud_pressed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    perNavController.tabBarItem=perItem;

    self.viewControllers=[[NSArray alloc]initWithObjects:homeNavController,goodsNavController,annNavController,shopCartNavController,perNavController,nil];
    //设置默认选中
    self.selectedIndex=0;
}
-(void)nsdd:(int)a
{
    NSLog(@"aaaa %d",a);
    self.selectedIndex=a;
}
@end
