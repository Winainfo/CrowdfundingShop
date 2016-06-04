//
//  SelectCloudNumCell.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/14.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "SelectCloudNumCell.h"

@implementation SelectCloudNumCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SelectCloudNumCell" owner:self options:nil];
        
//        CGFloat borderWidth=3.5f;
//        UIView *bgView = [[UIView alloc] initWithFrame:frame];
//        bgView.layer.borderColor = [UIColor redColor].CGColor;
//        bgView.layer.borderWidth = borderWidth;
//        self.selectedBackgroundView = bgView;
//        CGRect myContentRect = CGRectInset(self.contentView.bounds, borderWidth, borderWidth);
//        UIView *myContentView = [[UIView alloc] initWithFrame:myContentRect];
//        myContentView.backgroundColor = [UIColor greenColor];
//        myContentView.layer.borderColor = [UIColor redColor].CGColor;
//        myContentView.layer.borderWidth = borderWidth;
//        [self.contentView addSubview:myContentView];
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
    // Initialization code
}

@end
