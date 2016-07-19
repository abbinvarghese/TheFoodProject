//
//  TFPUserLocationViewController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPUserLocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TFPLocationPickerController.h"
#import "AFNetworking.h"
#import "NSDictionary+PMPlace.h"
#import "TFPConstants.h"
#import "ViewController.h"
#import "AppDelegate.h"
@import CoreLocation;

@interface TFPUserLocationViewController ()<TFPLocationPickerControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL firstLocationUpdate;

@end

@implementation TFPUserLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_0102" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //Config dark gradient view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.avplayer play];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TFPLocationPickerController"]) {
        TFPLocationPickerController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

-(void)TFPLocationPickerControllerFinishedWithPlace:(NSMutableDictionary *)place{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:place forKey:kTFPUserLocationKey];
    [defaults setBool:YES forKey:kTFPFirstLaunchKey];
    [defaults synchronize];
    [self switchRootView];
}

- (IBAction)detectLocation:(UIButton *)sender {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!_firstLocationUpdate) {
        _firstLocationUpdate = YES;
        [self.locationManager stopUpdatingLocation];
        
        CLLocation *location = [locations lastObject];
        double lat = location.coordinate.latitude;
        double lng = location.coordinate.longitude;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankby=distance&type=establishment&key=%@",lat,lng,kTFPGooglePlacesKey];
        NSURL *URL = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (!error) {
                NSDictionary *closestPlace = [responseObject[@"results"] firstObject];
                NSString *placeId = closestPlace[@"place_id"];
                NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",placeId,kTFPGooglePlacesKey];
                NSURL *URL = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:URL];
                NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSMutableDictionary *place = [[NSMutableDictionary alloc]initWithPlace:responseObject[@"result"]];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:place forKey:kTFPUserLocationKey];
                        [defaults setBool:YES forKey:kTFPFirstLaunchKey];
                        [defaults synchronize];
                        [self switchRootView];
                    }
                }];
                [dataTask resume];
            }
        }];
        [dataTask resume];
        
    }
}

-(void)switchRootView{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [UIView transitionWithView:appDelegate.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ appDelegate.window.rootViewController = vc;}
                    completion:nil];
}


@end
