//
//  TFPImagePickerController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 19/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPImagePickerController.h"
#import "TFPImagePickerCollectionViewCell.h"
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"
#import "TFPAddViewControllerOne.h"

@import Photos;

@interface TFPImagePickerController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,PHPhotoLibraryChangeObserver,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property CGRect previousPreheatRect;
@property (weak, nonatomic) IBOutlet UICollectionView *pickerCollectionView;
@property (nonatomic, strong) NSMutableArray *selectedIndex;
@property (nonatomic, strong) NSMutableArray *selectedPHResults;
@property (nonatomic, strong) NSMutableArray *convertedImaged;

@end

@implementation TFPImagePickerController

static CGSize AssetGridThumbnailSize;

-(void)initSelectedArray{
    if (_convertedImaged == nil) {
        _convertedImaged = [NSMutableArray new];
    }
    if (_selectedIndex == nil) {
        _selectedIndex = [NSMutableArray new];
    }
    if (_selectedPHResults == nil) {
        _selectedPHResults = [NSMutableArray new];
    }
    [_selectedIndex removeAllObjects];
    for (int i = 0; i<=_assetsFetchResults.count; i++) {
        [_selectedIndex addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)awakeFromNib{
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized || [PHPhotoLibrary authorizationStatus] ==  PHAuthorizationStatusNotDetermined){
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
        PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        _assetsFetchResults = allPhotos;
        
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            self.imageManager = [[PHCachingImageManager alloc] init];
        }
        [self resetCachedAssets];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initSelectedArray];
    });
}

- (void)dealloc {
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    CGSize cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2);
    AssetGridThumbnailSize = CGSizeMake(cellSize.width, cellSize.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Begin caching assets in and around collection view's visible rect.
    
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Please Allow Access to your Photos" message:@"This allows us to access photos from your library" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *enable = [UIAlertAction actionWithTitle:@"Enable Library Access" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [aler addAction:no];
        [aler addAction:enable];
        [self presentViewController:aler animated:YES completion:nil];
    }
    else{
        [self updateCachedAssets];
    }
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        self.imageManager = [[PHCachingImageManager alloc] init];
    }
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.pickerCollectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [collectionView reloadData];
        }
        
        [self resetCachedAssets];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initSelectedArray];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetsFetchResults.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TFPImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TFPImagePickerCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.cellIMageView.image = nil;
        cell.representedAssetIdentifier = @"";
        cell.cameraLabel.hidden = NO;
    }
    else{
        PHAsset *asset = self.assetsFetchResults[indexPath.item-1];
        cell.cameraLabel.hidden = YES;
        cell.representedAssetIdentifier = asset.localIdentifier;
        if ([[_selectedIndex objectAtIndex:indexPath.row] boolValue]) {
            [cell selectCell:NO];
        }
        else{
            [cell deSelectCell:NO];
        }
        [self.imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      // Set the cell's thumbnail image if it's still showing the same asset.
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          cell.cellIMageView.image = result;
                                      }
                                  }];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TFPImagePickerCollectionViewCell *cell = (TFPImagePickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if (_selectedPHResults.count<=2) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
        else{
            [cell shakeCell];
        }
    }
    else{
        if ([[_selectedIndex objectAtIndex:indexPath.row] boolValue]) {
            [cell deSelectCell:YES];
            [_selectedIndex replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
            [_selectedPHResults removeObject:[_assetsFetchResults objectAtIndex:indexPath.row-1]];
        }
        else{
            if (_selectedPHResults.count>=3) {
                [cell shakeCell];
            }
            else{
                [cell selectCell:YES];
                [_selectedIndex replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
                [_selectedPHResults addObject:[_assetsFetchResults objectAtIndex:indexPath.row-1]];
            }
        }
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self updateCachedAssets];
    });
}

- (void)resetCachedAssets {
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self.imageManager stopCachingImagesForAllAssets];
    }
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.pickerCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.pickerCollectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.pickerCollectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.pickerCollectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        

        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            // Update the assets the PHCachingImageManager is caching.
            [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                                targetSize:AssetGridThumbnailSize
                                               contentMode:PHImageContentModeAspectFill
                                                   options:nil];
            [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                               targetSize:AssetGridThumbnailSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil];
        }
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.row > 0) {
            PHAsset *asset = self.assetsFetchResults[indexPath.item-1];
            [assets addObject:asset];
        }
    }
    
    return assets;
}

- (IBAction)next:(id)sender {
    if (_selectedPHResults.count>0) {
        [_convertedImaged removeAllObjects];
        for (PHAsset *asset in _selectedPHResults) {
            [self.imageManager requestImageDataForAsset:asset
                                                options:nil
                                          resultHandler:^(NSData * _Nullable imageData,
                                                          NSString * _Nullable dataUTI,
                                                          UIImageOrientation orientation,
                                                          NSDictionary * _Nullable info) {
                                              
                                              UIImage *image = [UIImage imageWithData:imageData];
                                              [_convertedImaged addObject:image];
                                              
                                              if (_convertedImaged.count == _selectedPHResults.count) {
                                                  [self performSegueWithIdentifier:@"TFPAddViewControllerOneSegue" sender:self];
                                              }
                                          }];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (_selectedPHResults.count>0) {
        [_convertedImaged removeAllObjects];
        for (PHAsset *asset in _selectedPHResults) {
            [self.imageManager requestImageDataForAsset:asset
                                                options:nil
                                          resultHandler:^(NSData * _Nullable imageData,
                                                          NSString * _Nullable dataUTI,
                                                          UIImageOrientation orientation,
                                                          NSDictionary * _Nullable info) {
                                              
                                              UIImage *image = [UIImage imageWithData:imageData];
                                              
                                              [_convertedImaged addObject:image];
                                              
                                              if (_convertedImaged.count == _selectedPHResults.count) {
                                                  [_convertedImaged addObject:chosenImage];
                                                  [picker dismissViewControllerAnimated:YES completion:^{
                                                      [self performSegueWithIdentifier:@"TFPAddViewControllerOneSegue" sender:self];
                                                  }];
                                              }
                                          }];
        }
    }
    else{
        [_convertedImaged addObject:chosenImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"TFPAddViewControllerOneSegue" sender:self];
        }];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TFPAddViewControllerOneSegue"]) {
        TFPAddViewControllerOne *newView = segue.destinationViewController;
        newView.images = _convertedImaged;
    }
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
