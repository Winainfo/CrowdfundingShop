//
//  Register2Controller.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "Register2Controller.h"
#import "RequestData.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "AccountTool.h"
#import "PersonalController.h"
#import "ARLabel.h"
#import "GBverifyButton.h"
@interface Register2Controller ()<UITextFieldDelegate>
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
/**
 *  <#Description#>
 */
@property (weak, nonatomic) IBOutlet ARLabel *phoneLabel;
@property(nonatomic,retain)GBverifyButton*button;
@end

@implementation Register2Controller
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
    self.title=@"身份验证";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**圆角*/
    self.saveBtn.layer.cornerRadius=2.0;
    self.saveBtn.layer.masksToBounds=YES;
    _button=[[GBverifyButton alloc]initWithFrame:CGRectMake(self.codeTextField.frame.size.width+10, self.codeTextField.frame.origin.y, 125, 40) delegate:self Target:self Action:@selector(getcode)];
    [_button setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]];
    [self.view addSubview:_button];
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
}
-(void)dealloc
{
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 *  文本改变事件
 */
-(void)textChange{
    //1.同时改变文本值，登录才可用
    if (self.codeTextField.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(requestServer) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.codeTextField.text.length<1)
    {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关闭交互
        self.saveBtn.userInteractionEnabled=NO;
    }
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  获取验证码
 */
-(void)getcode{
    self.phoneLabel.text=[NSString stringWithFormat:@"验证码已发送到您的手机:%@",self.mobile];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.mobile,@"user",nil];
    [RequestData getCodeSerivce:params FinishCallbackBlock:^(NSDictionary *data1) {
        int code=[data1[@"code"] intValue];
        if (code==0) {
             [_button startGetMessage];
        }else{
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"发生失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];

        }
    } andFailure:^(NSError *error) {
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"网络异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];

    }];
}
#pragma mark 数据
/**
 *  用户注册
 */
-(void)requestServer{
    NSString *codeStr=self.codeTextField.text;
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在注册...";

    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.uid,@"uid",codeStr,@"checkcodes",nil];
    [RequestData checkCodeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        NSLog(@"%@",data);
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"验证成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
            //存储账号信息
            AccountModel *account=[AccountModel new];
            account.uid=data[@"content"][@"uid"];
            account.username=data[@"content"][@"username"];
            account.email=data[@"content"][@"email"];
            account.mobile=data[@"content"][@"mobile"];
            account.user_ip=data[@"content"][@"user_ip"];
            account.img=data[@"content"][@"img"];
            account.qianming=data[@"content"][@"qianming"];
            account.groupid=data[@"content"][@"groupid"];
            account.addgroup=data[@"content"][@"addgroup"];
            account.money=data[@"content"][@"money"];
            account.emailcode=data[@"content"][@"emailcode"];
            account.mobilecode=data[@"content"][@"mobilecode"];
            account.passcode=data[@"content"][@"passcode"];
            account.reg_key=data[@"content"][@"reg_key"];
            account.score=data[@"content"][@"score"];
            account.jingyan=data[@"content"][@"jingyan"];
            account.yaoqing=data[@"content"][@"yaoqing"];
            account.band=data[@"content"][@"band"];
            account.time=data[@"content"][@"time"];
            account.login_time=data[@"content"][@"login_time"];
            account.sign_in_time=data[@"content"][@"sign_in_time"];
            account.sign_in_date=data[@"content"][@"sign_in_date"];
            account.sign_in_time_all=data[@"content"][@"sign_in_time_all"];
            account.auto_user=data[@"content"][@"auto_user"];
            account.yungoudj=data[@"content"][@"yungoudj"];
            account.icon=data[@"content"][@"icon"];
            [AccountTool saveAccount:account];
            //popToViewController
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[PersonalController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"验证码失效";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
    } andFailure:^(NSError *error) {
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"网络加载异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }];
}


@end
