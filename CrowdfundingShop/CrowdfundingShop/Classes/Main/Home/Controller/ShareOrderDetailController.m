//
//  ShareOrderDetailController.m
//  CrowdfundingShop
//
//  Created by 吴金林 on 15/12/16.
//  Copyright © 2015年 吴金林. All rights reserved.
//

#import "ShareOrderDetailController.h"

@interface ShareOrderDetailController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end

@implementation ShareOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.peopleImageView.layer.cornerRadius=25.0;
    self.peopleImageView.layer.masksToBounds=YES;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewHeight.constant=CGRectGetHeight([UIScreen mainScreen].bounds)*2;
}

@end
