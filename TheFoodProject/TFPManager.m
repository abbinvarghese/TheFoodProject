//
//  TFPManager.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPManager.h"
#import "TFPConstants.h"

@implementation TFPManager

+(BOOL)isFirstLaunch{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kTFPFirstLaunchKey]) {
        return YES;
    }
    else{
        return NO;
    }
}

+(BOOL)isUserLocationSet{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kTFPUserLocationKey]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
