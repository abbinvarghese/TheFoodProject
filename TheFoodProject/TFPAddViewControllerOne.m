//
//  TFPAddViewControllerOne.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 19/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPAddViewControllerOne.h"

@interface TFPAddViewControllerOne ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *discriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation TFPAddViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BACK:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
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
