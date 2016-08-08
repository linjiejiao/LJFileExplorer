//
//  AVPlayerViewController.m
//  Player
//
//  Created by Zac on 15/11/6.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "LJAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SeekSlider.h"

#define MARGIN_HORIZON 10

@interface LJAVPlayerViewController () <UIGestureRecognizerDelegate, SeekSliderDelegate>
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIScrollView *videoView;
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) SeekSlider *progress;
@property (nonatomic, strong) UILabel *seekTimeView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingUI;
@property (nonatomic, assign) BOOL isSeeking;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) float zoom;
@property (nonatomic, assign) float initZoom;
@property (nonatomic, assign) int totalDuration;

@property (nonatomic, strong) id timeObserver;
@end

@implementation LJAVPlayerViewController

#pragma mark - override
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.orientation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.zoom = 2;
    [self initPlayer];
    [self setupUI];
    [self addObservers];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (instancetype)init {
    self = [super init];
    if(self){
        self.orientation = UIInterfaceOrientationPortrait;
        self.isPaused = YES;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [self init];
    if(self){
        self.url = url;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self removeObservers];
    [self.player pause];
}

- (int)totalDuration {
    if(_totalDuration) {
        return _totalDuration;
    }else if (self.player){
        _totalDuration = CMTimeGetSeconds([self.player.currentItem duration]);
    }else {
        _totalDuration = 0;
    }
    return _totalDuration;
}

#pragma mark - init methods
- (void)initPlayer {
    if (!self.player) {
        self.playerItem=[AVPlayerItem playerItemWithURL:self.url];
        self.player=[AVPlayer playerWithPlayerItem:self.playerItem];
    }
}

-(void)setupUI{
    //  container
    self.videoView = [[UIScrollView alloc] init];
    [self.view addSubview:self.videoView];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onScale:)];
    [pinchRecognizer setDelegate:self];
    [self.videoView addGestureRecognizer:pinchRecognizer];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.videoView.frame;
    [self.videoView.layer addSublayer:self.playerLayer];
    // titleBar
    self.titleBar = [[UIView alloc] init];
    [self.view addSubview:self.titleBar];
    // back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBar addSubview:self.backButton];
    // title lable
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    self.titleLable.textColor = [UIColor whiteColor];
    [self.titleBar addSubview:self.titleLable];
    //  play button
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    self.playButton.center = self.view.center;
    [self.playButton addTarget:self action:@selector(playBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    // time lable
    self.timeLable = [[UILabel alloc] init];
    self.timeLable.text = @"00:00/00:00";
    self.timeLable.textAlignment = NSTextAlignmentRight;
    self.timeLable.font = [UIFont systemFontOfSize:12];
    self.timeLable.textColor = [UIColor whiteColor];
    [self.view addSubview:self.timeLable];
    // progress
    self.progress =[[SeekSlider alloc] init];
    self.progress.delegate = self;
    [self.view addSubview:self.progress];
    // seek time
    self.seekTimeView = [[UILabel alloc] init];
    self.seekTimeView.textColor = [UIColor lightGrayColor];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.seekTimeView.hidden = YES;
    [self.view addSubview:self.seekTimeView];
    // loading view
    self.loadingUI = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingUI.center = self.view.center;
    [self.view addSubview:self.loadingUI];
    [self updateUIFrames];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onScreenTapped)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - update UI

- (void)updateUIFrames{
    CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen]bounds].size.height;
    //  container
    self.videoView.frame = self.view.bounds;
    self.zoom = [self calculateInitZoom];
    [self adaptZoom:self.zoom];
    // titleBar
    self.titleBar.frame = CGRectMake(0, 0, screenWidth, 44);
    // back button
    self.backButton.frame = CGRectMake(MARGIN_HORIZON, 0, 34, 44);
    // title lable
    CGFloat backBtnMaxX = CGRectGetMaxX(self.backButton.frame);
    self.titleLable.frame = CGRectMake(backBtnMaxX, 0, screenWidth - backBtnMaxX * 2, 44);
    //  play button
    self.playButton.frame = CGRectMake(0, 0, 46, 46);
    self.playButton.center = self.view.center;
    // time lable
    self.timeLable.frame =  CGRectMake(screenWidth - 100, screenHeight - 55, 100 - MARGIN_HORIZON, 15);
    // progress
    self.progress.frame = CGRectMake(MARGIN_HORIZON, screenHeight - 30, screenWidth - 2*MARGIN_HORIZON, 25);
    // seek time
    self.seekTimeView.frame = CGRectMake(0, self.progress.frame.origin.y - 50, 50, 12);
    // loading view
    self.loadingUI.frame = CGRectMake(0, 0, 30, 30);
    self.loadingUI.center = self.view.center;
}

