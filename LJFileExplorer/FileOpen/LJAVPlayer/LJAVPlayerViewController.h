//
//  AVPlayerViewController.h
//  Player
//
//  Created by Zac on 15/11/6.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJAVPlayerViewController : UIViewController
@property (nonatomic, assign) UIInterfaceOrientation orientation;
- (instancetype)initWithURL:(NSURL *)url;
@end
