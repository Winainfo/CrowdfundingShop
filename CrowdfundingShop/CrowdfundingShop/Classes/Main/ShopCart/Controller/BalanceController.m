//
//  BalanceController.m
//  CrowdfundingShop
//  结算
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceController.h"
#import "AccountTool.h"
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "AlipayHelper.h"
#import "RequestData.h"
#import <MBProgressHUD.h>
#import "CartModel.h"
#import "Database.h"
#import "RechargeServiceController.h"
#import "ResultController.h"
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
    //沙盒路径
    AccountModel *account=[AccountTool account];
    int score=[account.score intValue];
    if (score>=100) {
        [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
        [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
        self.wxPayBtn.hidden=YES;
        self.aliPayBtn.hidden=YES;
        self.moneyTextLabel.text=@"余额支付";
        self.type=1;
    }else{
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的福分不足，加油赚取福分吧" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }

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
    if (money>1) {
        self.shenyuPrice.text=[NSString stringWithFormat:@"¥%d",money];
        [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
        [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
        self.moneyTextLabel.text=[NSString stringWithFormat:@"可使用余额支付¥%0.2f",[account.money floatValue]];
        self.wxPayBtn.hidden=YES;
        self.aliPayBtn.hidden=YES;
        self.type=2;
    }else{
        self.shenyuPrice.text=@"¥0.0";
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的余额不足快去充值吧" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //设置故事板为第一启动
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RechargeServiceController *controller=[storyboard instantiateViewControllerWithIdentifier:@"RechargeService"];
            [self.navigationController pushViewController:controller animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
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
    //沙盒路径
    AccountModel *account=[AccountTool account];
    Database *db=[[Database alloc]init];
    switch (self.type) {
        case 1:{//积分支付
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您确定使用福分支付?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            //声明对象；
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            //显示的文本；
            hud.labelText = @"正在提交...";
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0.5];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.jsonStr,@"shop",nil];
                [RequestData ScorePaySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                    int code=[data[@"code"] intValue];
                    if (code==0) {
                        //加载成功，先移除原来的HUD；
                        hud.removeFromSuperViewOnHide = true;
                        [hud hide:true afterDelay:0];
                        //然后显示一个成功的提示；
                        MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                        successHUD.labelText = @"支付成功";
                        successHUD.mode = MBProgressHUDModeCustomView;
                        //可以设置对应的图片；
                        successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
                        successHUD.removeFromSuperViewOnHide = true;
                        [successHUD hide:true afterDelay:1];
                        [db deleteDataList];
                        int score=[account.score intValue];//账户余额
                        int price=[self.sumPrice intValue]*100;//消费金额
                        account.score=[NSString stringWithFormat:@"%d",score-price];
                        [AccountTool saveAccount:account];
                        //设置故事板为第一启动
                        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ResultController *controller=[storyboard instantiateViewControllerWithIdentifier:@"resultView"];
                        [self.navigationController pushViewController:controller animated:YES];

                    }else{
                        
                    }
                } andFailure:^(NSError *error) {
                    hud.removeFromSuperViewOnHide = true;
                    [hud hide:true afterDelay:0];
                    //显示失败的提示；
                    MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    failHUD.labelText = @"支付失败";
                    failHUD.mode = MBProgressHUDModeCustomView;
                    failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
                    failHUD.removeFromSuperViewOnHide = true;
                    [failHUD hide:true afterDelay:1];
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                hud.removeFromSuperViewOnHide = true;
                [hud hide:true afterDelay:0.5];
            }]];
            [self presentViewController:alert animated:YES completion:^{
            }];
        }break;
        case 2:{//余额支付
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您确定使用余额支付?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            //声明对象；
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            //显示的文本；
            hud.labelText = @"正在提交...";
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0.5];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.jsonStr,@"shop",nil];
                [RequestData moneyPaySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                    int code=[data[@"code"] intValue];
                    NSLog(@"%@",data);
                    if (code==0) {
                        //加载成功，先移除原来的HUD；
                        hud.removeFromSuperViewOnHide = true;
                        [hud hide:true afterDelay:0];
                        //然后显示一个成功的提示；
                        MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                        successHUD.labelText = @"支付成功";
                        successHUD.mode = MBProgressHUDModeCustomView;
                        //可以设置对应的图片；
                        successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
                        successHUD.removeFromSuperViewOnHide = true;
                        [successHUD hide:true afterDelay:1];
                        [db deleteDataList];
                        int money=[account.money intValue];//账户余额
                        int price=[self.sumPrice intValue];//消费金额
                        account.money=[NSString stringWithFormat:@"%d",money-price];
                        [AccountTool saveAccount:account];
                        //设置故事板为第一启动
                        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ResultController *controller=[storyboard instantiateViewControllerWithIdentifier:@"resultView"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        
                    }
                } andFailure:^(NSError *error) {
                    hud.removeFromSuperViewOnHide = true;
                    [hud hide:true afterDelay:0];
                    //显示失败的提示；
                    MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                    failHUD.labelText = @"支付失败";
                    failHUD.mode = MBProgressHUDModeCustomView;
                    failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
                    failHUD.removeFromSuperViewOnHide = true;
                    [failHUD hide:true afterDelay:1];
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                hud.removeFromSuperViewOnHide = true;
                [hud hide:true afterDelay:0.5];
            }]];
            [self presentViewController:alert animated:YES completion:^{
            }];

        }break;
        case 3:{//微信支付
            //这里调用我自己写的catagoary中的方法，方法里集成了微信支付的步骤，并会发送一个通知，用来传递是否支付成功的信息
            //这里填写的两个参数是后台会返回给你的
            [self payTheMoneyUseWeChatPayWithPrepay_id:@"这里填写后台返回的Prepay_id" nonce_str:@"这里填写后台给你返回的nonce_str"];
            //所以这里添加一个监听，用来接收是否成功的消息
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];
        }break;
        case 4:{//支付宝
            NSDictionary *dict = @{@"tradeNO":[self generateTradeNO],@"productName":@"购买商品",@"productDescription":@"可大可小",@"amount":self.sumPrice};
            
            [AlipayHelper orderDetialInfo:dict Success:^{
              NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.jsonStr,@"shop",nil];
                [RequestData AliPaySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                    int code=[data[@"code"] intValue];
                    if (code==0) {
                        //声明对象；
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                        hud.mode=MBProgressHUDModeText;
                        //显示的文本；
                        hud.labelText = @"支付成功";
                        hud.removeFromSuperViewOnHide = true;
                        [hud hide:true afterDelay:1];
                        [db deleteDataList];
                        //设置故事板为第一启动
                        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ResultController *controller=[storyboard instantiateViewControllerWithIdentifier:@"resultView"];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                } andFailure:^(NSError *error) {
                    
                }];
            } Failure:^{
                //声明对象；
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                hud.mode=MBProgressHUDModeText;
                //显示的文本；
                hud.labelText = @"支付失败";
                hud.removeFromSuperViewOnHide = true;
                [hud hide:true afterDelay:1];
            } Ispaying:^{
                NSLog(@"没有支付");
            }];
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
        NSLog(@"支付成功");
        //在这里填写支付成功之后你要做的事情
        
    }else{
        [self showMessage:@"支付失败"];
        NSLog(@"支付失败");
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
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

- (void) showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
    });
}

@end
