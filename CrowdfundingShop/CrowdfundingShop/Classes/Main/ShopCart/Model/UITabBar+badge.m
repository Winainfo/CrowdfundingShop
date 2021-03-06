//
//  UITabBar+badge.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 16/2/15.
//  Copyright © 2016年 吴金林. All rights reserved.
//

#import "UITabBar+badge.h"
#define tabBarItemNum 0
#define Constant 1000
@implementation UITabBar (badge)
- (void)showBadgeWithIndex:(long )index
{
    [self hideBadgeWithIndex:index];
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = index + Constant;
    badgeView.layer.cornerRadius = 8;
    badgeView.backgroundColor = [UIColor redColor];
    int itemW = self.frame.size.width / tabBarItemNum;
    badgeView.frame = CGRectMake((int)((index + 0.68) * itemW), 3, 16, 16); // 小数会造成模糊，强转只是去掉小说点后位数，不会四舍五入
    //    NSLog(@"%d--%f",(int)((index + 0.68) * itemW), (index + 0.68) * itemW);
    [self addSubview:badgeView];
}

- (void)hideBadgeWithIndex:(long )index
{
    if ([self viewWithTag:index + Constant])
    {
        [[self viewWithTag:index + Constant] removeFromSuperview];
    }
}
@end
