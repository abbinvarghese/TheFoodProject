//
//  TFPSignInViewController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPSignInViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TFPManager.h"
#import "TFPConstants.h"
@import Firebase;

@interface TFPSignInViewController ()

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;

@end

@implementation TFPSignInViewController

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

- (IBAction)signINLater:(UIButton *)sender {
    if ([FIRAuth auth].currentUser == nil) {
        self.view.userInteractionEnabled = NO;
        [[FIRAuth auth]
         signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
             self.view.userInteractionEnabled = YES;
             if (error == nil) {
                 FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                 NSDictionary *post = @{kTFPUserIDKey: user.uid,
                                        kTFPUserIsAnonymousKey:[NSNumber numberWithBool:user.isAnonymous]};
                 NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:user.uid]: post};
                 [ref updateChildValues:childUpdates];
                 if (![TFPManager isUserLocationSet]) {
                     [self performSegueWithIdentifier:@"TFPUserLocationViewControllerSegue" sender:self];
                 }
                 else{
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 
             }

         }];
    }
    else{
        
    }
}

@end
