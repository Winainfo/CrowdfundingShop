//
//  RechargeServiceController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/18.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "RechargeServiceController.h"
#import "AccountTool.h"
#import "RequestData.h"
#import "WechatPayManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <MBProgressHUD.h>
@interface RechargeServiceController ()<UITextFieldDelegate>
/**余额*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**50元*/
@property (weak, nonatomic) IBOutlet UIButton *button1;
/**100元*/
@property (weak, nonatomic) IBOutlet UIButton *button2;
/**200元*/
@property (weak, nonatomic) IBOutlet UIButton *button3;
/**500元*/
@property (weak, nonatomic) IBOutlet UIButton *button4;
/**1000元*/
@property (weak, nonatomic) IBOutlet UIButton *button5;
/**金额文本*/
@property (weak, nonatomic) IBOutlet UITextField *moenyTextField;
/**云支付*/
@property (weak, nonatomic) IBOutlet UIButton *yunPayButton;
/***微信支付*/
@property (weak, nonatomic) IBOutlet UIButton *wxPayButton;

/**确认*/
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
/**支付类型 1.微信 2.支付宝*/
@property (assign,nonatomic) int type;
/**金额*/
@property (retain,nonatomic) NSString *money;

@property (retain,nonatomic) NSString *price;
@end

@implementation RechargeServiceController
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
    self.title=@"充值";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    self.moenyTextField.delegate=self;
    [self initStyle];
    self.wxPayButton.hidden=NO;
    self.type=2;
    self.money=@"50";
    //50
    self.button1.layer.borderWidth=2.0;
    self.button1.layer.cornerRadius=5.0;
    self.button1.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
    AccountModel *accout=[AccountTool account];
    self.moneyLabel.text=accout.money;
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  控件样式
 */
-(void)initStyle{
    //确定按钮
    self.confirmButton.layer.cornerRadius=5.0;
    //50
    self.button1.layer.borderWidth=1.0;
    self.button1.layer.cornerRadius=5.0;
    self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //100
    self.button2.layer.borderWidth=1.0;
    self.button2.layer.cornerRadius=5.0;
    self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //200
    self.button3.layer.borderWidth=1.0;
    self.button3.layer.cornerRadius=5.0;
    self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //500
    self.button4.layer.borderWidth=1.0;
    self.button4.layer.cornerRadius=5.0;
    self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //1000
    self.button5.layer.borderWidth=1.0;
    self.button5.layer.cornerRadius=5.0;
    self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
}
/**
 *  金额选择
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selectClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    self.moenyTextField.text=@"";
    switch (btn.tag) {
        case 100:{
            self.money=@"50";
            //50
            self.button1.layer.borderWidth=2.0;
            self.button1.layer.cornerRadius=5.0;
            self.button1.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
            //100
            self.button2.layer.borderWidth=1.0;
            self.button2.layer.cornerRadius=5.0;
            self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //200
            self.button3.layer.borderWidth=1.0;
            self.button3.layer.cornerRadius=5.0;
            self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //500
            self.button4.layer.borderWidth=1.0;
            self.button4.layer.cornerRadius=5.0;
            self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button5.layer.borderWidth=1.0;
            self.button5.layer.cornerRadius=5.0;
            self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
        }break;
        case 101:{
            self.money=@"100";
            //50
            self.button1.layer.borderWidth=1.0;
            self.button1.layer.cornerRadius=5.0;
            self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button2.layer.borderWidth=2.0;
            self.button2.layer.cornerRadius=5.0;
            self.button2.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
            //200
            self.button3.layer.borderWidth=1.0;
            self.button3.layer.cornerRadius=5.0;
            self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //500
            self.button4.layer.borderWidth=1.0;
            self.button4.layer.cornerRadius=5.0;
            self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button5.layer.borderWidth=1.0;
            self.button5.layer.cornerRadius=5.0;
            self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
        }break;
        case 102:{
            self.money=@"200";
            //50
            self.button1.layer.borderWidth=1.0;
            self.button1.layer.cornerRadius=5.0;
            self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button2.layer.borderWidth=1.0;
            self.button2.layer.cornerRadius=5.0;
            self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //200
            self.button3.layer.borderWidth=2.0;
            self.button3.layer.cornerRadius=5.0;
            self.button3.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
            //500
            self.button4.layer.borderWidth=1.0;
            self.button4.layer.cornerRadius=5.0;
            self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button5.layer.borderWidth=1.0;
            self.button5.layer.cornerRadius=5.0;
            self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
        }break;
        case 103:{
            self.money=@"500";
            //50
            self.button1.layer.borderWidth=1.0;
            self.button1.layer.cornerRadius=5.0;
            self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button2.layer.borderWidth=1.0;
            self.button2.layer.cornerRadius=5.0;
            self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //200
            self.button3.layer.borderWidth=1.0;
            self.button3.layer.cornerRadius=5.0;
            self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //500
            self.button4.layer.borderWidth=2.0;
            self.button4.layer.cornerRadius=5.0;
            self.button4.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
            //100
            self.button5.layer.borderWidth=1.0;
            self.button5.layer.cornerRadius=5.0;
            self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
        }break;
        case 104:{
            self.money=@"1000";
            //50
            self.button1.layer.borderWidth=1.0;
            self.button1.layer.cornerRadius=5.0;
            self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button2.layer.borderWidth=1.0;
            self.button2.layer.cornerRadius=5.0;
            self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //200
            self.button3.layer.borderWidth=1.0;
            self.button3.layer.cornerRadius=5.0;
            self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //500
            self.button4.layer.borderWidth=1.0;
            self.button4.layer.cornerRadius=5.0;
            self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
            //100
            self.button5.layer.borderWidth=2.0;
            self.button5.layer.cornerRadius=5.0;
            self.button5.layer.borderColor=[[UIColor colorWithRed:231.0/255.0 green:57.0/255.0 blue:91.0/255.0 alpha:1.0]CGColor];
        }break;
        default:
            break;
    }
    
}
/**
 *  云支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)yunPayClick:(id)sender {
    self.yunPayButton.hidden=NO;
    self.wxPayButton.hidden=YES;
    self.type=1;
}
/**
 *  微信支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)wxPayClick:(id)sender {
    self.wxPayButton.hidden=NO;
    self.yunPayButton.hidden=YES;
    self.type=2;
}

/**
 *  支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payClick:(UIButton *)sender {
    self.price=@"";
    if ([self.money isEqualToString:@""]) {
        self.price=[NSString stringWithFormat:@"%@",self.moenyTextField.text];
    }else{
        self.price=self.money;
    }
    switch (self.type) {
        case 1:{//云支付
              AccountModel *account=[AccountTool account];
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.price,@"money",@"appyunpay",@"type",nil];
            [RequestData rechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                NSLog(@"---%@",data);
                int code=[data[@"code"] intValue];
                if (code==0) {
                      [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:data[@"content"]]];
                    //注册通知
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YunPayResult:) name:@"YunPayNotification" object:nil];
                }
            } andFailure:^(NSError *error) {
                
            }];
        }break;
        case 2:{ //微信充值
            NSString *nonce_str=[self getNonceStr:[NSString stringWithFormat:@"%d",arc4random()%10000]];
            nonce_str=[nonce_str uppercaseString];
            WechatPayManager *wxPayManager=[WechatPayManager new];
            NSString *price1=[NSString stringWithFormat:@"%d",[self.price intValue]*100];
            [wxPayManager getWeChatPayWithOrderName:@"1元商城" price:price1];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(result:) name:@"HUDDismissNotification" object:nil];
        }
        default:
            break;
    }
}
#pragma mark 监听通知
/**
 *  微信支付 回调
 *
 *  @param data <#data description#>
 */
