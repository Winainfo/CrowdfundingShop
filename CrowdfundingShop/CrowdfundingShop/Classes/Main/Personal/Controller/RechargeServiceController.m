//
//  RechargeServiceController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/18.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "RechargeServiceController.h"
#import "AccountTool.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "RequestData.h"
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
/**确认*/
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
/**支付类型 1.微信 2.支付宝*/
@property (assign,nonatomic) int type;
/**金额*/
@property (retain,nonatomic) NSString *money;
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
    self.yunPayButton.hidden=NO;
    self.type=1;
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
 *  微信支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)yunPayClick:(id)sender {
    self.yunPayButton.hidden=NO;
    self.type=1;
}
/**
 *  支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payClick:(UIButton *)sender {
    NSString *price=@"";
    if ([self.money isEqualToString:@""]) {
        price=[NSString stringWithFormat:@"%@",self.moenyTextField.text];
    }else{
        price=self.money;
    }
    switch (self.type) {
        case 1:{//云支付
            [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:@"http://pay.yunpay.net.cn/i2eorder/yunpay/?sing=hCB9W9H8CNWm%2BErFbsI9y7xOmBoIe%2FsX9cM" ]];
        }break;

        default:
            break;
    }
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
