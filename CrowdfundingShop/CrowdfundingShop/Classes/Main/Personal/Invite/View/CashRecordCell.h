//
//  CashRecordCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/17.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface CashRecordCell : UITableViewCell
/**时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**银行信息*/
@property (weak, nonatomic) IBOutlet ARLabel *infoLabel;
/**提现金额*/
@property (weak, nonatomic) IBOutlet ARLabel *moneyLabel;
/**手续费*/
@property (weak, nonatomic) IBOutlet ARLabel *priceLabel;
/**审核状态*/
@property (weak, nonatomic) IBOutlet ARLabel *stateLabel;

@end
