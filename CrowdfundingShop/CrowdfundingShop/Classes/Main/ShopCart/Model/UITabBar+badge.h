//
//  UITabBar+badge.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/15.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeWithIndex:(long )index;
- (void)hideBadgeWithIndex:(long )index;
@end
