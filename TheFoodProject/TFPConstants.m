//
//  TFPConstants.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPConstants.h"

@implementation TFPConstants

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UX Keys -

NSString *const kTFPFirstLaunchKey               = @"kPMFirstLaunchKey";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Google Keys -

NSString *const kTFPGooglePlacesKey             = @"AIzaSyD-T3b6uef1c-gHWHvvCH1p9S4Cm3_GgUY";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Restaurant Keys -

NSString *const kTFPRestaurantNameKey               = @"restaurantName";
NSString *const kTFPRestaurantNameCappedKey         = @"restaurantNameCapped";
NSString *const kTFPRestaurantlocationKey           = @"restaurantlocation";
NSString *const kTFPRestaurantPhoneNumberKey        = @"restaurantPhoneNumber";
NSString *const kTFPRestaurantWorkingFromKey        = @"restaurantWorkingFrom";
NSString *const kTFPRestaurantWorkingTillKey        = @"restaurantWorkingTill";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Item Keys -

NSString *const kTFPItemTitleKey                    = @"fuudTitle";
NSString *const kTFPItemTitleCappedKey              = @"fuudTitleCapped";
NSString *const kTFPItemDescriptionKey              = @"fuudDescription";
NSString *const kTFPItemPriceKey                    = @"fuudPrice";
NSString *const kTFPItemRatingKey                   = @"fuudRating";
NSString *const kTFPItemRestaurentKey               = @"fuudRestaurent";
NSString *const kTFPItemImageKey                    = @"fuudImage";
NSString *const kTFPItemLatitudeKey                 = @"fuudLatitude";
NSString *const kTFPItemLongitudeKey                = @"fuudLongitude";
NSString *const kTFPItemTimeStampKey                = @"fuudTimeStamp";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - User Keys -

NSString *const kTFPUserIDKey                       = @"userID";
NSString *const kTFPUserIsAnonymousKey              = @"userIsAnonymous";
NSString *const kTFPUserLocationKey                 = @"userLocation";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Location Keys -

NSString *const kTFPLocationPlaceIDKey              = @"locationPlaceID";
NSString *const kTFPLocationNameKey                 = @"locationName";
NSString *const kTFPLocationAddressKey              = @"locationAddress";
NSString *const kTFPLocationLatitudeKey             = @"locationLatitude";
NSString *const kTFPLocationLongitudeKey            = @"locationLongitude";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Feedback Keys -

NSString *const kTFPFeedbackTextKey                 = @"feedbackText";
NSString *const kTFPFeedbackFileURLKey              = @"feedbackFileURL";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Database Path Keys -

NSString *const kTFPItemPathKey                     = @"fuuds";
NSString *const kTFPRestaurentPathKey               = @"restaurents";
NSString *const kTFPStoragePathKey                  = @"gs://uncle-bun.appspot.com/";
NSString *const kTFPUserPathKey                     = @"users";
NSString *const kTFPMessagesPathKey                 = @"messages";
NSString *const kTFPFeedbackPathKey                 = @"feedbacks";


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Other Keys -

NSString *const kTFPItunesAppUrl                    = @"itunesAppUrl";
NSString *const kTFPShareSMSText                    = @"shareSMSText";
NSString *const kTFPShareEmailTitle                 = @"shareEmailTitle";
NSString *const kTFPShareEmailText                  = @"shareEmailText";


@end
