//
//  FileTableViewCell.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/30.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "FileTableViewCell.h"
@interface FileTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight;

@end

@implementation FileTableViewCell

+ (float)cellHeight {
    return 70;
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:@"FileTableViewCell" bundle:nil];
}

+ (NSString *)cellId {
    return @"FileTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(self.selectMode){
        [super setSelected:selected animated:animated];
    }
}

- (void)setModel:(FileModel *)model {
    _model = model;
    switch (model.type) {
        case TypeDirectory:
            self.icon.image = [UIImage imageNamed:@"ico_folder"];
            self.imageRight.hidden = NO;
            self.size.text = [NSString stringWithFormat:@"%llu", model.size];
            break;
        case TypeFile:
        default:
            self.icon.image = [UIImage imageNamed:@"ico_file_common"];
            self.imageRight.hidden = YES;
            self.size.text = [self convertToDisplaySize:model.size];
            break;
    }
    self.name.text = model.name;
    self.date.text = [self convertToDisplayDate:model.date];
}

- (NSString *)convertToDisplaySize:(int64_t)size {
    NSString *unit;
    NSString *sizeNumber;
    double floatSize = size;
    if(size < 1024){
        sizeNumber = [NSString stringWithFormat:@"%.lf", floatSize];
        unit = @"B";
    }else if(size < 1024 * 1024){
        floatSize /= 1024;
        sizeNumber = [self getFormateForSzie:floatSize];
        unit = @"KB";
    }else if(size < 1024 * 1024 * 1024){
        floatSize /= (1024 * 1024);
        sizeNumber = [self getFormateForSzie:floatSize];
        unit = @"MB";
    }else {
        floatSize /= (1024 * 1024 * 1024);
        sizeNumber = [self getFormateForSzie:floatSize];
        unit = @"GB";
    }
    return [sizeNumber stringByAppendingString:unit];
}

- (NSString *)getFormateForSzie:(double)size {
    if(size > 1000) {
        return [NSString stringWithFormat:@"%.lf", size];
    } else if(size > 100){
        return [NSString stringWithFormat:@"%.1lf", size];
    } else if(size > 10){
        return [NSString stringWithFormat:@"%.2lf", size];
    } else {
        return [NSString stringWithFormat:@"%.3lf", size];
    }
}

- (NSString *)convertToDisplayDate:(double)dateTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy/MM/dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

@end
