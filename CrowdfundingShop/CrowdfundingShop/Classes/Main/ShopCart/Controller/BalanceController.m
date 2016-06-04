//
//  BalanceController.m
//  CrowdfundingShop
//  结算
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceController.h"
#import "AccountTool.h"
#import "RequestData.h"
#import <MBProgressHUD.h>
#import "CartModel.h"
#import "Database.h"
#import "RechargeServiceController.h"
#import "ResultController.h"
#import <CommonCrypto/CommonDigest.h>
#import "WechatPayManager.h"
@interface BalanceController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
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
@property (weak, nonatomic) IBOutlet ARLabel *scoreTextLabel;
@property (weak, nonatomic) IBOutlet ARLabel *moneyTextLabel;
/**支付类型1.代表积分，2.代表余额 3.代表微信支付 4.代表支付宝 */
@property (assign,nonatomic) int type;

@property (weak, nonatomic) IBOutlet UIButton *yunBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (assign,nonatomic) int codeStr;

@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *wxPayView;

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
    [RequestData hideShowView:nil FinishCallbackBlock:^(NSDictionary *data) {
         int code=[data[@"code"] intValue];
        if (code==0) {
            self.payView.hidden=YES;
            self.wxPayView.frame=CGRectMake(0, 128, kScreenWidth, 124);
            self.payView.frame=CGRectMake(0, 252, kScreenWidth, 96);
        }else{
            self.payView.hidden=NO;
        }
    } andFailure:^(NSError *error) {
        
    }];
    
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
        self.wxBtn.hidden=YES;
        self.type=4;
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
        self.moneyTextLabel.text=@"余额支付";
        self.type=1;
         self.yunBtn.hidden=YES;
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
        self.type=2;
        self.yunBtn.hidden=YES;
    }else if([account.money intValue]<=0){
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
    }else{
        self.shenyuPrice.text=@"¥0.0";
        [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
        [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
        self.moneyTextLabel.text=[NSString stringWithFormat:@"可使用余额支付¥%0.2f",[account.money floatValue]];
        self.type=2;
        self.yunBtn.hidden=YES;
    }
}
/**
 *  云支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)yunPayClick:(UIButton *)sender {
    self.shenyuPrice.text=[NSString stringWithFormat:@"¥%@",self.sumPrice];
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    self.moneyTextLabel.text=@"余额支付";
    self.yunBtn.hidden=NO;
    self.wxBtn.hidden=YES;
    self.type=3;
}
/**
 *  微信支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)wxPayClick:(UIButton *)sender {
    self.shenyuPrice.text=[NSString stringWithFormat:@"¥%@",self.sumPrice];
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    self.moneyTextLabel.text=@"余额支付";
    self.wxBtn.hidden=NO;
    self.yunBtn.hidden=YES;
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
        case 3:{//云支付
            AccountModel *account=[AccountTool account];
            NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.sumPrice,@"money",@"appyunpay",@"type",nil];
            [RequestData rechargeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
                NSLog(@"---%@",data);
                int code=[data[@"code"] intValue];
                if (code==0) {
                    [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:data[@"content"]]];
                    //注册通知
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YunPayResult:) name:@"YunPayNotification" object:nil];
                }
            } andFailure:^(NSError *error) {
                //声明对象
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
                //显示的文本；
                hud.labelText = @"支付异常";
                hud.removeFromSuperViewOnHide = true;
                hud.mode=MBProgressHUDModeText;
                [hud hide:true afterDelay:0.5];
            }];

        }break;
        case 4:{
            NSString *nonce_str=[self getNonceStr:[NSString stringWithFormat:@"%d",arc4random()%10000]];
            nonce_str=[nonce_str uppercaseString];
            WechatPayManager *wxPayManager=[WechatPayManager new];
            NSString *price=[NSString stringWithFormat:@"%d",[self.sumPrice intValue]*100];
            [wxPayManager getWeChatPayWithOrderName:@"1元商城" price:price];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(result:) name:@"HUDDismissNotification" object:nil];
        }break;
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
    self.codeStr=[data.userInfo[@"code"] intValue];
    Database *db=[[Database alloc]init];
     AccountModel *account=[AccountTool account];
    if (self.codeStr==0) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.jsonStr,@"shop",nil];
        [RequestData WxPaySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            if (code==0) {
                [db deleteDataList];
                //设置故事板为第一启动
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ResultController *controller=[storyboard instantiateViewControllerWithIdentifier:@"resultView"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{}
        } andFailure:^(NSError *error) {
        }];
    }else{
        //声明对象
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"支付失败";
        hud.removeFromSuperViewOnHide = true;
        hud.mode=MBProgressHUDModeText;
        [hud hide:true afterDelay:0.5];
    }
}
/**
 *  云支付 回调
 *
 *  @param data <#data description#>
 */
- (void)YunPayResult:(NSNotification *)data{
    self.codeStr=[data.userInfo[@"code"] intValue];
    Database *db=[[Database alloc]init];
    AccountModel *account=[AccountTool account];
    if (self.codeStr==0) {
        NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.jsonStr,@"shop",nil];
        [RequestData moneyPaySerivce:params FinishCallbackBlock:^(NSDictionary *data) {
            int code=[data[@"code"] intValue];
            if (code==0) {
                [db deleteDataList];
//                int money=[account.money intValue];
//                money=money-[self.sumPrice intValue];
//                account.money=[NSString stringWithFormat:@"%d",money];
//                [AccountTool saveAccount:account];
                //设置故事板为第一启动
                UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ResultController *controller=[storyboard instantiateViewControllerWithIdentifier:@"resultView"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{}
        } andFailure:^(NSError *error) {
        }];
    }else{
        //声明对象
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        //显示的文本；
        hud.labelText = @"支付失败";
        hud.removeFromSuperViewOnHide = true;
        hud.mode=MBProgressHUDModeText;
        [hud hide:true afterDelay:0.5];
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
/**
 *  获得md5加密后的字符串
 *
 *  @param method <#method description#>
 *  @param data   <#data description#>
 *  @param appid  <#appid description#>
 *  @param appkey <#appkey description#>
 *
 *  @return <#return value description#>
 */
-(NSString*) getMD5StrMethod:(NSString*) method andData:(NSString*) data andAppKey:(NSString*) appkey
{
    //设置需要加密的字符串
    NSMutableString * str = [NSMutableString stringWithCapacity:3];
    [str appendString:method];
    [str appendString:data];
    [str appendString:appkey];
    
    //去除空格和\n
    NSString *resString =
    [[str stringByReplacingOccurrencesOfString:@" " withString:@""]
     stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    const char *cStr = [resString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/**
 *  字典转字符串工具类
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
-(NSString*)getJsonStr:(NSDictionary*)dic{
    NSError *error = nil;
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}
- (void) showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:YES];
    });
}

@end
