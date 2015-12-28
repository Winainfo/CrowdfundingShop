//
//  PersonalController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "PersonalController.h"
#import "ARLabel.h"
@interface PersonalController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
/**用户帐号*/
@property (weak, nonatomic) IBOutlet ARLabel *userPhoneLabel;
/**用户等级照片*/
@property (weak, nonatomic) IBOutlet UIImageView *gradesImageView;
/**等级名称*/
@property (weak, nonatomic) IBOutlet ARLabel *gradesLabel;
/**经验值*/
@property (weak, nonatomic) IBOutlet ARLabel *experienceLabel;
/**可用积分*/
@property (weak, nonatomic) IBOutlet ARLabel *scoreLabel;
/**可用余额*/
@property (weak, nonatomic) IBOutlet ARLabel *moneyLabel;
/**充值按钮*/
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;

@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"我的夺宝";
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"MyCloud_setting_select"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"MyCloud_setting_select"] forState:UIControlStateSelected];
    rightBtn.frame=CGRectMake(-5, 5, 21, 21);
    [rightBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    /**圆角*/
    self.loginBtn.layer.cornerRadius=2.0;
    self.loginBtn.layer.masksToBounds=YES;
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.height/2.0;
    self.userImageView.layer.masksToBounds=YES;
    self.rechargeBtn.layer.cornerRadius=2.0;
    self.rechargeBtn.layer.masksToBounds=YES;
}

-(void)searchClick{
    
}

@end