- (void)setTimeLableWithLeftTime:(int)left rightTime:(int)right {
    int min1 = left / 60;
    int sec1 = left % 60;
    int min2 = right / 60;
    int sec2 = right % 60;
    NSString *timeText = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", min1, sec1, min2, sec2];
    [self.timeLable performSelectorOnMainThread:@selector(setText:) withObject:timeText waitUntilDone:YES];
}

- (void)operateButtonsAppear {
    self.backButton.hidden = NO;
    self.playButton.hidden = NO;
    self.progress.hidden = NO;
    self.timeLable.hidden = NO;
    self.titleBar.hidden = NO;
}

-(void)operateButtonsDisappear {
    self.backButton.hidden = YES;
    self.playButton.hidden = YES;
    self.progress.hidden = YES;
    self.timeLable.hidden = YES;
    self.titleBar.hidden = YES;
}

-(void)operateButtonsDisappearDelay {
    [self cancelOperateButtonsDisappearDelay];
    [self performSelector:@selector(operateButtonsDisappear) withObject:nil afterDelay:3];
}

-(void)cancelOperateButtonsDisappearDelay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(operateButtonsDisappear) object:nil];
}

- (BOOL)isOperateButtonsVisible {
    return !self.backButton.hidden;
}

- (void)adaptZoom:(float)zoom {
    CGSize videoSize = [self getVideoSize];
    CGSize viewSize = self.videoView.frame.size;
    CGSize contentSize = viewSize;
    contentSize.width = zoom * videoSize.width;
    contentSize.height = zoom * videoSize.height;
    if(contentSize.width < viewSize.width){
        contentSize.width = viewSize.width;
    }
    if(contentSize.height < viewSize.height){
        contentSize.height = viewSize.height;
    }
    self.playerLayer.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.videoView.contentSize = contentSize;
}

- (CGSize)getVideoSize{
    CGSize size = CGSizeZero;
    NSArray *tracks = [self.playerItem.asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        size = videoTrack.naturalSize;
        size = CGSizeApplyAffineTransform(size, t);
        size.width = ABS(size.width);
        size.height = ABS(size.height);
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width /= scale;
    size.height /= scale;
    return size;
}

- (float)calculateInitZoom {
    CGSize videoSize = [self getVideoSize];
    CGSize viewSize = self.view.frame.size;
    if(videoSize.width / viewSize.width > videoSize.height / viewSize.height){ //Portrait
        self.initZoom = viewSize.width / videoSize.width;
    }else{ //landscape
        self.initZoom = viewSize.height / videoSize.height;
    }
    return self.initZoom;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

#pragma mark - player control
- (void)play {
    self.isPaused = NO;
    self.playButton.selected = NO;
    [self.player play];
    [self operateButtonsDisappearDelay];
}

- (void)pause {
    self.isPaused = YES;
    [self.player pause];
    self.playButton.selected = YES;
    [self operateButtonsAppear];
}

- (void)seekToPlay:(float)time {
    self.isSeeking = YES;
    CMTime dragedCMTime = CMTimeMake(time, 1);
    [self.player pause];
    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        [self play];
        self.isSeeking = NO;
    }];
}

