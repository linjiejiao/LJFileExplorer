//
//  AlbumCollectionViewCell.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_INTERVAL       6
#define CELL_COUNT_PER_ROW  4

@interface AlbumCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *imageType;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation AlbumCollectionViewCell

+ (CGSize)cellSize {
    float width = [UIScreen mainScreen].bounds.size.width;
    float size = (width - (CELL_COUNT_PER_ROW + 1) * CELL_INTERVAL ) / CELL_COUNT_PER_ROW;
    return CGSizeMake(size, size);
}

+ (UIEdgeInsets)cellInsets {
    return UIEdgeInsetsMake (CELL_INTERVAL, CELL_INTERVAL, CELL_INTERVAL, CELL_INTERVAL);
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:@"AlbumCollectionViewCell" bundle:nil];
}

+ (NSString *)cellId {
    return @"AlbumCollectionViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
        self.imageSelected.image = [UIImage imageNamed:@"album_selected"];
    }else{
        self.imageSelected.image = [UIImage imageNamed:@"album_unselected"];
    }
}

- (void)setTypeIcon{
    UIImage *img = nil;
    if([ALAssetTypeVideo isEqualToString:self.model.type]){
        img = [UIImage imageNamed:@"icon_movie"];
    }else if([ALAssetTypePhoto isEqualToString:self.model.type]){
        img = [UIImage imageNamed:@"icon_picture"];
    }
    self.imageType.image = img;
}

- (void)setModel:(AlbumItemModel *)model {
    _model = model;
    [self setTypeIcon];
    self.imageThumbnail.image = [UIImage imageWithCGImage:model.asset.thumbnail];
    if([ALAssetTypeVideo isEqualToString:model.type]){
        self.durationLabel.text = [self getDuration];;
        self.durationLabel.hidden = NO;
    }else{
        self.durationLabel.hidden = YES;
    }
}

- (NSString *)getDuration {
    NSNumber *duration = [self.model.asset valueForProperty:ALAssetPropertyDuration];
    int durationInt = [duration intValue];
    int min = durationInt / 60;
    int sec = durationInt % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

@end
