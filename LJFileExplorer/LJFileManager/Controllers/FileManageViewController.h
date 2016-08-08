//
//  FileSelectViewController.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/29.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
@protocol FilesSelectDelegate <NSObject>
@required
- (void)didSelectFiles:(FileModel *)file;
- (void)cancelSelecte;
@optional
- (BOOL)filterFiles:(FileModel *)model;
@end

@interface FileManageViewController : UIViewController
@property (nonatomic, weak) id<FilesSelectDelegate> delegate;
@property (nonatomic, copy) NSString *topTitle;

@end
