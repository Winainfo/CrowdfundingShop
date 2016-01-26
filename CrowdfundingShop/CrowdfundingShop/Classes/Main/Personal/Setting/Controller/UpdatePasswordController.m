//
//  UpdatePasswordController.m
//  CrowdfundingShop
//  登录密码修改
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "UpdatePasswordController.h"
#import "ARLabel.h"
#import "AccountTool.h"
#import "RequestData.h"
#import <MBProgressHUD.h>
#import <JGProgressHUD.h>
@interface UpdatePasswordController ()<JGProgressHUDDelegate>
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
    [self flagLogin];
}
#pragma mark 密码修改
-(void)requestData:(NSString *)userpassword anduserpwd2:(NSString *)userpassword2 andpwd:(NSString *)password{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",userpassword,@"userpassword",userpassword2,@"userpassword2",password,@"password",nil];

    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在修改";
    [RequestData updatePwdSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"]intValue];
        NSLog(@"%@",data[@"content"]);
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"修改成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
        }else{
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"修改失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
    }andFailure:^(NSError *error) {
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"无法请求";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}
/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    self.accountNumberLabel.text=account.mobile;
    NSString *phoneString = [self.accountNumberLabel.text substringWithRange:NSMakeRange(5,4)];
    self.accountNumberLabel.text=[self.accountNumberLabel.text stringByReplacingOccurrencesOfString:phoneString withString:@"****"];
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
 *  修改密码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)updatePwdClick:(id)sender {
     JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    NSString *pwd1=[NSString stringWithFormat:@"%@",self.PwdTextField.text];
    NSString *pwd2=[NSString stringWithFormat:@"%@",self.verifyPwdTextField.text];
    if (self.currentPwdTextField.text.length==0) {
        HUD.indicatorView = nil;
        HUD.textLabel.text = @"当前密码不能为空";
        HUD.position = JGProgressHUDPositionCenter;
        [HUD showInView:self.navigationController.view];
        [HUD dismissAfterDelay:1];
    }else  if ([pwd1 isEqualToString:pwd2]&&self.PwdTextField.text.length>7&&self.verifyPwdTextField.text.length>7) {
        [self requestData:self.PwdTextField.text anduserpwd2:self.verifyPwdTextField.text andpwd:self.currentPwdTextField.text];
    }else{
        HUD.indicatorView = nil;
        HUD.textLabel.text = @"密码格式不正确，请检查";
        HUD.position=JGProgressHUDPositionCenter;
        [HUD showInView:self.navigationController.view];
        [HUD dismissAfterDelay:1];
    }

}

@end
