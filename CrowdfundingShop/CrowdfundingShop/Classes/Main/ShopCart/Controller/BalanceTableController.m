//
//  BalanceTableController.m
//  CrowdfundingShop
//  结算表
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceTableController.h"
#import "AccountTool.h"
#import "BalanceController.h"
@interface BalanceTableController ()
/**商品数量*/
@property (weak, nonatomic) IBOutlet ARLabel *countLabel;
/**商品价格*/
@property (weak, nonatomic) IBOutlet ARLabel *PriceLabel;
/**剩余价格*/
@property (weak, nonatomic) IBOutlet UILabel *shenyuPrice;
/**积分*/
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
/**余额*/
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

/**支付类型1.代表积分，2.代表余额 3.代表微信支付 4.代表支付宝 */
@property (assign,nonatomic) int type;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation BalanceTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.type=0;
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
        self.type=2;
        int money=[self.sumPrice intValue]-[account.money intValue];
        if (money>0) {
            self.shenyuPrice.text=[NSString stringWithFormat:@"¥%d",money];
        }else{
             self.shenyuPrice.text=@"¥0.0";
        }
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
    self.type=1;
}
/**
 *   余额支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)moneyClick:(UIButton *)sender {
    [self.scoreBtn setImage:[UIImage imageNamed:@"pay_way_unselect"] forState:UIControlStateNormal];
    [self.moneyBtn setImage:[UIImage imageNamed:@"pay_way_select"] forState:UIControlStateNormal];
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
    self.type=4;
}

-(void)payClick{
    NSLog(@"++++++");
    switch (self.type) {
        case 1:{
            NSLog(@"积分支付");
        }break;
        case 2:{
            NSLog(@"余额支付");
        }break;
        case 3:{
            NSLog(@"微信支付");
        }break;
        case 4:{
            NSLog(@"支付宝支付");
        }break;
        default:
            break;
    }
}
@end