- (void)result:(NSNotification *)data{
    int codeStr=[data.userInfo[@"code"] intValue];
    AccountModel *account=[AccountTool account];
    if (codeStr==0) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.price,@"money",@"wxpay_web",@"type",nil];
        [RequestData rechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            if (code==0) {
                //然后显示一个成功的提示；
                MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                successHUD.labelText = @"充值成功";
                successHUD.mode = MBProgressHUDModeCustomView;
                //可以设置对应的图片；
                successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
                successHUD.removeFromSuperViewOnHide = true;
                [successHUD hide:true afterDelay:1];
                int a_money=[account.money intValue];
                int b_money=[self.price intValue];
                account.money=[NSString stringWithFormat:@"%i",a_money+b_money];
                self.moneyLabel.text=[NSString stringWithFormat:@"%i",a_money+b_money];
                [AccountTool saveAccount:account];
            }
        } andFailure:^(NSError *error) {
            
        }];
    }else{
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"充值失败";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }
}
/**
 *  云支付 回调
 *
 *  @param data <#data description#>
 */
- (void)YunPayResult:(NSNotification *)data{
   int codeStr=[data.userInfo[@"code"] intValue];
    AccountModel *account=[AccountTool account];
    if (codeStr==0) {
        int a_money=[account.money intValue];
        int b_money=[self.price intValue];
        account.money=[NSString stringWithFormat:@"%i",a_money+b_money];
        self.moneyLabel.text=[NSString stringWithFormat:@"%i",a_money+b_money];
        [AccountTool saveAccount:account];
        //然后显示一个成功的提示；
        MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        successHUD.labelText = @"充值成功";
        successHUD.mode = MBProgressHUDModeCustomView;
        //可以设置对应的图片；
        successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
        successHUD.removeFromSuperViewOnHide = true;
        [successHUD hide:true afterDelay:1];

    }else{
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"充值异常";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
    }
}
/**
 *  生成NonceStr
 *
 *  @param inPutText <#inPutText description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)getNonceStr:(NSString *)inPutText{
    const char *cStr=[inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    //50
    self.button1.layer.borderWidth=1.0;
    self.button1.layer.cornerRadius=5.0;
    self.button1.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //100
    self.button2.layer.borderWidth=1.0;
    self.button2.layer.cornerRadius=5.0;
    self.button2.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //200
    self.button3.layer.borderWidth=1.0;
    self.button3.layer.cornerRadius=5.0;
    self.button3.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //500
    self.button4.layer.borderWidth=1.0;
    self.button4.layer.cornerRadius=5.0;
    self.button4.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    //1000
    self.button5.layer.borderWidth=1.0;
    self.button5.layer.cornerRadius=5.0;
    self.button5.layer.borderColor=[[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0]CGColor];
    self.money=@"";
    return YES;
}
@end
