//
//  BalanceTableController.m
//  CrowdfundingShop
//  结算表
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "BalanceTableController.h"
#import "AccountTool.h"
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

@end

@implementation BalanceTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
#pragma mark 数据
-(void)getData{
    self.countLabel.text=[NSString stringWithFormat:@"%@件",self.sumNum];
    self.PriceLabel.text=[NSString stringWithFormat:@"¥%0.2f",[self.sumPrice floatValue]];
    //沙盒路径
    AccountModel *account=[AccountTool account];
    self.scoreLabel.text=[NSString stringWithFormat:@"您的可用积分为%@",account.score];
    self.balanceLabel.text=[NSString stringWithFormat:@"您的帐号余额为¥%0.2f",[account.money floatValue]];
}

@end
