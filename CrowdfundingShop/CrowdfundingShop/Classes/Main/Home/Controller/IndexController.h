//
//  IndexController.h
//  CrowdfundingShop
//  晒单详情
//  Created by 吴金林 on 15/12/4.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularGoodsCell.h"
#import "goodsViewCell.h"
#import "AppDelegate.h"
#import "DetailController.h"
#import "DidAnnounceView.h"
#import "InAnnounceView.h"
#import "RequestData.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "CartModel.h"
#import "Database.h"
#import "GroomViewCell.h"
#import "AccountTool.h"
#import "LoginController.h"
#import "MyCouldRecordController.h"
#import "RechargeServiceController.h"
#import "AnnNavController.h"
#import "MZTimerLabel.h"
@protocol ontdelegater <NSObject>

-(void)nsdd:(int )a;

@end
@interface IndexController : UITableViewController
@property(assign,nonatomic)id<ontdelegater>delegate;
@end
