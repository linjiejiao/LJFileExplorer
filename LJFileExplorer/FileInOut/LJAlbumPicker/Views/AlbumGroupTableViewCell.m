//
//  AlbumGroupTableViewCell.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumGroupTableViewCell.h"
@interface AlbumGroupTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation AlbumGroupTableViewCell

+ (float)cellHeight {
    return 80;
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:@"AlbumGroupTableViewCell" bundle:nil];
}

+ (NSString *)cellId {
    return @"AlbumGroupTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (void)setModel:(AlbumGroupModel *)model {
    _model = model;
    self.image.image = model.poster;
    self.titleLabel.text = model.name;
    self.countLabel.text = [NSString stringWithFormat:@"%d", model.count];
}

@end
