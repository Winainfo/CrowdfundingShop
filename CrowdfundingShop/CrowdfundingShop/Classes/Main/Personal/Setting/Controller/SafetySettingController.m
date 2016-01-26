//
//  SafetySettingController.m
//  CrowdfundingShop
//  安全设置
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "SafetySettingController.h"
#import "ARLabel.h"
#import "AccountTool.h"
#import "RequestData.h"
#import "VerifyEmailController1.h"
#import "VerifyEmailController2.h"
#import "VerifyPhoneController1.h"
#import "VerifyPhoneController2.h"
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
    [self flagLogin];
}
/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if (![self isBlankString:account.mobile]) {
         self.phoneLabel.text=account.mobile;
        //字符串的截取
        NSString *phoneString = [self.phoneLabel.text substringWithRange:NSMakeRange(5,4)];
        //字符串的替换
        self.phoneLabel.text = [self.phoneLabel.text stringByReplacingOccurrencesOfString:phoneString withString:@"****"];
    }else{
        self.phoneLabel.text=@"未绑定";
    }
    if (![self isBlankString:account.email]) {
        self.emailLabel.text=account.email;
    }else{
        self.emailLabel.text=@"未绑定";
    }
}
/**
 *  判断字符是否为空
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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
///**
// *  该方法在视图跳转时被触发
// *
// *  @param segue  <#segue description#>
// *  @param sender <#sender description#>
// */
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"verifyPhone"]) {
//        id theSegue=segue.destinationViewController;
//        [theSegue setValue:self.phoneLabel.text forKey:@"phone"];
//    }else if ([segue.identifier isEqualToString:@"verifyEmail"]){
//        id theSegue=segue.destinationViewController;
//        [theSegue setValue:self.emailLabel.text forKey:@"email"];
//    }
//}
/**
 *  绑定手机
 *
 *  @param sender <#sender description#>
 */
- (IBAction)verifyPhoneClick:(UIButton *)sender {
    //沙盒路径
    AccountModel *account=[AccountTool account];
    int phoneCode=[account.mobilecode intValue];
    if (phoneCode==1) {
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyPhoneController1 *phoneController=[storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneView1"];
        phoneController.phone=account.mobile;
        phoneController.uid=account.uid;
        [self.navigationController pushViewController:phoneController animated:YES];
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyPhoneController2 *phoneController=[storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneView2"];
        [self.navigationController pushViewController:phoneController animated:YES];
    }
}
/**
 *  绑定邮箱
 *
 *  @param sender <#sender description#>
 */
- (IBAction)verifyEmailClick:(UIButton *)sender {
    //沙盒路径
    AccountModel *account=[AccountTool account];
    int emailCode=[account.emailcode intValue];
    if (emailCode==1) {
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyEmailController1 *emailController=[storyboard instantiateViewControllerWithIdentifier:@"VerifyEmailView1"];
        emailController.email=account.email;
        [self.navigationController pushViewController:emailController animated:YES];
    }else{
        //设置故事板为第一启动
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyEmailController2 *controller=[storyboard instantiateViewControllerWithIdentifier:@"VerifyEmailView2"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
