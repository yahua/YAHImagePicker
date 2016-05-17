//
//  YHImagePickerCollectionViewController.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerCollectionViewController.h"
#import "YAHPreSelectAssetViewController.h"
#import "YAHAssetCollectionViewCell.h"

#import "YAHImagePeckerAssetsData.h"
#import "NSObject+FBKVOController.h"
#import "YAHImagePickerDefines.h"

@interface YAHImagePickerCollectionViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YAHPreSelectAssetViewController *preSelectCollectionViewController;

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSArray *assets;

@end

@implementation YAHImagePickerCollectionViewController

- (instancetype)initWith:(ALAssetsGroup *)assetsGroup {
    
    self = [super init];
    if (self) {
        _assetsGroup = assetsGroup;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showBarView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = CGSizeMake(kThumbnailLength, kThumbnailLength);
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 2.0;
    layout.minimumLineSpacing           = 2.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[YAHAssetCollectionViewCell class]
            forCellWithReuseIdentifier:@"YHAssetCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.collectionView];
    
    [self addChildViewController:self.preSelectCollectionViewController];
    [self.view addSubview:self.preSelectCollectionViewController.view];
    
    [[YAHImagePeckerAssetsData shareInstance] loadAssetsWithGroup:self.assetsGroup resultBlock:^(NSArray *assets) {
        
        self.assets = assets;
    }];
    [self addSelectAssetsArrayObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    NSInteger i = 0;
    for (ALAsset *assetT in self.assets) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if ([[YAHImagePeckerAssetsData shareInstance] isContainAsset:assetT]) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }else {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        i++;
    }
}

#pragma mark - Custom Accessors

- (YAHPreSelectAssetViewController *)preSelectCollectionViewController {
    
    if (!_preSelectCollectionViewController) {
        
        _preSelectCollectionViewController = [[YAHPreSelectAssetViewController alloc] init];
        CGRect rc = self.view.frame;
        _preSelectCollectionViewController.view.frame = CGRectMake(0, CGRectGetHeight(rc) -PreSelectionsToolbarHeight, CGRectGetWidth(rc), PreSelectionsToolbarHeight);
        __weak __typeof(self)weakSelf = self;
        _preSelectCollectionViewController.doneBlock = ^() {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf done:nil];
        };
        
        rc = self.collectionView.frame;
        rc.size.height -= PreSelectionsToolbarHeight;
        self.collectionView.frame = rc;
    }
    return _preSelectCollectionViewController;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"YHAssetCollectionViewCell";
    
    YAHAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    [cell bind:asset];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[YAHImagePeckerAssetsData shareInstance] validateMaximumNumberOfSelections:[YAHImagePeckerAssetsData shareInstance].selectAssetsArray.count + 1];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ALAsset *asset = self.assets[indexPath.row];
    [[YAHImagePeckerAssetsData shareInstance] addAsset:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ALAsset *asset = self.assets[indexPath.row];
    [[YAHImagePeckerAssetsData shareInstance] removeAsset:asset];
}

#pragma mark - Action

- (void)done:(id)sender {
    
    if (self.sucessBlock) {
        self.sucessBlock();
    }
}

#pragma mark - Private

- (void)showBarView {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    doneButton.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
    [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
}

- (void)addSelectAssetsArrayObserver {
    
    __weak __typeof(self)weakSelf = self;
    [self.KVOController observe:[YAHImagePeckerAssetsData shareInstance] keyPath:@"selectAssetsArray" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.navigationItem.rightBarButtonItem.enabled = [[YAHImagePeckerAssetsData shareInstance] isSelectOneMore];
    }];
}

@end
