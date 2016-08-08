//
//  SeekSlider.h
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/8.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeekSliderDelegate <NSObject>
- (void)onSeekBeginValue:(float)value;
- (void)onSeekEnd;
- (void)onSeekingValue:(float)value;
@end

@interface SeekSlider : UIView
@property (weak, nonatomic) id<SeekSliderDelegate> delegate;
@property (assign, nonatomic) float mainValue;
@property (assign, nonatomic) float secondaryValue;
@property (assign, nonatomic) BOOL tracking;

@property (strong, nonatomic) UIColor *progressBackgroundColor;
@property (strong, nonatomic) UIColor *progressSecondaryColor;
@property (strong, nonatomic) UIColor *progressMainColor;

@end
