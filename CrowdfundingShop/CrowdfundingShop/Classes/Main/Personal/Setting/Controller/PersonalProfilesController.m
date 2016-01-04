//
//  PersonalProfilesController.m
//  CrowdfundingShop
//  编辑个人资料
//  Created by 吴金林 on 16/1/4.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "PersonalProfilesController.h"
#import "UpdateNicknameController.h"
@interface PersonalProfilesController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation PersonalProfilesController

//隐藏和显示底部标签栏
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"编辑个人资料";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    [self setExtraCellLineHidden:self.myTableView];
    //头像圆角
    self.userImageView.layer.cornerRadius=self.userImageView.frame.size.height/2.0;
    self.userImageView.layer.masksToBounds=YES;
    
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  去掉多余的分割线
 *
 *  @param tableView <#tableView description#>
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
/**
 *  该方法在视图跳转时被触发
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateNickname"]) {
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userNameLabel.text forKey:@"nickname"];
    }else if ([segue.identifier isEqualToString:@"updateQQNumber"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userQQLabel.text forKey:@"qqNumber"];
    }else if ([segue.identifier isEqualToString:@"updateAutograph"]){
        id theSegue=segue.destinationViewController;
        [theSegue setValue:self.userAutographLabel.text forKey:@"autograph"];
    }
}

@end
