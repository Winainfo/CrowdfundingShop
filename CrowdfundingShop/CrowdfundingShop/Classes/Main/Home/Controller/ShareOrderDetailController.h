//
//  ShareOrderDetailController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface ShareOrderDetailController : UIViewController
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
/**奖励福分*/
@property (weak, nonatomic) IBOutlet ARLabel *scoreLabel;
/**购买次数*/
@property (weak, nonatomic) IBOutlet ARLabel *buyNumLabel;
/**商品名称*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
@end
