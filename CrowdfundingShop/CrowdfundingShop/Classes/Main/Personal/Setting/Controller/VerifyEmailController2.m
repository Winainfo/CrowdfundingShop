//
//  VerifyEmailController2.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "VerifyEmailController2.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "RequestData.h"
#import "AccountTool.h"
@interface VerifyEmailController2 ()<UITextFieldDelegate>
/**邮箱号*/
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
/***/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation VerifyEmailController2

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
    self.title=@"绑定邮箱";
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
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.emailTextField];
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
    if (self.emailTextField.text.length>0) {
        //改变btn背景颜色
        self.saveBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.saveBtn.userInteractionEnabled=YES;
        
    }else if (self.emailTextField.text.length<1)
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

/**
 *   下一步
 *
 *  @param sender <#sender description#>
 */
- (void)nextAction{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.emailTextField.text,@"email",nil];
    BOOL flag=[self checkTel:self.emailTextField.text];
    if (flag) {
        [RequestData sendEmalCodeSerivce:param FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            NSLog(@"%@",data);
            if (code==0) { //1.表示已被绑定 0.表示未被绑定
                //声明对象；
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                hud.mode=MBProgressHUDModeText;
                hud.labelText = @"请到您的邮箱绑定账户";
                [hud hide:true afterDelay:1];
            }else{
                //声明对象；
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                hud.mode=MBProgressHUDModeText;
                hud.labelText = @"您输入的邮箱已被绑定";
                [hud hide:true afterDelay:1];
                
            }
        }andFailure:^(NSError *error) {
            
        }];
    }
}
- (BOOL)checkTel:(NSString *)str{
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入邮箱", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的邮箱" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}
@end
