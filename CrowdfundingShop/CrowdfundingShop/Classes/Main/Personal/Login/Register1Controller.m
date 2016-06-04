//
//  Register1Controller.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "Register1Controller.h"
#import "RequestData.h"
#import "Register2Controller.h"
@interface Register1Controller ()<UITextFieldDelegate>
@property (assign,nonatomic) BOOL flag;
@end

@implementation Register1Controller
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
    self.title=@"注册";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**圆角*/
    self.nextBtn.layer.cornerRadius=2.0;
    self.nextBtn.layer.masksToBounds=YES;
    //监听文本输入框的改变
    //1.拿到通知中心
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    //2.注册监听
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    _flag=NO;
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
    if (self.phoneTextField.text.length>0) {
        //改变btn背景颜色
         self.nextBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
        //改变字体颜色
         [self.nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
        //开启交互
       self.nextBtn.userInteractionEnabled=YES;
        
    }else if (self.phoneTextField.text.length<1)
    {
        self.nextBtn.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [self.nextBtn.titleLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
        self.nextBtn.userInteractionEnabled=NO;
    }
}


- (IBAction)selectClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"login_protocal_select"] forState:UIControlStateNormal];
                self.nextBtn.backgroundColor=[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1];
                [self.nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
                self.nextBtn.userInteractionEnabled=YES;
                _flag=NO;
            }else{
                [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"login_protocal_unselect"] forState:UIControlStateNormal];
                self.nextBtn.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
                [self.nextBtn.titleLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
                self.nextBtn.userInteractionEnabled=NO;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }

}
- (IBAction)nextRegister:(id)sender {
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"user",nil];
    [RequestData checkName:params FinishCallbackBlock:^(NSDictionary *data) {
        NSLog(@"%@",data);
        int code=[data[@"content"][@"state"] intValue];
        if(code==0){
            [RequestData getCodeSerivce:params FinishCallbackBlock:^(NSDictionary *json) {
                int code1=[json[@"code"] intValue];
                NSLog(@"验证码：%@",json);
                if (code1==0) {
                    //设置故事板为第一启动
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    Register2Controller *controller=[storyboard instantiateViewControllerWithIdentifier:@"register2View"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            } andFailure:^(NSError *error) {
                
            }];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"改手机号码已被注册"preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

/**
 *  正则判断手机号码地址格式
 *
 *  @param BOOL <#BOOL description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
