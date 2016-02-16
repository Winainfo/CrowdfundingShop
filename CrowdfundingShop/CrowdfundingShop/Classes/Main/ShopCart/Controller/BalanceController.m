//
//  BalanceController.m
//  CrowdfundingShop
//  结算
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceController.h"
#import "BalanceTableController.h"
#import "AccountTool.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
@interface BalanceController ()
/**结算按钮*/
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
/**商品数量*/
@property (weak, nonatomic) IBOutlet ARLabel *countLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *PriceLabel;
/**剩余价格*/
@property (weak, nonatomic) IBOutlet ARLabel *shenyuPrice;
/**积分*/
@property (weak, nonatomic) IBOutlet ARLabel *scoreLabel;
/**余额*/
@property (weak, nonatomic) IBOutlet ARLabel *balanceLabel;
/**余额btn*/
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
/**积分btn*/
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
/**微信支付*/
@property (weak, nonatomic) IBOutlet UIButton *wxPayBtn;
/**支付宝*/
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet ARLabel *scoreTextLabel;
@property (weak, nonatomic) IBOutlet ARLabel *moneyTextLabel;
/**支付类型1.代表积分，2.代表余额 3.代表微信支付 4.代表支付宝 */
@property (assign,nonatomic) int type;
@end

@implementation BalanceController
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
    self.title=@"结算";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 21, 21);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**设置圆角*/
    self.balanceBtn.layer.cornerRadius=4.0;
    self.balanceBtn.layer.masksToBounds=YES;
    
    [self getData];
}
//返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"balanceDetailSegue"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.sumNum forKey:@"sumNum"];
        [theSegue setValue:self.sumPrice forKey:@"sumPrice"];
    }
}
#pragma mark 数据
-(void)getData{
    self.countLabel.text=[NSString stringWithFormat:@"%@件",self.sumNum];
    self.PriceLabel.text=[NSString stringWithFormat:@"¥%0.2f",[self.sumPrice floatValue]];
    //沙盒路径
    AccountModel *account=[AccountTool account];
    self.scoreLabel.text=[NSString stringWithFormat:@"您的可用积分为%@",account.score];
    self.balanceLabel.text=[NSString stringWithFormat:@"您的帐号余额为¥%0.2f",[account.money floatValue]];
    int sum_price=[self.sumPrice intValue];
    int account_money=[account.money intValue];
    if (sum_price<=account_money) {
        [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
        self.moneyTextLabel.text=[NSString stringWithFormat:@"可使用余额支付¥%0.2f",[account.money floatValue]];
        self.type=2;
        int money=[self.sumPrice intValue]-[account.money intValue];
        if (money>0) {
            self.shenyuPrice.text=[NSString stringWithFormat:@"¥%d",money];
        }else{
            self.shenyuPrice.text=@"¥0.0";
        }
    }else{
        self.shenyuPrice.text=[NSString stringWithFormat:@"¥%0.2f",[self.sumPrice floatValue]];
        self.wxPayBtn.hidden=NO;
        self.type=3;
    }
}
/**
 *  积分支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)scoreClick:(UIButton *)sender {
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    self.wxPayBtn.hidden=YES;
    self.aliPayBtn.hidden=YES;
    self.moneyTextLabel.text=@"余额支付";
    self.type=1;
}
/**
 *   余额支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)moneyClick:(UIButton *)sender {
    //沙盒路径
    AccountModel *account=[AccountTool account];
    int money=[self.sumPrice intValue]-[account.money intValue];
    if (money>0) {
        self.shenyuPrice.text=[NSString stringWithFormat:@"¥%d",money];
    }else{
        self.shenyuPrice.text=@"¥0.0";
    }
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
     self.moneyTextLabel.text=[NSString stringWithFormat:@"可使用余额支付¥%0.2f",[account.money floatValue]];
    self.wxPayBtn.hidden=YES;
    self.aliPayBtn.hidden=YES;
    self.type=2;
}
/**
 *  微信支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)wxPayClick:(id)sender {
    self.shenyuPrice.text=[NSString stringWithFormat:@"¥%@",self.sumPrice];
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    self.wxPayBtn.hidden=NO;
    self.aliPayBtn.hidden=YES;
    self.moneyTextLabel.text=@"余额支付";
    self.type=3;
}
/**
 *  支付宝支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)aliPayClick:(id)sender {
    self.shenyuPrice.text=[NSString stringWithFormat:@"¥%@",self.sumPrice];
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    self.wxPayBtn.hidden=YES;
    self.aliPayBtn.hidden=NO;
    self.moneyTextLabel.text=@"余额支付";
    self.type=4;
}
/**
 *  支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payClick:(UIButton *)sender {
    NSLog(@"支付类型:%d",self.type);
    switch (self.type) {
        case 1:{//积分支付
            
        }break;
        case 2:{//余额支付
            
        }break;
        case 3:{//微信支付
            //这里调用我自己写的catagoary中的方法，方法里集成了微信支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
            //这里填写的两个参数是后台会返回给你的
            [self payTheMoneyUseWeChatPayWithPrepay_id:@"这里填写后台返回的Prepay_id" nonce_str:@"这里填写后台给你返回的nonce_str"];
            //所以这里添加一个监听，用来接收是否成功的消息
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
        }break;
        case 4:{//支付宝
            [self payTHeMoneyUseAliPayWithOrderId:@"12343111231" totalMoney:[NSString stringWithFormat:@"%@",self.sumPrice] payTitle:@"这里告诉客户花钱买了啥，力求简短"];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayResultNoti:) name:ALI_PAY_RESULT object:nil];
        }break;
        default:
            break;
    }
}
#pragma mark 支付代理
//微信支付付款成功失败
-(void)weChatPayResultNoti:(NSNotification *)noti{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:IS_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
}


//支付宝支付成功失败
-(void)AliPayResultNoti:(NSNotification *)noti
{
    NSLog(@"%@",noti);
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [self showMessage:@"支付成功"];
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}

- (void) showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
    });
}

@end
