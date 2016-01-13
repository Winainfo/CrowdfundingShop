//
//  ShareOrderDetailController.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface ShareOrderDetailController : UITableViewController
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UIButton *peopleNameBtn;
/**奖励福分*/
@property (weak, nonatomic) IBOutlet ARLabel *scoreLael;
/**云购次数*/
@property (weak, nonatomic) IBOutlet ARLabel *numLabel;
/**商品名称*/
@property (weak, nonatomic) IBOutlet ARLabel *goodsNameLabel;
/**晒单标题*/
@property (weak, nonatomic) IBOutlet ARLabel *titleLabel;
/**晒单时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**晒单图片*/
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
/**晒单内容*/
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/**评论条数*/
@property (weak, nonatomic) IBOutlet ARLabel *numberLabel;

@property (retain,nonatomic)NSString *sd_id;
@property (retain,nonatomic)NSDictionary *dic;
@end
