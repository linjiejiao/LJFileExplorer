//
//  ViewController.m
//  LJFileExplorer
//
//  Created by liangjiajian_mac on 16/8/8.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "ViewController.h"
#import "FileManageViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)onFilesClicked:(UIButton *)sender {
    FileManageViewController *vc = [[FileManageViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
