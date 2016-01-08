//
//  ShopNavController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/24.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShopNavController.h"
#import "AccountTool.h"
@interface ShopNavController ()

@end

@implementation ShopNavController
-(void)viewWillAppear:(BOOL)animated{
//    [self flagLogin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        [self.tabBarItem setBadgeValue:@"2"];
    }else
    {
        [self.tabBarItem setBadgeValue:nil];
    }
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
