//
//  VerifyPhoneController1.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/5.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "VerifyPhoneController1.h"
#import "RequestData.h"
#import "ARLabel.h"
@interface VerifyPhoneController1 ()
/**手机号*/
@property (weak, nonatomic) IBOutlet ARLabel *phoneLabel;
/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *verifyNumTextField;
/**确定按钮*/
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation VerifyPhoneController1

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
    self.title=@"绑定手机";
    //导航栏右侧按钮
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateSelected];
    leftBtn.frame=CGRectMake(-5, 5, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    self.saveBtn.layer.cornerRadius=4.0;
    self.saveBtn.layer.masksToBounds=YES;
     self.phoneLabel.text=self.phone;
    NSString *phoneString = [self.phoneLabel.text substringWithRange:NSMakeRange(5,4)];
    self.phoneLabel.text=[self.phoneLabel.text stringByReplacingOccurrencesOfString:phoneString withString:@"****"];
   
}
/**
 *  返回
 */
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取验证码
/**
 *  获取验证码
 *
 *  @param sender <#sender description#>
 */
- (IBAction)getCodeClick:(id)sender {
    [self getCode:self.uid andMobile:self.phone];
}

/**
 *  请求
 *
 *  @param uid    <#uid description#>
 *  @param mobile <#mobile description#>
 */
-(void)getCode:(NSString *)uid andMobile:(NSString *)mobile{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",mobile,@"mobile",nil];
    [RequestData getMobileCodeSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        NSLog(@"结果:%@",data);
    } andFailure:^(NSError *error) {
        NSLog(@"错误:%@",error);
    }];
}

@end
