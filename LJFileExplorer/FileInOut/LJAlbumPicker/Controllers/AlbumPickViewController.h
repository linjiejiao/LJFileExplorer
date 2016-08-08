//
//  AlbumPickViewController.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumGroupModel;
@class AlbumItemModel;

@protocol AlbumPickDelegate <NSObject>
@required
- (void)onSelectFinish:(NSArray<AlbumItemModel *> *)selection;
- (void)onCancel;

@end

@interface AlbumPickViewController : UIViewController
@property (weak, nonatomic) id<AlbumPickDelegate> delegate;
@property (assign, nonatomic) BOOL multiSelect;
@end
