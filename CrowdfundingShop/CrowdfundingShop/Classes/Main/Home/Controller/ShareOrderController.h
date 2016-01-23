//
//  ShareOrderController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareOrderController : UIViewController
{
    NSIndexPath    *_lastIndexPath;
}
/**晒单*/
@property (retain,nonatomic)NSArray *shareArray;
@end
