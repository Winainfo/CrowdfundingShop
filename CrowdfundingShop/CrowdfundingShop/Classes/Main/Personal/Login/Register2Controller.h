//
//  Register2Controller.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register2Controller : UIViewController
/**下一步*/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (retain,nonatomic) NSString *uid;
@property (retain,nonatomic) NSString *mobile;
@end
