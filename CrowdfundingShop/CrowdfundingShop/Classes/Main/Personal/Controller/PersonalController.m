//
//  PersonalController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "PersonalController.h"
#import "ARLabel.h"
#import "SeetingController.h"
#import "AccountTool.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
@interface PersonalController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/**未登陆*/
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (weak, nonatomic) IBOutlet UIView *weidengluView;

/**已登陆*/
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *yidengluView;

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
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    //判断是否有登录
    [self flagLogin];
}
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
    [rightBtn addTarget:self action:@selector(seetingClick) forControlEvents:UIControlEventTouchUpInside];
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
-(void)shopCartNum{
    [RequestData shopCartNum:nil FinishCallbackBlock:^(NSDictionary *data) {
        
    }];
}
/**
 *  判断是否有登录
 */
-(void)flagLogin
{
    //沙盒路径
    AccountModel *account=[AccountTool account];
    if(account)
    {
        [self shopCartNum];
        self.loginView.hidden=NO;
        self.yidengluView.hidden=NO;
        self.noLoginView.hidden=YES;
        self.weidengluView.hidden=YES;
        self.userPhoneLabel.text=account.username;
        self.experienceLabel.text=account.jingyan;
        self.scoreLabel.text=account.score;
        self.moneyLabel.text=account.money;
        self.gradesLabel.text=account.yungoudj;
        //拼接图片网址·
        NSString *urlStr =[NSString stringWithFormat:@"%@%@",imgURL,account.img];
        //转换成url
        NSURL *imgUrl = [NSURL URLWithString:urlStr];
        [self.userImageView sd_setImageWithURL:imgUrl];
    }else
    {
        self.loginView.hidden=YES;
        self.yidengluView.hidden=YES;
        self.noLoginView.hidden=NO;
        self.weidengluView.hidden=NO;
    }
}

-(void)seetingClick{
    //设置故事板为第一启动
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SeetingController *seetingController=[storyboard instantiateViewControllerWithIdentifier:@"SeetingView"];
    [self.navigationController pushViewController:seetingController animated:YES];
}

@end
