//
//  ConsumeCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface ConsumeCell : UITableViewCell
/**充值时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**充值渠道*/
@property (weak, nonatomic) IBOutlet ARLabel *channelLabel;
/**充值金额*/
@property (weak, nonatomic) IBOutlet ARLabel *moneyLabel;

@end
