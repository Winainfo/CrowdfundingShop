//
//  GoodsCategoryCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/15.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface GoodsCategoryCell : UITableViewCell
/**分类图标*/
//@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
///**分类名字*/
//@property (weak, nonatomic) IBOutlet ARLabel *CategoryLabel;
///**选择*/
//@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
/**是否选中*/
@property(assign,nonatomic)BOOL ifSelected;
@end
