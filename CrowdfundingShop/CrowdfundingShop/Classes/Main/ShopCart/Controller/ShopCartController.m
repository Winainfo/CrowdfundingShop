//
//  ShopCartController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShopCartController.h"

@interface ShopCartController ()

@end

@implementation ShopCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"购物车";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
