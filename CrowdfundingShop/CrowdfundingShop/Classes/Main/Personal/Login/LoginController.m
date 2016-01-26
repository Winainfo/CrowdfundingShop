//
//  LoginController.m
//  CrowdfundingShop
//  登录
//  Created by 吴金林 on 15/11/25.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "LoginController.h"
#import "RequestData.h"
#import "PersonalController.h"
#import "ShopCartController.h"
#import "CommentaryController.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginMethod.h"
@interface LoginController ()<LoginMethodDelegate>
@property (nonatomic ,strong) LoginMethod * myLoginMethod;
/**登录按钮*/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**账号*/
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
/**密码*/
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@end

@implementation LoginController
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
    self.title=@"登录";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**圆角*/
    self.loginBtn.layer.cornerRadius=2.0;
    self.loginBtn.layer.masksToBounds=YES;
    //只需要初始化LoginMethod这个类的对象，然后让当前控制器遵守他的协议
    self.myLoginMethod = [[LoginMethod alloc]init];
    self.myLoginMethod.delegate = self;

}
-(void)searchClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 数据请求
/**
 *  请求登录
 */
-(void)requestData:(NSString *)user andpassword:(NSString *)pwd{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:user,@"user",pwd,@"password",nil];
    [RequestData login:params FinishCallbackBlock:^(NSDictionary *data) {
        
//        NSString *code=data[@"code"];
        int code=[data[@"code"] intValue];
        NSLog(@"%d",code);
        if (code==0) {
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
            if ([self.type isEqualToString:@"shopCart"]) {
                //popToViewController
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[ShopCartController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else if([self.type isEqualToString:@"commentary"]){
                //popToViewController
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[CommentaryController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else{
                //popToViewController
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[PersonalController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }
        }else{
           
        }
    }];
}
/**
 *  登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)loginClick:(UIButton *)sender {
    [self requestData:self.userTextField.text andpassword:self.pwdTextField.text];
}
/**
 *  微信登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)weixinLogin:(UIButton *)sender {
    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeWechat];
}
/**
 *  qq登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)qqLogin:(id)sender {
    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeQQ];
}
#pragma mark - LoginDelegate
/**
 *  拿到数据之后的代理方法
 *
 *  @param userInfo 拿到的用户数据
 *  @param errorMsg 返回的错误信息。（判断是否存在错误信息，如果没有错误信息，用户数据可以拿到）
 */
-(void)recieveTheUserInfo:(NSDictionary *)userInfo errorMsg:(NSString *)errorMsg
{
    if (!errorMsg) {
        NSLog(@"%@",userInfo);
    }else{
        NSLog(@"%@",errorMsg);
    }
    
}
@end
