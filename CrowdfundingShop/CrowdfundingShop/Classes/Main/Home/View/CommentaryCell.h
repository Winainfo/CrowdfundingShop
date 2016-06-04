//
//  CommentaryCell.h
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface CommentaryCell : UITableViewCell
/**用户头像*/
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
/**用户名*/
@property (weak, nonatomic) IBOutlet UIButton *peopleNameBtn;
/**评论时间*/
@property (weak, nonatomic) IBOutlet ARLabel *timeLabel;
/**评论内容*/
@property (weak, nonatomic) IBOutlet ARLabel *contetnLabel;
@end
