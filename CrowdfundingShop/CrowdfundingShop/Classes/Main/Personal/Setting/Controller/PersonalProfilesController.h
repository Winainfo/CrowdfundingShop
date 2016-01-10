//
//  PersonalProfilesController.h
//  CrowdfundingShop
//  编辑个人资料
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"

@interface PersonalProfilesController : UITableViewController
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
/**用户昵称*/
@property (weak, nonatomic) IBOutlet ARLabel *userNameLabel;
/**用户性别*/
@property (weak, nonatomic) IBOutlet ARLabel *userSexLabel;
/**用户生日*/
@property (weak, nonatomic) IBOutlet ARLabel *userBrithdayLabel;
/**用户QQ*/
@property (weak, nonatomic) IBOutlet ARLabel *userQQLabel;
/**居住地*/
@property (weak, nonatomic) IBOutlet ARLabel *userDomicileLabel;
/**家乡*/
@property (weak, nonatomic) IBOutlet ARLabel *userHometownLabel;
/**个性签名*/
@property (weak, nonatomic) IBOutlet ARLabel *userAutographLabel;

@end
