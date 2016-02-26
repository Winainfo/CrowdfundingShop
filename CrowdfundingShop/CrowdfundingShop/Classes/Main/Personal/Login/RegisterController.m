//
//  RegisterController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/23.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "RegisterController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "RequestData.h"
#import "Register1Controller.h"
#import "Register2Controller.h"
@interface RegisterController ()<UITextFieldDelegate>
/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation RegisterController
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
    self.title=@"账户注册";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.passwordText];
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.phoneTextField.text.length>0&&self.passwordText.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.phoneTextField.text.length<1&&self.passwordText.text.length<1)
    {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关闭交互
        self.saveBtn.userInteractionEnabled=NO;
    }
}
#pragma mark 数据
/**
 *  用户注册
 */
-(void)requestServer{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"user",nil];

    [RequestData checkName:param FinishCallbackBlock:^(NSDictionary *json) {
        int jsoncode=[json[@"content"][@"state"] intValue];
        if (jsoncode==0) {
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"user",self.passwordText.text,@"password",nil];
            //声明对象；
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            //显示的文本；
            hud.labelText = @"正在注册...";
            [RequestData userRegisterSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                int code=[data[@"code"] intValue];
                if (code==0) {
                    //加载成功，先移除原来的HUD；
                    hud.removeFromSuperViewOnHide = true;
                    [hud hide:true afterDelay:0];
                    //设置故事板为第一启动
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    Register2Controller *controller=[storyboard instantiateViewControllerWithIdentifier:@"register2View"];
                    controller.uid=data[@"content"][@"uid"];
                    controller.mobile=self.phoneTextField.text;
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    hud.removeFromSuperViewOnHide = true;
                    [hud hide:true afterDelay:0];
                    //显示失败的提示；
                    MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    failHUD.labelText = @"注册失败";
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
                failHUD.labelText = @"网络连接错误";
                failHUD.mode = MBProgressHUDModeCustomView;
                failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
                failHUD.removeFromSuperViewOnHide = true;
                [failHUD hide:true afterDelay:1];
                
            }];
        }else{
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"改手机号码已被注册";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
    }];
    
   }
/**
 *  注册
 */
- (void)registerClick {
    NSString *phone=self.phoneTextField.text;
    NSString *pwd=self.passwordText.text;
    if ([phone length]!=0&&[pwd length]!=0) {
         BOOL flag=[self checkTel:self.phoneTextField.text];
        if (flag) {
            [self requestServer];
        }
    }else{
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"请输入您的手机号或密码";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];

    }
}
- (BOOL)checkTel:(NSString *)str

{
    
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
