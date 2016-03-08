//
//  VerifyPhoneController2.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "VerifyPhoneController2.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "RequestData.h"
#import "AccountTool.h"
#import "VerifyPhoneController3.h"
#import "PersonalController.h"
@interface VerifyPhoneController2 ()<UITextFieldDelegate>
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/***/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation VerifyPhoneController2

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
    self.title=@"绑定手机";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    self.saveBtn.layer.cornerRadius=4.0;
    self.saveBtn.layer.masksToBounds=YES;
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
}
-(void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/**
 *  返回
 */
-(void)backClick{
    //popToViewController
    for (UIViewController *temp in self.navigationController.viewControllers) {
        NSLog(@"%@",temp);
        if ([temp isKindOfClass:[PersonalController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
/**
 *  文本改变事件
 */
-(void)textChange{
    //1.同时改变文本值，登录才可用
    if (self.phoneTextField.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.phoneTextField.text.length<1)
    {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关闭交互
        self.saveBtn.userInteractionEnabled=NO;
    }
}
#pragma mark 获取验证码
/**
 *  获取验证码
 *
 *  @param username <#username description#>
 *  @param qianming <#qianming description#>
 */
-(void)requestData{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.phoneTextField.text,@"mobile",nil];
    [RequestData sendMobileCodeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"]intValue];
        if (code==0) {
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            VerifyPhoneController3 *controller=[storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneView3"];
            controller.uid=account.uid;
            controller.mobile=self.phoneTextField.text;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"发生失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
    }andFailure:^(NSError *error) {
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"网络异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}
/**
 *   下一步
 *
 *  @param sender <#sender description#>
 */
- (void)nextAction{
    //沙盒路径
    AccountModel *account=[AccountTool account];
   NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"user",nil];
    BOOL flag=[self checkTel:self.phoneTextField.text];
    if (flag) {
        [RequestData checkName:param FinishCallbackBlock:^(NSDictionary *data) {
            int state=[data[@"content"][@"state"] intValue];
            if (state==0) { //1.表示已被绑定 0.表示未被绑定
                //设置故事板为第一启动
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                VerifyPhoneController3 *controller=[storyboard instantiateViewControllerWithIdentifier:@"VerifyPhoneView3"];
                controller.uid=account.uid;
                controller.mobile=self.phoneTextField.text;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                //声明对象；
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                hud.mode=MBProgressHUDModeText;
                hud.labelText = @"您输入的手机号已被绑定";
                [hud hide:true afterDelay:1];

            }
        }];
    }
}

///**
// *  该方法在视图跳转时被触发
// *
// *  @param segue  <#segue description#>
// *  @param sender <#sender description#>
// */
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"phoneString"]) {
//        id theSegue=segue.destinationViewController;
//        [theSegue setValue:self.phoneTextField.text forKey:@"phone"];
//    }
//}
- (BOOL)checkTel:(NSString *)str{
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
@end
