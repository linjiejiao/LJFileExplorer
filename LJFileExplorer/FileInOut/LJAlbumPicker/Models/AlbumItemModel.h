//
//  AlbumItemModel.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAsset;

@interface AlbumItemModel : NSObject
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) ALAsset *asset;

@end
