//
//  TFPLocationPickerController.m
//  TheFoodProject
//
//  Created by Abbin Varghese on 17/07/16.
//  Copyright © 2016 TheFoodCompany. All rights reserved.
//

#import "TFPLocationPickerController.h"
#import "AFNetworking.h"
#import "NSDictionary+PMPlace.h"
#import "TFPConstants.h"

@interface TFPLocationPickerController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (strong, nonatomic) NSArray *placesArray;
@property (weak, nonatomic) IBOutlet UITableView *placesTableview;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@end

@implementation TFPLocationPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _placesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *place = _placesArray[indexPath.row];
    NSArray *terms = place[@"terms"];
    NSString *text = terms[0][@"value"];
    NSString *detailed;
    @try {
        detailed = [NSString stringWithFormat:@"%@ %@",terms[1][@"value"],terms[2][@"value"]];
    } @catch (NSException *exception) {
        detailed = [NSString stringWithFormat:@"%@",terms[1][@"value"]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailed;
    return cell;

}



- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    [_dataTask cancel];
    
    NSString *inputString = sender.text;
    NSString *type = @"(cities)";
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSString *component = [NSString stringWithFormat:@"country:%@",countryCode];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=%@&components=%@&key=%@",inputString,type,component,kTFPGooglePlacesKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            _placesArray = [responseObject objectForKey:@"predictions"];
            [_placesTableview reloadData];
        }
    }];
    [_dataTask resume];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_dataTask cancel];
    
    NSDictionary *place = _placesArray[indexPath.row];
    NSString *placeId = place[@"place_id"];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",placeId,kTFPGooglePlacesKey];
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:googleRequestURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            NSMutableDictionary *placeDetail = [[NSMutableDictionary alloc]initWithPlace:[responseObject objectForKey:@"result"]];
            [_searchBar resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(TFPLocationPickerControllerFinishedWithPlace:)]) {
                    [self.delegate TFPLocationPickerControllerFinishedWithPlace:placeDetail];
                }
            }];
        }
    }];
    [_dataTask resume];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

- (IBAction)dismissView:(id)sender {
    [_searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
