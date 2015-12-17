//
//  SearchWordCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/17.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SearchWordCell.h"

@implementation SearchWordCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SearchWordCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (void)awakeFromNib {
    self.titleLabel.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1].CGColor;
    self.titleLabel.layer.borderWidth = 0.5;
    self.titleLabel.layer.cornerRadius=2.0;
}

@end
