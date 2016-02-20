//
//  InvitationRecordCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/17.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface InvitationRecordCell : UITableViewCell
/**用户名*/
@property (weak, nonatomic) IBOutlet UIButton *userButton;
/**时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**邀请编码*/
@property (weak, nonatomic) IBOutlet ARLabel *codeLabel;
/**状态*/
@property (weak, nonatomic) IBOutlet ARLabel *stateLabel;
@end
