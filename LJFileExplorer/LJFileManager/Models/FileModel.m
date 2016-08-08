//
//  FileModel.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/30.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel
- (void)fillWithDictionary:(NSDictionary*)dic {
    NSDate *date = [dic objectForKey:NSFileModificationDate];
    self.date = [date timeIntervalSince1970];
    NSString *fileType = [dic objectForKey:NSFileType];
    if([NSFileTypeDirectory isEqualToString:fileType]){
        self.type = TypeDirectory;
        NSArray *subFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:NULL];
        if(subFiles){
            self.size = subFiles.count;
        }else {
            self.size = 0;
        }
    }else {
        self.type = TypeFile;
        NSNumber *sizeObj = [dic objectForKey:NSFileSize];
        if(sizeObj){
            self.size = [sizeObj longLongValue];
        }else {
            self.size = 0;
        }
    }
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"FileModel[type=%d, name=%@, path=%@, size=%llu, date=%lf]", self.type, self.name, self.path, self.size, self.date];
}
@end
