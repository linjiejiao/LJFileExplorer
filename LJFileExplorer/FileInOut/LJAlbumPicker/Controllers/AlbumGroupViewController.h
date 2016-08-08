//
//  AlbumPickerViewController.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumGroupModel;

@protocol AlbumGroupSelectDelegate <NSObject>
@required
- (void)onSelectGroup:(AlbumGroupModel *)group;

@end

@interface AlbumGroupViewController : UIViewController
@property (weak, nonatomic) id<AlbumGroupSelectDelegate> delegate;

@end
