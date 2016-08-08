//
//  AlbumPickerViewController.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumGroupViewController.h"
#import "AlbumGroupTableViewCell.h"
#import "AbumModel.h"

@interface AlbumGroupViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<AlbumGroupModel *> *groupList;

@end

@implementation AlbumGroupViewController

- (IBAction)onCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)init {
    self = [super initWithNibName:@"AlbumGroupViewController" bundle:nil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupList = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[AlbumGroupTableViewCell cellNib] forCellReuseIdentifier:[AlbumGroupTableViewCell cellId]];
    self.tableView.rowHeight = [AlbumGroupTableViewCell cellHeight];
    self.groupList = [AbumModel shareInstance].groupList;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AlbumGroupTableViewCell cellId]];
    AlbumGroupModel *model = [self.groupList objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumGroupModel *group = [self.groupList objectAtIndex:indexPath.row];
    if(self.delegate){
        [self.delegate onSelectGroup:group];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
