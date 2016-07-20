//
//  TFPNearByViewController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 18/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPNearByViewController.h"
#import "TFPNearByTableViewCell.h"

@interface TFPNearByViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *nearByTableview;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;

@end

@implementation TFPNearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView animateWithDuration:0.0 animations:^{
        [_nearByTableview setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFPNearByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFPNearByTableViewCell"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/2;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (scrollView.contentOffset.y > -30) {
            if ([[self.view subviews] indexOfObject:_addNewButton] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view sendSubviewToBack:_addNewButton];
                });
            }
        }
        else{
            if ([[self.view subviews] indexOfObject:_addNewButton] == 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view bringSubviewToFront:_addNewButton];
                });
            }
        }
    });
}

- (IBAction)addNew:(UIButton *)sender {
    [self performSegueWithIdentifier:@"TFPImagePickerControllerSegue" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
