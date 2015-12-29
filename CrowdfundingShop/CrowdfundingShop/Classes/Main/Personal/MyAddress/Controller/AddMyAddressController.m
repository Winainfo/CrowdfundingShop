//
//  AddMyAddressController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AddMyAddressController.h"

@interface AddMyAddressController ()
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (assign,nonatomic) BOOL flag;
@end

@implementation AddMyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题颜色和字体大小UITextAttributeFont:[UIFont fontWithName:@"Heiti TC" size:0.0]
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title=@"添加收货地址";
    //导航栏左侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    //导航栏右侧按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame=CGRectMake(-5, 5, 30, 30);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  设为默认地址
 *
 *  @param sender <#sender description#>
 */
- (IBAction)setClick:(UIButton *)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            if (_flag) {
                [self.setBtn setBackgroundImage:[UIImage imageNamed:@"address_default_select"] forState:UIControlStateNormal];
                _flag=NO;
            }else{
                [self.setBtn setBackgroundImage:[UIImage imageNamed:@"address_default_unselect"] forState:UIControlStateNormal];
                _flag=YES;
            }
            break;
            
        default:
            break;
    }
}

@end
