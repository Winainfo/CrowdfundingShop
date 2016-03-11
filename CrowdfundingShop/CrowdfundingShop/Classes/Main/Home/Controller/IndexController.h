//
//  IndexController.h
//  CrowdfundingShop
//  晒单详情
//  Created by 吴金林 on 15/12/4.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ontdelegater <NSObject>

-(void)nsdd:(int )a;

@end
@interface IndexController : UITableViewController
@property(assign,nonatomic)id<ontdelegater>delegate;
@end
