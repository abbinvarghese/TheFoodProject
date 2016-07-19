//
//  AppDelegate.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "AppDelegate.h"
#import "TFPManager.h"
#import "TFPSignInViewController.h"
#import "TFPUserLocationViewController.h"
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
//    if ([FIRAuth auth].currentUser == nil) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TFPSignInViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFPSignInViewController"];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController = rootViewController;
//        [self.window makeKeyAndVisible];
//    }
//    else if (![TFPManager isUserLocationSet]){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        TFPUserLocationViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFPUserLocationViewController"];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController = rootViewController;
//        [self.window makeKeyAndVisible];
//    }
    return YES;
}

@end
