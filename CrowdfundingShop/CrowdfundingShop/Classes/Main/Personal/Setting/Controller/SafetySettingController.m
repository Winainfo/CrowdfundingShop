//
//  SafetySettingController.m
//  CrowdfundingShop
//  安全设置
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "SafetySettingController.h"
#import "ARLabel.h"
@interface SafetySettingController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
/**手机号*/
@property (weak, nonatomic) IBOutlet ARLabel *phoneLabel;
/**邮箱*/
@property (weak, nonatomic) IBOutlet ARLabel *emailLabel;

@end

@implementation SafetySettingController

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
    self.title=@"安全设置";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self setExtraCellLineHidden:self.myTableView];
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
/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"verifyPhone"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.phoneLabel.text forKey:@"phone"];
    }else if ([segue.identifier isEqualToString:@"verifyEmail"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.emailLabel.text forKey:@"email"];
    }
}

@end
