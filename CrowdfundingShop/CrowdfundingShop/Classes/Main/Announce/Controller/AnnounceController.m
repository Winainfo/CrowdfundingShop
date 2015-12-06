//
//  AnnounceController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "AnnounceController.h"

@interface AnnounceController ()

@end

@implementation AnnounceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:16.0],NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]}];
    self.title=@"最新揭晓";
}


@end
