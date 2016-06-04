//
//  CloudRecordCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/11.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface CloudRecordCell : UITableViewCell
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名*/
@property (weak, nonatomic) IBOutlet ARLabel *nameLabel;
/**用户所在城市*/
@property (weak, nonatomic) IBOutlet ARLabel *cityLabel;
/**参与次数*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**参与时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;

@end
