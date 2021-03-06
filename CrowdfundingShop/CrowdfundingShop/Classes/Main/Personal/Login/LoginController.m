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
#import "LoginMethod.h"
#import "IndexController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
@interface LoginController ()<LoginMethodDelegate,UITextFieldDelegate>
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
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.userTextField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdTextField];
    if ([WXApi isWXAppInstalled]) {
        self.view1.hidden=NO;
        self.view2.hidden=NO;
        self.view3.hidden=NO;
        self.view4.hidden=NO;
        self.view5.hidden=NO;
    }else{
        self.view1.hidden=YES;
        self.view2.hidden=YES;
        self.view3.hidden=YES;
        self.view4.hidden=YES;
        self.view5.hidden=YES;
    }
    if ([QQApi isQQInstalled]) {
        self.view1.hidden=NO;
        self.view2.hidden=NO;
        self.view3.hidden=NO;
        self.view4.hidden=NO;
        self.view5.hidden=NO;
    }else{
        self.view1.hidden=YES;
        self.view2.hidden=YES;
        self.view3.hidden=YES;
        self.view4.hidden=YES;
        self.view5.hidden=YES;
    }

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
    if (self.userTextField.text.length>0&&self.pwdTextField.text.length>0) {
        //改变btn背景颜色
        self.loginBtn.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0];
        //改变字体颜色
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        //关闭交互
        self.loginBtn.userInteractionEnabled=YES;
        
    }else if (self.userTextField.text.length<1&&self.pwdTextField.text.length<1)
    {
        //改变btn背景颜色
        self.loginBtn.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        //改变字体颜色
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //关闭交互
        self.loginBtn.userInteractionEnabled=NO;
    }
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
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在登录...";
    [RequestData login:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"登录成功";
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
                    if ([temp isKindOfClass:[IndexController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else if([self.type isEqualToString:@"recode"]){
                //popToViewController
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[IndexController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }else if([self.type isEqualToString:@"rechare"]){
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
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"登录失败";
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
        failHUD.labelText = @"网络异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];

    }];
}
/**
 *  登录
 *
 *  @param sender <#sender description#>
 */
- (void)loginClick {
    [self requestData:self.userTextField.text andpassword:self.pwdTextField.text];
}
/**
 *  微信登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)weixinLogin:(UIButton *)sender {
//    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeWechat];
    //设置授权选项
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        // 获取token
        id <ISSPlatformCredential> Cred = [userInfo credential];
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:[Cred token],@"access_token",[userInfo uid],@"openid",nil];
        [RequestData userinfoSerivce:params FinishCallbackBlock:^(NSDictionary *data1) {
            NSDictionary *params1=[NSDictionary dictionaryWithObjectsAndKeys:data1[@"unionid"],@"b_code",nil];
            NSLog(@"用户资料:%@",data1);
            [RequestData thirdLodigSerivce:params1 FinishCallbackBlock:^(NSDictionary *data) {
                NSLog(@"返回:%@",data);
                int code=[data[@"code"] intValue];
                if (code==0) {
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"loginAction" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
                            if ([temp isKindOfClass:[IndexController class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                        }
                    }else if([self.type isEqualToString:@"recode"]){
                        //popToViewController
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[IndexController class]]) {
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                        }
                    }else if([self.type isEqualToString:@"rechare"]){
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
                    //下载图片
                    NSString * imageURL = data1[@"headimgurl"];
                   int flag= [self downLoadImageFromURL:imageURL withName:@"image"];
                    NSLog(@"返回值:%d",flag);
                    
                    NSString * filePath = [DOCUMENT_PATH stringByAppendingPathComponent:@"image"];
                    filePath = [NSString stringWithFormat:@"%@.jpg", filePath];
                    UIImage * image =[UIImage imageNamed:filePath];
                    if (flag==0) {
                        /*使用Base64字符串传图片*/
                        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
                        NSString *format=[self typeForImageData:data];
                        NSString *pictureDataString=[NSString stringWithFormat:@"data:%@;base64,%@",format,[data base64EncodedStringWithOptions:0]];
                        NSDictionary *reparams=[NSDictionary dictionaryWithObjectsAndKeys:data1[@"nickname"],@"user",@"123456",@"password",@"weixin",@"type",data1[@"unionid"],@"openid",pictureDataString,@"photo",nil];
                        [RequestData thirdRegisterSerivce:reparams FinishCallbackBlock:^(NSDictionary *data) {
                            NSLog(@"注册返回:%@",data);
                            int recode=[data[@"code"] intValue];
                            if (recode==0) {
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
                                        if ([temp isKindOfClass:[IndexController class]]) {
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }else if([self.type isEqualToString:@"recode"]){
                                    //popToViewController
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[IndexController class]]) {
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }else if([self.type isEqualToString:@"rechare"]){
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
                            }
                        } andFailure:^(NSError *error) {
                        }];
                    }
                }
            } andFailure:^(NSError *error) {
                
            }];
        } andFailure:^(NSError *error) {
            
        }];
    }];
    
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
        NSLog(@"用户资料:%@",userInfo);
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:userInfo[@"uid"],@"b_code",nil];
        [RequestData thirdLodigSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
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
                        if ([temp isKindOfClass:[IndexController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                }else if([self.type isEqualToString:@"recode"]){
                    //popToViewController
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[IndexController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                }else if([self.type isEqualToString:@"rechare"]){
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
        } andFailure:^(NSError *error) {
            
        }];
    }else{
        NSLog(@"%@",errorMsg);
    }
    
}

#pragma mark 图片下载
-(int) downLoadImageFromURL:(NSString *)fileURL withName:(NSString *)imageName
{
    //Check Image Is Exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * filePath = [DOCUMENT_PATH stringByAppendingPathComponent:imageName];
    filePath = [NSString stringWithFormat:@"%@.jpg", filePath];
    if ([fileManager fileExistsAtPath:filePath])
    {
        return 0;
    }
    
    //Get Image From URL
    UIImage * imageFromURL = [self getImageFromURL:fileURL];
    
    //Save Image to Directory
    [self saveImage:imageFromURL withFileName:imageName ofType:@"jpg" inDirectory:DOCUMENT_PATH];
    
    //Get Document Path All Files
    NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:DOCUMENT_PATH];
    NSLog(@"---- %@",file);
    return -1;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    return [UIImage imageWithData:data];
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
    else
    {
        NSLog(@"文件后缀不认识");
    }
}
/**
 *  判断图片格式
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}
@end
