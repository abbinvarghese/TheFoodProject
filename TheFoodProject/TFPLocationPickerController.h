//
//  TFPLocationPickerController.h
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPLocationPickerControllerDelegate <NSObject>

-(void)TFPLocationPickerControllerFinishedWithPlace:(NSMutableDictionary*)place;

@end

@interface TFPLocationPickerController : UIViewController

@property (nonatomic, strong) id <TFPLocationPickerControllerDelegate> delegate;

@end
