//
//  TFPConstants.h
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFPConstants : NSObject

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UX Keys -

FOUNDATION_EXPORT NSString *const kTFPFirstLaunchKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Google Keys -

FOUNDATION_EXPORT NSString *const kTFPGooglePlacesKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Restaurant Keys -

FOUNDATION_EXPORT NSString *const kTFPRestaurantNameKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurantNameCappedKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurantlocationKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurantPhoneNumberKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurantWorkingFromKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurantWorkingTillKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Item Keys -

FOUNDATION_EXPORT NSString *const kTFPItemTitleKey;
FOUNDATION_EXPORT NSString *const kTFPItemTitleCappedKey;
FOUNDATION_EXPORT NSString *const kTFPItemDescriptionKey;
FOUNDATION_EXPORT NSString *const kTFPItemPriceKey;
FOUNDATION_EXPORT NSString *const kTFPItemRatingKey;
FOUNDATION_EXPORT NSString *const kTFPItemRestaurentKey;
FOUNDATION_EXPORT NSString *const kTFPItemImageKey;
FOUNDATION_EXPORT NSString *const kTFPItemLatitudeKey;
FOUNDATION_EXPORT NSString *const kTFPItemLongitudeKey;
FOUNDATION_EXPORT NSString *const kTFPItemTimeStampKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - User Keys -

FOUNDATION_EXPORT NSString *const kTFPUserIDKey;
FOUNDATION_EXPORT NSString *const kTFPUserIsAnonymousKey;
FOUNDATION_EXPORT NSString *const kTFPUserLocationKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Location Keys -

FOUNDATION_EXPORT NSString *const kTFPLocationPlaceIDKey;
FOUNDATION_EXPORT NSString *const kTFPLocationNameKey;
FOUNDATION_EXPORT NSString *const kTFPLocationAddressKey;
FOUNDATION_EXPORT NSString *const kTFPLocationLatitudeKey;
FOUNDATION_EXPORT NSString *const kTFPLocationLongitudeKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Feedback Keys -

FOUNDATION_EXPORT NSString *const kTFPFeedbackTextKey;
FOUNDATION_EXPORT NSString *const kTFPFeedbackFileURLKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Database Path Keys -

FOUNDATION_EXPORT NSString *const kTFPItemPathKey;
FOUNDATION_EXPORT NSString *const kTFPRestaurentPathKey;
FOUNDATION_EXPORT NSString *const kTFPStoragePathKey;
FOUNDATION_EXPORT NSString *const kTFPUserPathKey;
FOUNDATION_EXPORT NSString *const kTFPMessagesPathKey;
FOUNDATION_EXPORT NSString *const kTFPFeedbackPathKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Other Keys -

FOUNDATION_EXPORT NSString *const kTFPItunesAppUrl;
FOUNDATION_EXPORT NSString *const kTFPShareSMSText;
FOUNDATION_EXPORT NSString *const kTFPShareEmailTitle;
FOUNDATION_EXPORT NSString *const kTFPShareEmailText;


@end
