//
//  BalanceController.h
//  CrowdfundingShop
//  结算
//  Created by 吴金林 on 15/12/28.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface BalanceController : UIViewController
/**总数量*/
@property (retain,nonatomic)NSString *sumNum;
/**总价格*/
@property (retain,nonatomic)NSString *sumPrice;
/**商品信息*/
@property(retain,nonatomic)NSString *jsonStr;
@end
