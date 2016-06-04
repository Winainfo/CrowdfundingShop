//
//  AddMyAddressController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMyAddressController : UITableViewController
/**城市*/
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
/**收货人*/
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**手机号码*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**固定电话*/
@property (weak, nonatomic) IBOutlet UITextField *fixPhoneTextField;
/**街道*/
@property (weak, nonatomic) IBOutlet UITextField *stroeTextField;
/**详细地址*/
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
/**邮编*/
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
/**
 0.代表更新
 1.代表插入
 */
@property(retain,nonatomic)NSString *type;
/**地址数组*/
@property (retain,nonatomic)NSDictionary *addressArray;
@end
