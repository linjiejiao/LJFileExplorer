//
//  FileSelectViewController.m
//  MoviePlayer
//
//  Created by liangjiajian_mac on 16/7/29.
//  Copyright © 2016年 cn.ljj. All rights reserved.
//

#import "FileManageViewController.h"
#import "FileTableViewCell.h"
#import "FileModel.h"
#import "SandBoxFileManager.h"
#import "FilesListHeaderView.h"

#define MARGIN_HORIZON      15

@interface FileManageViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<FileModel*> *fileList;
@property (copy, nonatomic) NSString *currentPath;
@property (strong, nonatomic) UILabel *currentPathLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemRename;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemDelete;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemMore;
@property (strong, nonatomic) FilesListHeaderView *header;

@property (strong, nonatomic) NSMutableArray<FileModel *> *selectedFiles;

@end

@implementation FileManageViewController

- (IBAction)onEditClicked:(UIBarButtonItem *)sender {
    if(!self.bottomToolBar.hidden){
        [self exitEditMode];
    }else{
        self.bottomToolBar.hidden = NO;
        self.tableView.editing = YES;
        [self refreshToolbarItems];
    }
    [self.tableView reloadData];
}

- (IBAction)onBackClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.delegate) {
            [self.delegate cancelSelecte];
        }
    }];
}

- (void)dissmissWithSelectedFile:(FileModel *)file {
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.delegate) {
            [self.delegate didSelectFiles:file];
        }
    }];
}

- (IBAction)onRenameClicked:(UIBarButtonItem *)sender {
    [self renameFile:[self.selectedFiles firstObject]];
    [self exitEditMode];
}

- (IBAction)onDeleteClicked:(UIBarButtonItem *)sender {
    @synchronized (self.selectedFiles) {
        for(FileModel *model in self.selectedFiles){
            [self deleteFile:model];
        }
        [self exitEditMode];
        [self refreshList];
    }
}

- (IBAction)onMoreClicked:(UIBarButtonItem *)sender {
}

- (void)onBackFolder {
    if(![self isHomeRoot]){
        self.currentPath = [self.currentPath stringByDeletingLastPathComponent];
    }
}

#pragma  mark - override
- (instancetype)init {
    self = [super initWithNibName:@"FileManageViewController" bundle:nil];
    if(self){
        self.fileList = [NSMutableArray new];
        self.selectedFiles = [NSMutableArray new];
    }
    return self;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[FileTableViewCell cellNib] forCellReuseIdentifier:[FileTableViewCell cellId]];
    self.tableView.rowHeight = [FileTableViewCell cellHeight];
    if(self.topTitle){
        self.titleItem.title = self.topTitle;
    }
    self.currentPath = NSHomeDirectory();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTopTitle:(NSString *)title {
    _topTitle = title;
    if(self.titleItem) {
        self.titleItem.title = title;
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FileTableViewCell cellId]];
    FileModel *model = [self.fileList objectAtIndex:indexPath.row];
    cell.selectMode = tableView.editing;
    cell.selected = [self.selectedFiles containsObject:model];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *model = [self.fileList objectAtIndex:indexPath.row];
    if(!tableView.editing){
        switch(model.type) {
            case TypeDirectory: {
                self.currentPath = model.path;
            }break;
            case TypeFile: {
                [self dissmissWithSelectedFile:model];
            }break;
            default:
                NSLog(@"unknown model:%@", model);
                break;
        }
    }else{
        @synchronized (self.selectedFiles) {
            [self.selectedFiles addObject:model];
        }
        [self refreshToolbarItems];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *model = [self.fileList objectAtIndex:indexPath.row];
    if(!tableView.editing){
    }else{
        @synchronized (self.selectedFiles) {
            [self.selectedFiles removeObject:model];
        }
        [self refreshToolbarItems];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!self.header){
        self.header = [FilesListHeaderView newView];
        self.currentPathLabel = self.header.pathLabel;
        self.currentPathLabel.text = [self getSimplifyPath:self.currentPath];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBackFolder)];
        [self.header.backFolderView addGestureRecognizer:tap];
    }else{
        [self.header removeFromSuperview];
    }
    return self.header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FilesListHeaderHeight;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - other methods

- (void)setCurrentPath:(NSString *)currentPath {
    _currentPath = currentPath;
    if(self.currentPathLabel) {
        self.currentPathLabel.text = [self getSimplifyPath:currentPath];
        if([self isHomeRoot]) {
            self.header.backFolderView.alpha = 0.5;
        }else{
            self.header.backFolderView.alpha = 1;
        }
    }
    [self refreshList];
}

- (NSArray *)getData {
    NSMutableArray *array = [NSMutableArray new];
    NSArray *original = [[SandBoxFileManager sharedInstance] getFilesUnderPath:self.currentPath];
    id<FilesSelectDelegate> delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(filterFiles:)]){
        for (FileModel *model in original){
            if(![delegate filterFiles:model]){
                continue;
            }
            [array addObject:model];
        }
    }else{
        return original;
    }
    return array;
}

- (BOOL)isHomeRoot {
    return [NSHomeDirectory() isEqualToString:self.currentPath];
}

- (NSString *)getSimplifyPath:(NSString *)fullPath {
    NSString *simplify = [fullPath stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@"HOME"];
    return simplify;
}

- (void)deleteFile:(FileModel *)file {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:file.path error:&error];
    if(error) {
        NSLog(@"deleteFile:%@ got error:%@", file, error);
    }
}

- (void)exitEditMode {
    self.bottomToolBar.hidden = YES;
    self.tableView.editing = NO;
    [self.selectedFiles removeAllObjects];
}

- (void)refreshList {
    [self.fileList removeAllObjects];
    [self.fileList addObjectsFromArray:[self getData]];
    [self.tableView reloadData];
    [self refreshToolbarItems];
}

- (void)refreshToolbarItems {
    if(self.selectedFiles.count == 1){
        self.itemRename.enabled = YES;
    }else{
        self.itemRename.enabled = NO;
    }
    if(self.selectedFiles.count > 0){
        self.itemDelete.enabled = YES;
    }else{
        self.itemDelete.enabled = NO;
    }
}

- (void)renameFile:(FileModel *)file {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Rename" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = file.name;
    alert.tag = [self.fileList indexOfObject:file];
    [alert show];
}

- (NSString *)getAlbumSavePath {
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [doc stringByAppendingPathComponent:@"Album"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:path]){
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        FileModel *file = [self.fileList objectAtIndex:alertView.tag];
        NSString *newName = [alertView textFieldAtIndex:0].text;
        NSString *newPath = [file.path stringByDeletingLastPathComponent];
        newPath = [newPath stringByAppendingPathComponent:newName];
        if([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
            NSLog(@"duplicate file newPath=%@", newPath);
            return;
        }
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:file.path toPath:newPath error:&error];
        if(error){
            NSLog(@"rename error=%@", error);
        }
        [self refreshList];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *newName = [alertView textFieldAtIndex:0].text;
    if(!newName || newName.length <= 0){
        return NO;
    }
    return YES;
}

@end
