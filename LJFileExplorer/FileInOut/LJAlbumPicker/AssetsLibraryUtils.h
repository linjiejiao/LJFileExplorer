//
//  AssetsLibraryUtils.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetsLibraryUtils : NSObject
+ (void)copyFileFromAlbum:(NSURL *)assertUrl toPath:(NSString *)saveFile complete:(void(^)(BOOL succss, NSError *error))complete;
+ (NSDictionary *)parseParmsFromUrl:(NSString*)url;

@end
