//
//  UpdatePasswordController.m
//  CrowdfundingShop
//  登录密码修改
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "UpdatePasswordController.h"
#import "ARLabel.h"
@interface UpdatePasswordController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
/**账号*/
@property (weak, nonatomic) IBOutlet ARLabel *accountNumberLabel;
/**当前密码*/
@property (weak, nonatomic) IBOutlet UITextField *currentPwdTextField;
/**新密码*/
@property (weak, nonatomic) IBOutlet UITextField *PwdTextField;
/**确定密码*/
@property (weak, nonatomic) IBOutlet UITextField *verifyPwdTextField;
/** 保存按钮*/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation UpdatePasswordController

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
    self.title=@"登录密码修改";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self setExtraCellLineHidden:self.myTableView];
    self.saveBtn.layer.cornerRadius=4.0;
    self.saveBtn.layer.masksToBounds=YES;
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  去掉多余的分割线
 *
 *  @param tableView <#tableView description#>
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
