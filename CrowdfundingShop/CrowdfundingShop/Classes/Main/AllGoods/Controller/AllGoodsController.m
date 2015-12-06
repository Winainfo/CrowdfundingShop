//
//  AllGoodsController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AllGoodsController.h"

@interface AllGoodsController ()

@end

@implementation AllGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]}];
    self.title=@"所有商品";
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"search_bt_bg_select"] forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
}

-(void)searchClick{
    
}

@end
