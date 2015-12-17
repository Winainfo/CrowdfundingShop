//
//  PersonalController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "PersonalController.h"

@interface PersonalController ()

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"我的云购";
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"MyCloud_setting_select"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"MyCloud_setting_select"] forState:UIControlStateSelected];
    rightBtn.frame=CGRectMake(-5, 5, 21, 21);
    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
}

-(void)searchClick{
    
}

@end
