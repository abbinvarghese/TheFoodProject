//
//  TFPImagePickerCollectionViewCell.h
//  TheFoodProject
//
//  Created by Abbin Varghese on 19/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFPImagePickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellIMageView;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

-(void)selectCell:(BOOL)animated;
-(void)deSelectCell:(BOOL)animated;
-(void)shakeCell;

@end
