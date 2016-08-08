//
//  SeekSlider.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/8.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "SeekSlider.h"

#define PROGRESS_HEIGHT 2
#define MARGIN_HORIZON  10
#define MARGIN_VERTICAL 10
#define CURSOR_SIZE     20

@interface SeekSlider ()
@property (strong, nonatomic) UIView *progressBackground;
@property (strong, nonatomic) UIView *progressSecondary;
@property (strong, nonatomic) UIView *progressMain;
@property (strong, nonatomic) UIImageView *cursorView;

@property (assign, nonatomic) BOOL hasInited;

@end


@implementation SeekSlider
#pragma mark - setter && getter
- (void)setProgressMainColor:(UIColor *)progressMainColor {
    _progressMainColor = progressMainColor;
    self.progressMain.backgroundColor = progressMainColor;
}

- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor {
    _progressBackgroundColor = progressBackgroundColor;
    self.progressBackground.backgroundColor = progressBackgroundColor;
}

- (void)setProgressSecondaryColor:(UIColor *)progressSecondaryColor {
    _progressSecondaryColor = progressSecondaryColor;
    self.progressSecondary.backgroundColor = progressSecondaryColor;
}

- (void)setMainValue:(float)mainValue {
    if(mainValue < 0) {
        mainValue = 0;
    }
    if(mainValue > 1){
        mainValue = 1;
    }
    _mainValue = mainValue;
    CGRect frame = self.progressMain.frame;
    frame.size.width = CGRectGetWidth(self.progressBackground.frame) * mainValue;
    self.progressMain.frame = frame;
    
    frame = self.cursorView.frame;
    frame.origin.x = CGRectGetMaxX(self.progressMain.frame) - CURSOR_SIZE / 2;
    self.cursorView.frame = frame;
}

- (void)setSecondaryValue:(float)secondaryValue {
    if(secondaryValue < 0) {
        secondaryValue = 0;
    }
    if(secondaryValue > 1){
        secondaryValue = 1;
    }
    _secondaryValue = secondaryValue;
    CGRect frame = self.progressSecondary.frame;
    frame.size.width = CGRectGetWidth(self.progressBackground.frame) * secondaryValue;
    self.progressSecondary.frame = frame;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateFrames];
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if(self){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupView];
    }
    return self;
}

- (void)setupView {
    if(self.hasInited){
        return;
    }
    self.hasInited = YES;
    _mainValue = 0;
    _secondaryValue = 0;
    self.progressBackground = [[UIView alloc]init];
    [self addSubview:self.progressBackground];
    self.progressSecondary = [[UIView alloc]init];
    [self addSubview:self.progressSecondary];
    self.progressMain = [[UIView alloc]init];
    [self addSubview:self.progressMain];
    self.cursorView = [[UIImageView alloc]init];
    [self addSubview:self.cursorView];
    // initial frames
    CGRect frame = self.bounds;
    self.progressBackground.frame = CGRectMake(MARGIN_HORIZON, (CGRectGetHeight(frame) - PROGRESS_HEIGHT) / 2, CGRectGetWidth(frame) - 2*MARGIN_HORIZON, PROGRESS_HEIGHT);
    CGRect progressFrame = self.progressBackground.frame;
    progressFrame.size.width = 0;
    self.progressMain.frame = progressFrame;
    self.progressSecondary.frame = progressFrame;
    self.cursorView.frame = CGRectMake(CGRectGetMinX(progressFrame) - CURSOR_SIZE / 2, CGRectGetMidY(frame) - CURSOR_SIZE / 2, CURSOR_SIZE, CURSOR_SIZE);
    // initial color
    self.progressBackgroundColor = [UIColor grayColor];
    self.progressSecondaryColor = [UIColor darkGrayColor];
    self.progressMainColor = [UIColor blueColor];
    self.cursorView.image = [UIImage imageNamed:@"slide_indecator.png"];
}

- (void)updateFrames {
    CGRect frame = self.bounds;
    self.progressBackground.frame = CGRectMake(MARGIN_HORIZON, (CGRectGetHeight(frame) - PROGRESS_HEIGHT) / 2, CGRectGetWidth(frame) - 2*MARGIN_HORIZON, PROGRESS_HEIGHT);
    frame = self.progressBackground.frame;
    frame.size.width = CGRectGetWidth(self.progressBackground.frame) * self.secondaryValue;
    self.progressSecondary.frame = frame;
    frame = self.progressBackground.frame;
    frame.size.width = CGRectGetWidth(self.progressBackground.frame) * self.mainValue;
    self.progressMain.frame = frame;
    frame = self.cursorView.frame;
    frame.origin.x = CGRectGetMaxX(self.progressMain.frame) - CURSOR_SIZE / 2;
    frame.origin.y = CGRectGetMidY(self.bounds) - CURSOR_SIZE / 2;
    self.cursorView.frame = frame;
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tracking = YES;
    UITouch* touch=[touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.mainValue = (point.x - CGRectGetMinX(self.progressBackground.frame))/CGRectGetWidth(self.progressBackground.frame);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onSeekBeginValue:)]){
        [self.delegate onSeekBeginValue:self.mainValue];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tracking = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onSeekEnd)]){
        [self.delegate onSeekEnd];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch=[touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.mainValue = (point.x - CGRectGetMinX(self.progressBackground.frame))/CGRectGetWidth(self.progressBackground.frame);
    if(self.delegate && [self.delegate respondsToSelector:@selector(onSeekingValue:)]){
        [self.delegate onSeekingValue:self.mainValue];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tracking = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onSeekEnd)]){
        [self.delegate onSeekEnd];
    }
}

@end
