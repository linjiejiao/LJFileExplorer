//
//  FilesListHeaderView.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/2.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FilesListHeaderHeight    70

@interface FilesListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backFolderView;

+ (UIView *)newView;

@end
