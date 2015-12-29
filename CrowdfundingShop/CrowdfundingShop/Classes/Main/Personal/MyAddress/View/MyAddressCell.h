//
//  MyAddressCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface MyAddressCell : UITableViewCell
/**用户名字*/
@property (weak, nonatomic) IBOutlet ARLabel *userNameLabel;
/**用户电话*/
@property (weak, nonatomic) IBOutlet ARLabel *userPhoneLabel;
/**用户地址*/
@property (weak, nonatomic) IBOutlet ARLabel *userAddressLabel;

@end
