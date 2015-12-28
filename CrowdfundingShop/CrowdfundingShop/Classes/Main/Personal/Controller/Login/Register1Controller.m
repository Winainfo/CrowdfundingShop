//
//  Register1Controller.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/29.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "Register1Controller.h"

@interface Register1Controller ()
@property (assign,nonatomic) BOOL flag;
@end

@implementation Register1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"注册";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    /**圆角*/
    self.nextBtn.layer.cornerRadius=2.0;
    self.nextBtn.layer.masksToBounds=YES;
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"login_protocal_select"] forState:UIControlStateNormal];
                self.nextBtn.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:50.0/255.0 blue:84.0/255.0 alpha:1];
                [self.nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
                self.nextBtn.userInteractionEnabled=YES;
                _flag=NO;
            }else{
                [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"login_protocal_unselect"] forState:UIControlStateNormal];
                self.nextBtn.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
                [self.nextBtn.titleLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
                self.nextBtn.userInteractionEnabled=NO;
                _flag=YES;
            }
            break;
            
        default:
            break;
    }

}

@end
