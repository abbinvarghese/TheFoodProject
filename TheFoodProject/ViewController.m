//
//  ViewController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "ViewController.h"
#import "TFPNearByViewController.h"
#import "TFPFavViewController.h"
#import "TFPSettingsViewController.h"

@interface ViewController ()<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *controllerArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TFPNearByViewController *startingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPNearByViewController"];
    TFPFavViewController *TFPFavViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPFavViewController"];
    TFPSettingsViewController *TFPSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPSettingsViewController"];
    _controllerArray = [NSArray arrayWithObjects:startingViewController,TFPFavViewController,TFPSettingsViewController, nil];
    
    NSArray *viewControllers = @[_controllerArray[0]];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TFPNearByViewController class]]) {
        return nil;
    }
    else if ([viewController isKindOfClass:[TFPFavViewController class]]){
        return _controllerArray[0];
    }
    else{
        return _controllerArray[1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TFPNearByViewController class]]) {
        return _controllerArray[1];
    }
    else if ([viewController isKindOfClass:[TFPFavViewController class]]){
        return _controllerArray[2];
    }
    else{
        return nil;
    }
}
@end