#pragma mark - user interaction

- (void)onScreenTapped {
    if(self.progress.tracking){
        return;
    }
    if([self isOperateButtonsVisible]) {
        [self operateButtonsDisappear];
    }else {
        [self operateButtonsAppear];
        [self operateButtonsDisappearDelay];
    }
}

- (void)playBtnClicked {
    if (self.isPaused) {
        [self play];
    }else {
        [self pause];
    }
}

- (void)backBtnClicked {
    [self.player pause];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onScale:(UIPinchGestureRecognizer *)sender {
    float lastZoom = self.zoom;
    if([sender state] == UIGestureRecognizerStateEnded) {
        lastZoom = lastZoom * [sender scale];
        if(lastZoom > 2.0){
            lastZoom = 2.0;
        }
        if(lastZoom < self.initZoom){
            lastZoom = self.initZoom;
        }
        [self adaptZoom:lastZoom];
        self.zoom = lastZoom;
    }else if([sender state] == UIGestureRecognizerStateChanged){
        lastZoom = lastZoom * [sender scale];
        if(lastZoom > 2.0){
            lastZoom = 2.0;
        }
        if(lastZoom < self.initZoom){
            lastZoom = self.initZoom;
        }
        [self adaptZoom:lastZoom];
    }
}

#pragma mark - SeekSliderDelegate

- (void)onSeekBeginValue:(float)value {
    [self cancelOperateButtonsDisappearDelay];
}

- (void)onSeekEnd {
    [self performSelector:@selector(operateButtonsDisappear) withObject:nil afterDelay:3];
    self.seekTimeView.hidden = YES;
    [self seekToPlay:self.progress.mainValue * CMTimeGetSeconds([self.playerItem duration])];
}

- (void)onSeekingValue:(float)value {
    self.seekTimeView.hidden = NO;
    int currentTime = (int)(self.progress.mainValue * CMTimeGetSeconds([self.playerItem duration]));
    int min = currentTime / 60;
    int sec = currentTime % 60;
    self.seekTimeView.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
    CGRect frame = self.seekTimeView.frame;
    frame.origin.x = self.progress.mainValue * ([[UIScreen mainScreen]bounds].size.width - frame.size.width);
    self.seekTimeView.frame = frame;
}

#pragma mark - obsevers

- (void)addProgressObserver{
    __weak typeof(self) weakSelf=self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        typeof(self) strongSelf = weakSelf;
        if(!strongSelf){
            return;
        }
        float current = CMTimeGetSeconds(time);
        if (current >= 0) {
            if (!strongSelf.progress.tracking && !strongSelf.isSeeking && strongSelf.totalDuration > 0) {
                strongSelf.self.progress.mainValue = current / strongSelf.totalDuration;
                [strongSelf setTimeLableWithLeftTime:current rightTime:strongSelf.totalDuration];
            }
        }
    }];
}

-(void)addObservers{
    [self addProgressObserver];
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    // kvo
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.view removeObserver:self forKeyPath:@"frame"];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)playbackFinished:(NSNotification *)notification{
    [self pause];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            [self play];
            [self setTimeLableWithLeftTime:0 rightTime:self.totalDuration];
        } else {
            NSLog(@"status=%d %@", (int)status, self.player.error);
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        if(self.totalDuration > 0) {
            NSArray *array = playerItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            float currentLoadTime = startSeconds + durationSeconds;
            self.progress.secondaryValue = currentLoadTime / self.totalDuration;
        }
        if (!self.isPaused) {
            if (self.player.rate==0) {
                [self.loadingUI startAnimating];
            }else {
                [self.loadingUI stopAnimating];
            }
        }
    }else if([keyPath isEqualToString:@"frame"]){
        [self updateUIFrames];
    }
}
@end
