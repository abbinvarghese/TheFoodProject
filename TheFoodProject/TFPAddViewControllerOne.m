//
//  TFPAddViewControllerOne.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 19/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPAddViewControllerOne.h"

@interface TFPAddViewControllerOne ()<UITextFieldDelegate,UITextViewDelegate>

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
        [_scrollView setContentOffset:CGPointMake(0, 64) animated:YES];
    }
    else if (textField.tag == 1){
        [_scrollView setContentOffset:CGPointMake(0, 135) animated:YES];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"discription (optional)";
        textView.textColor = [UIColor colorWithWhite:0 alpha:0.25];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"discription (optional)"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [_scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        [_priceTextField becomeFirstResponder];
    }
    else if (textField.tag == 1){
        [_discriptionTextView becomeFirstResponder];
    }
    return YES;
}

- (IBAction)resignFirstResponder:(UITapGestureRecognizer *)sender {
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
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
