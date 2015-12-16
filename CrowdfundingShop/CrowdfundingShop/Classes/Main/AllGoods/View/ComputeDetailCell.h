//
//  ComputeDetailCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/13.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface ComputeDetailCell : UITableViewCell
/**云购时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**转换数据*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**用户名*/
@property (weak, nonatomic) IBOutlet ARLabel *peopleNameLabel;
@end
