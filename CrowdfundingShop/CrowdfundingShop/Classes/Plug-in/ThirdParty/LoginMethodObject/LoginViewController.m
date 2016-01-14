//
//  LoginViewController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/12.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginMethod.h"

@interface LoginViewController ()<LoginMethodDelegate>
@property (nonatomic ,strong) LoginMethod * myLoginMethod;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三方登录测试";
    //只需要初始化LoginMethod这个类的对象，然后让当前控制器遵守他的协议
    self.myLoginMethod = [[LoginMethod alloc]init];
    self.myLoginMethod.delegate = self;
}

- (IBAction)loginWithQQ:(id)sender {
    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeQQ];
}

- (IBAction)loginWithWeChat:(id)sender {

    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeWechat];
    
}

- (IBAction)loginWithSinaWeibo:(id)sender {
    [self.myLoginMethod getUserInfoDicWithThirdPartyLoginType:LoginTypeSinaWeibo];
}


#pragma mark - LoginDelegate
/**
 *  拿到数据之后的代理方法
 *
 *  @param userInfo 拿到的用户数据
 *  @param errorMsg 返回的错误信息。（判断是否存在错误信息，如果没有错误信息，用户数据可以拿到）
 */
-(void)recieveTheUserInfo:(NSDictionary *)userInfo errorMsg:(NSString *)errorMsg
{
    if (!errorMsg) {
        NSLog(@"%@",userInfo);
    }else{
        NSLog(@"%@",errorMsg);
    }
    
}
@end
