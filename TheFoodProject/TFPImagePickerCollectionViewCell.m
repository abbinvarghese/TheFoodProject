//
//  TFPImagePickerCollectionViewCell.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 19/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPImagePickerCollectionViewCell.h"

@implementation TFPImagePickerCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.cellIMageView.image = nil;
}

-(void)selectCell:(BOOL)animated{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         _cellIMageView.transform=CGAffineTransformMakeScale(0.9, 0.9);
                         _cellIMageView.layer.cornerRadius = 5;
                         _cellIMageView.layer.masksToBounds = YES;
                         _cellIMageView.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)deSelectCell:(BOOL)animated{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         _cellIMageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         _cellIMageView.layer.cornerRadius = 0;
                         _cellIMageView.layer.masksToBounds = YES;
                         _cellIMageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)shakeCell{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.cellIMageView center].x - 5.0f, [self.cellIMageView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.cellIMageView center].x + 5.0f, [self.cellIMageView center].y)]];
    [[self.cellIMageView layer] addAnimation:animation forKey:@"position"];
}


@end
