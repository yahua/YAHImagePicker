//
//  YHImagePeckerAssetsData.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePeckerAssetsData.h"

NSString *const kObserverSelectAssetsKeyPath		=		@"selectAssetsArray";

@interface YAHImagePeckerAssetsData ()

@property (nonatomic, strong) NSMutableArray *selectAssetsArray;
@property (nonatomic, copy) NSDictionary *changeDic;

@end

@implementation YAHImagePeckerAssetsData

static YAHImagePeckerAssetsData *instance = nil;

+ (instancetype)shareInstance {
    
    if (!instance) {
        instance = [[YAHImagePeckerAssetsData alloc] init];
    }
    return instance;
    //只运行一次，及时instance=nil
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[YHImagePeckerAssetsData alloc] init];
//    });
//    return instance;
}

+ (void)destroyInstance {
    
    instance = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectAssetsArray = [NSMutableArray arrayWithCapacity:1];
        _maximumNumberOfSelection = 9;
        _filterType = YHImagePickerFilterTypePhotos;
    }
    return self;
}

#pragma mark - Public

- (void)loadGroupAssetsSuccessBlock:(void(^)(NSArray *groupAssets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock {
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        NSLog(@"%@", errorMessage);
        if (failBlock) {
            failBlock(error);
        }
    };
    
    __block NSMutableArray *groups = [NSMutableArray arrayWithCapacity:1];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *filter = [self assetsFilter];
        [group setAssetsFilter:filter];
        if ([group numberOfAssets] > 0) {
            [groups addObject:group];
        }else {
            if (successBlock) {
                successBlock(groups);
            }
        }
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [[self assetsLibrary] enumerateGroupsWithTypes:groupTypes usingBlock:resultBlock failureBlock:failureBlock];
}

- (void)loadAssetsWithGroup:(ALAssetsGroup *)assetsGroup
                resultBlock:(void(^)(NSArray *assets))resultBlock {
    
    __block NSMutableArray *assets = [NSMutableArray arrayWithCapacity:1];
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [assets addObject:result];
        }else {
            if (resultBlock) {
                resultBlock([assets copy]);
            }
        }
    };
    
    ALAssetsFilter *filter = [self assetsFilter];
    [assetsGroup setAssetsFilter:filter];
    [assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

- (void)getSelectAssetsSuccessBlock:(void(^)(NSArray *assets))successBlock
                       failureBlock:(void(^)(NSError *error))failBlock {
    
    __block NSMutableArray *assets = [NSMutableArray array];
    void (^AssetsLibraryAssetForURLResultBlock)(ALAsset *asset) = ^(ALAsset *asset) {
        // Add asset
        [assets addObject:asset];
        
        // Check if the loading finished
        if ([assets count] == [self.selectAssetsArray count]) {
            
            if (successBlock) {
                successBlock([assets copy]);
            }
        }
    };
    
    void (^AssetsLibraryAccessFailureBlock)(NSError *error) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        if (failBlock) {
            failBlock(error);
        }
    };
    
    for (ALAsset *asset in self.selectAssetsArray) {
        NSURL *selectedAssetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [[self assetsLibrary] assetForURL:selectedAssetURL
                            resultBlock:AssetsLibraryAssetForURLResultBlock
                           failureBlock:AssetsLibraryAccessFailureBlock];
    }
}

- (BOOL)isContainAsset:(ALAsset *)asset {
    
    for (ALAsset *selectAsset in self.selectAssetsArray) {
        
        if (selectAsset == asset) {
            return YES;
        }
        NSURL *selfUrl = [selectAsset defaultRepresentation].url;
        NSURL *otherUrl = [asset defaultRepresentation].url;
        
        if ([selfUrl isEqual:otherUrl]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)addAsset:(ALAsset *)asset {
    
    if (![self isContainAsset:asset]) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        self.changeDic = @{[@(YHSelectAssetsChangeAdd) stringValue]: asset};
        [self.selectAssetsArray addObject:asset];
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
}

- (void)addAssetWithArray:(NSArray *)assets {
    
    if ([assets count] > 0) {
        __block BOOL needKVO = NO;
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            if (![self isContainAsset:asset]) {
                needKVO = YES;
                if (self.selectAssetsArray.count < self.maximumNumberOfSelection) {
                    [self.selectAssetsArray addObject:asset];
                }
            }
        }];
        if (needKVO) {
            [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
            self.changeDic = @{[@(YHSelectAssetsChangeAdd) stringValue]: [assets copy]};
            [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
        }
    }
}

- (void)removeAsset:(ALAsset *)asset {
    
    ALAsset *findAsset = nil;
    for (ALAsset *selectAsset in self.selectAssetsArray) {
        
        if (selectAsset == asset) {
            findAsset  = selectAsset;
            break;
        }
        NSURL *selfUrl = [selectAsset defaultRepresentation].url;
        NSURL *otherUrl = [asset defaultRepresentation].url;
        
        if ([selfUrl isEqual:otherUrl]) {
            findAsset = selectAsset;
            break;
        }
    }
    if (findAsset) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        [self.selectAssetsArray removeObject:findAsset];
        self.changeDic = @{[@(YHSelectAssetsChangeDelete) stringValue]: findAsset};
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
}

- (BOOL)isSelectOneMore {
    
    return (self.selectAssetsArray.count>0)?YES:NO;
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections {
    
    BOOL notOverFlow = YES;
    
    notOverFlow = (numberOfSelections <= self.maximumNumberOfSelection);
    
    if (!notOverFlow) {
        [self willChangeValueForKey:kObserverSelectAssetsKeyPath];
        self.changeDic = @{[@(YHSelectAssetsChangeAddOverFlow) stringValue]: [NSNull null]};
        [self didChangeValueForKey:kObserverSelectAssetsKeyPath];
    }
    
    return notOverFlow;
}

#pragma mark - Custom Accessors

//全局存在，否则传出去的asset会失效
- (ALAssetsLibrary *)assetsLibrary {
    
    static ALAssetsLibrary *assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        // Workaround for triggering ALAssetsLibraryChangedNotification
        //[assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    });
    
    return assetsLibrary;
}

#pragma mark - Private

- (ALAssetsFilter *)assetsFilter {
    
    switch (self.filterType) {
        case YHImagePickerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
        case YHImagePickerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
        default:
            return [ALAssetsFilter allAssets];
            break;
    }
}

@end
