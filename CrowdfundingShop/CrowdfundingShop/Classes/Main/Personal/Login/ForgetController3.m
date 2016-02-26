//
//  ForgetController3.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/26.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "ForgetController3.h"
#import "PersonalController.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "RequestData.h"
@interface ForgetController3 ()
@property (weak, nonatomic) IBOutlet UITextField *pwd1TextField;
@property (weak, nonatomic) IBOutlet UITextField *pwd2TextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ForgetController3
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
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwd1TextField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwd2TextField];
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
    if (self.pwd1TextField.text.length>0&&self.pwd2TextField.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.pwd1TextField.text.length<1&&self.pwd2TextField.text.length<1)
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
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.pwd1TextField.text,@"userpassword",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在修改...";
    [RequestData forgetUpdateSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
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
            //popToViewController
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[PersonalController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
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
        failHUD.labelText = @"网络连接错误";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
        
    }];
    
}
/**
 *  注册
 */
- (void)registerClick {
    NSString *pwd1=self.pwd1TextField.text;
    NSString *pwd2=self.pwd2TextField.text;
    if ([pwd1 isEqualToString:pwd2]) {
        [self requestServer];
    }else{
        //声明对象；
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        hud.mode=MBProgressHUDModeText;
        hud.labelText = @"两次密码不相同";
        [hud hide:true afterDelay:1];
        
    }
}


@end
