//
//  AlbumPickViewController.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/8/5.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "AlbumPickViewController.h"
#import "AlbumCollectionViewCell.h"
#import "AbumModel.h"
#import "AlbumGroupViewController.h"
#import "AlbumGroupModel.h"

@interface AlbumPickViewController () <UICollectionViewDataSource, UICollectionViewDelegate, AlbumGroupSelectDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *albumItems;
@property (strong, nonatomic) NSMutableArray *selectedItems;

@end

@implementation AlbumPickViewController

- (instancetype)init {
    self = [super initWithNibName:@"AlbumPickViewController" bundle:nil];
    if(self){
        self.selectedItems = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[AlbumCollectionViewCell cellNib] forCellWithReuseIdentifier:[AlbumCollectionViewCell cellId]];
    self.collectionView.delegate = self;
    [self updateDoneButtonStatus];
    self.collectionView.allowsMultipleSelection = self.multiSelect;
    self.albumItems = [AbumModel shareInstance].allAlbumItems;
    [[AbumModel shareInstance] getGroupListAsync:^(NSArray *list) {
        self.albumItems = [AbumModel shareInstance].allAlbumItems;
    }];
}

- (void)setAlbumItems:(NSArray *)albumItems {
    _albumItems = albumItems;
    [self.collectionView reloadData];
    if(albumItems.count > 0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.albumItems.count -1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate){
        [self.delegate onCancel];
    }
}

- (IBAction)onAlbumGroup:(UIBarButtonItem *)sender {
    AlbumGroupViewController *vc = [AlbumGroupViewController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onDone:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate){
        [self.delegate onSelectFinish:self.selectedItems];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AlbumCollectionViewCell cellId] forIndexPath:indexPath];
    AlbumItemModel *item = [self.albumItems objectAtIndex:indexPath.row];
    cell.model = item;
    cell.selected = [self.selectedItems containsObject:item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [AlbumCollectionViewCell cellSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [AlbumCollectionViewCell cellInsets];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumItemModel *item = [self.albumItems objectAtIndex:indexPath.row];
    [self.selectedItems addObject:item];
    [self updateDoneButtonStatus];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumItemModel *item = [self.albumItems objectAtIndex:indexPath.row];
    [self.selectedItems removeObject:item];
    [self updateDoneButtonStatus];
}

#pragma mark - AlbumGroupSelectDelegate
- (void)onSelectGroup:(AlbumGroupModel *)group {
    self.titleItem.title = group.name;
    [self.selectedItems removeAllObjects];
    [self updateDoneButtonStatus];
    self.albumItems = group.assets;
}

#pragma mark - others
- (void)updateDoneButtonStatus {
    self.doneItem.enabled = self.selectedItems.count > 0;
}
@end
