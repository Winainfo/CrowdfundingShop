//
//  AddMyAddressController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/30.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AddMyAddressController.h"
#import "MyAddressController.h"
#import "RequestData.h"
#import "AccountTool.h"
#import "AddressView.h"
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
@interface AddMyAddressController ()<UITextFieldDelegate>
{
    AccountModel *account;
}

@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (assign,nonatomic) BOOL flag;
@property (nonatomic, strong) AddressView *addressView;
@property (nonatomic, strong) UIToolbar *toolBar;
@end

@implementation AddMyAddressController
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
    [rightBtn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    self.cityTextField.delegate=self;
    self.addressView = [[AddressView alloc] init];
    self.cityTextField.inputView = self.addressView;
    self.cityTextField.inputAccessoryView = self.toolBar;
    if (self.addressArray.count>0) {
        self.nameTextField.text=_addressArray[@"shouhuoren"];
        self.phoneTextField.text=_addressArray[@"mobile"];
        self.fixPhoneTextField.text=_addressArray[@"tell"];
        self.addressTextField.text=_addressArray[@"jiedao"];
        self.codeTextField.text=_addressArray[@"youbian"];
    }
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 数据
/**
 *  插入地址
 */
-(void)requestServer{
    account=[AccountTool account];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:account.uid,@"uid",self.addressView.province,@"sheng",self.addressView.city,@"shi",self.addressView.area,@"xian",self.addressTextField.text,@"jiedao",self.codeTextField.text,@"youbian",self.nameTextField.text,@"shouhuoren",self.fixPhoneTextField.text,@"tell",self.phoneTextField.text,@"mobile",nil];
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在保存...";
    [RequestData addAddressSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"保存成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyAddressController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"添加失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
        
    }andFailure:^(NSError *error) {
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"网络连接错误";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
        
    }];
    
}
/**
 *  更新地址
 */
-(void)updateServer{
    account=[AccountTool account];
    NSDictionary *params;
    if (self.cityTextField.text.length==0) {
        params=[NSDictionary dictionaryWithObjectsAndKeys:_addressArray[@"id"],@"id",account.uid,@"uid",self.addressArray[@"sheng"],@"sheng",self.addressArray[@"shi"],@"shi",self.addressArray[@"xian"],@"xian",self.addressTextField.text,@"jiedao",self.codeTextField.text,@"youbian",self.nameTextField.text,@"shouhuoren",self.fixPhoneTextField.text,@"tell",self.phoneTextField.text,@"mobile",nil];
    }else{
        params=[NSDictionary dictionaryWithObjectsAndKeys:_addressArray[@"id"],@"id",account.uid,@"uid",self.addressView.province,@"sheng",self.addressView.city,@"shi",self.addressView.area,@"xian",self.addressTextField.text,@"jiedao",self.codeTextField.text,@"youbian",self.nameTextField.text,@"shouhuoren",self.fixPhoneTextField.text,@"tell",self.phoneTextField.text,@"mobile",nil];
    }
    //声明对象；
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    //显示的文本；
    hud.labelText = @"正在保存...";
    [RequestData updateAddressSerivce:params FinishCallbackBlock:^(NSDictionary *data) {
        int code=[data[@"code"] intValue];
        if (code==0) {
            //加载成功，先移除原来的HUD；
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //然后显示一个成功的提示；
            MBProgressHUD *successHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            successHUD.labelText = @"更新成功";
            successHUD.mode = MBProgressHUDModeCustomView;
            //可以设置对应的图片；
            successHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_success"]];
            successHUD.removeFromSuperViewOnHide = true;
            [successHUD hide:true afterDelay:1];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyAddressController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            hud.removeFromSuperViewOnHide = true;
            [hud hide:true afterDelay:0];
            //显示失败的提示；
            MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            failHUD.labelText = @"更新失败";
            failHUD.mode = MBProgressHUDModeCustomView;
            failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
            failHUD.removeFromSuperViewOnHide = true;
            [failHUD hide:true afterDelay:1];
        }
        
    }andFailure:^(NSError *error) {
        hud.removeFromSuperViewOnHide = true;
        [hud hide:true afterDelay:0];
        //显示失败的提示；
        MBProgressHUD *failHUD = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        failHUD.labelText = @"网络连接错误";
        failHUD.mode = MBProgressHUDModeCustomView;
        failHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg_hud_error"]];
        failHUD.removeFromSuperViewOnHide = true;
        [failHUD hide:true afterDelay:1];
        
    }];
    
}
/**
 *  保存
 */
-(void)saveAddress{
    if ([self.type isEqualToString:@"0"]) {
        [self updateServer];
    }else{
         [self requestServer];
    }
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


#pragma mark 选择城市
- (UIToolbar *)toolBar{
    if (_toolBar == nil) {
        self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _toolBar.barTintColor=[UIColor brownColor];
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
        _toolBar.items = @[item1, item2];
    }
    return _toolBar;
}

- (void)click{
    if (_cityTextField.isFirstResponder) {
        [_cityTextField resignFirstResponder];
        self.cityTextField.text = [NSString stringWithFormat:@"%@%@%@",self.addressView.province,self.addressView.city,self.addressView.area];
    }
}
@end
