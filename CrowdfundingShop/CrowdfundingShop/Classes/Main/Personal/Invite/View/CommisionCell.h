//
//  CommisionCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/17.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface CommisionCell : UITableViewCell
/**用户*/
@property (weak, nonatomic) IBOutlet UIButton *userButton;
/**时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**内容*/
@property (weak, nonatomic) IBOutlet ARLabel *contentLabel;
/**云购金额*/
@property (weak, nonatomic) IBOutlet ARLabel *priceLabel;
/**佣金*/
@property (weak, nonatomic) IBOutlet ARLabel *commisionLabel;

@end
