//
//  CommentaryCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/21.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "CommentaryCell.h"

@implementation CommentaryCell

- (void)awakeFromNib {
    /**设置圆角*/
    self.peopleImageView.layer.cornerRadius=self.peopleImageView.frame.size.height/2.0;
    self.peopleImageView.layer.masksToBounds=YES;
//    CGSize size = [self.contetnLabel sizeThatFits:CGSizeMake(self.contetnLabel.frame.size.width, MAXFLOAT)];
//    self.contetnLabel.frame=CGRectMake(self.contetnLabel.frame.origin.x, self.contetnLabel.frame.origin.y, self.contetnLabel.frame.size.width, size.height);
//    self.contetnLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
