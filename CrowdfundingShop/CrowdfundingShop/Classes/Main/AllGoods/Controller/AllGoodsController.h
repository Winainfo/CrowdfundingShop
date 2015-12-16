//
//  AllGoodsController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/11/23.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface AllGoodsController : UIViewController{
    NSIndexPath    *_lastIndexPath;
    NSIndexPath    *_sortIndexPath;
}
/**分类名称*/
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
/**排序*/
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (retain,nonatomic) NSString *name;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
