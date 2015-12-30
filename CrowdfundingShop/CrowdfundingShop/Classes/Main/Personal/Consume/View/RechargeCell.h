//
//  RechargeCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface RechargeCell : UITableViewCell
/**消费时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**消费金额*/
@property (weak, nonatomic) IBOutlet ARLabel *moneyLabel;

@end
