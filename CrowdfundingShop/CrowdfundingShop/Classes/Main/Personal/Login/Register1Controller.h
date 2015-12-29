//
//  Register1Controller.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register1Controller : UIViewController
/**手机号码*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**下一步按钮*/
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
/**选择框*/
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
