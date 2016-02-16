//
//  BalanceTableController.h
//  CrowdfundingShop
//  结算表
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface BalanceTableController : UITableViewController
/**总数量*/
@property (retain,nonatomic)NSString *sumNum;
/**总价格*/
@property (retain,nonatomic)NSString *sumPrice;
/**余额btn*/
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
/**积分btn*/
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
/**微信支付*/
@property (weak, nonatomic) IBOutlet UIButton *wxPayBtn;
/**支付宝*/
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;


@end
