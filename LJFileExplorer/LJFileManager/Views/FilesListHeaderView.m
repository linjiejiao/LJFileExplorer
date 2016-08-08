//
//  FilesListHeaderView.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/2.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "FilesListHeaderView.h"

@implementation FilesListHeaderView

+ (UIView *)newView {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"FilesListHeaderView" owner:nil options:nil];
    return views.firstObject;
}

@end
