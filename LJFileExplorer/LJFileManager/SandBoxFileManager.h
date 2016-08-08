//
//  SandBoxFileManager.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/30.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface SandBoxFileManager : NSObject
+ (SandBoxFileManager *)sharedInstance;
- (NSArray *)getFilesUnderPath:(NSString *)path;
- (FileModel *)createModelFromPath:(NSString *)path;

@end
