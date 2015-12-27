//
//  BalanceController.m
//  CrowdfundingShop
//  结算
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceController.h"

@interface BalanceController ()
/**结算按钮*/
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;

@end

@implementation BalanceController
//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"结算";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**设置圆角*/
    self.balanceBtn.layer.cornerRadius=4.0;
    self.balanceBtn.layer.masksToBounds=YES;
}
//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
