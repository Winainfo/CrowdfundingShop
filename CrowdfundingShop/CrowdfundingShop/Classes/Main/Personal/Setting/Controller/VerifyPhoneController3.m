//
//  VerifyPhoneController3.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "VerifyPhoneController3.h"
#import "PersonalController.h"
#import "ARLabel.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "RequestData.h"
#import "AccountTool.h"
#import "GBverifyButton.h"
@interface VerifyPhoneController3 ()<UITextFieldDelegate>
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verifyNumTextField;
/**手机号*/
@property (weak, nonatomic) IBOutlet ARLabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,retain)GBverifyButton*button;
@end

@implementation VerifyPhoneController3

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
    
    _button=[[GBverifyButton alloc]initWithFrame:CGRectMake(self.verifyNumTextField.frame.size.width+10, self.verifyNumTextField.frame.origin.y, 125, 40) delegate:self Target:self Action:@selector(getcode)];
    [_button setBackgroundColor:[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]];
    [self.view addSubview:_button];
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.verifyNumTextField];
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
    if (self.verifyNumTextField.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(bindAction) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.verifyNumTextField.text.length<1)
    {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关闭交互
        self.saveBtn.userInteractionEnabled=NO;
    }
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getcode{
    self.phoneLabel.text=[NSString stringWithFormat:@"验证码已发送到您的手机:%@",self.mobile];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.uid,@"uid",self.mobile,@"mobile",nil];
    [RequestData sendMobileCodeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"]intValue];
        NSLog(@"%@",data);
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
#pragma mark 绑定手机
/**
 *  绑定手机
 */
-(void)requestData{
    //沙盒路径
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.uid,@"uid",self.mobile,@"mobile",self.verifyNumTextField.text,@"checkcodes",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在验证";
    //沙盒路径
    AccountModel *account=[AccountTool account];
    [RequestData bindMobileSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"]intValue];
        NSLog(@"绑定数据%@",data);
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
            account.mobile=self.mobile;
            account.mobilecode=@"1";
            [AccountTool saveAccount:account];
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
            failHUD.labelText = @"验证失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];        }
    }andFailure:^(NSError *error) {
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
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
 *  绑定
 *
 *  @param sender <#sender description#>
 */
- (void)bindAction {
    [self requestData];
}

@end
