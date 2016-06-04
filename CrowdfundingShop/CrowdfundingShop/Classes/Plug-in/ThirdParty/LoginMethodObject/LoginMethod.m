//
//  LoginMethod.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/1/12.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "LoginMethod.h"
#import <ShareSDK/ShareSDK.h>
@implementation LoginMethod

//static char delegateKey;

//- (id<LoginMethodDelegate>)delegate
//{
//    return objc_getAssociatedObject(self, &delegateKey);
//}
//
//-(void)setDelegate:(id<LoginMethodDelegate>)delegate
//{
//    objc_setAssociatedObject(self, &delegateKey, delegate, OBJC_ASSOCIATION_COPY);
//}

-(void )getUserInfoDicWithThirdPartyLoginType:(LoginType)loginType{
    NSMutableDictionary * userInfodDic = [[NSMutableDictionary alloc]init];
    ShareType  LoginTypeOfShareSDK;
    switch (loginType) {
        case LoginTypeSinaWeibo:
            LoginTypeOfShareSDK = ShareTypeSinaWeibo;
            break;
        case LoginTypeWechat:
            LoginTypeOfShareSDK = ShareTypeWeixiSession;
            break;
        case LoginTypeQQ:
            LoginTypeOfShareSDK = ShareTypeQQSpace;
            break;
        default:
            break;
    }
    
    
    [ShareSDK getUserInfoWithType:LoginTypeOfShareSDK authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result) {
            NSLog(@"授权成功！");
            NSLog(@"uid:%@",[userInfo uid]);
            NSLog(@"nickname:%@",[userInfo nickname]);
            NSLog(@"profileImage:%@",[userInfo profileImage]);
            [userInfodDic setObject:[userInfo uid] forKey:@"uid"];
            [userInfodDic setObject:[userInfo nickname] forKey:@"nickname"];
            [userInfodDic setObject:[userInfo profileImage] forKey:@"profileImage"];
            
            
            //传回用户数据，错误信息传nil。留给代理实现方法中判断
            [self.delegate recieveTheUserInfo:userInfodDic errorMsg:nil];
        }else{
            NSLog(@"授权失败");
            NSLog(@"错误码:%ld,错误描述:%@",(long)[error errorCode],[error errorDescription]);
            [self.delegate recieveTheUserInfo:nil errorMsg:[error errorDescription]];
        }
        
    }];
}

@end
