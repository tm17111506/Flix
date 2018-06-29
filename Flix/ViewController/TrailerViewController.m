//
//  TrailerViewController.m
//  Flix
//
//  Created by Tiffany Ma on 6/29/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerVIew;
@property (nonatomic, strong) NSArray *trailers;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseString = @"https://api.themoviedb.org/3/movie/";
    NSString *endString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *idString = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    NSString *partOneURLString = [baseString stringByAppendingString:idString];
    NSString *urlString = [partOneURLString stringByAppendingString:endString];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.trailers = dataDictionary[@"results"];
            
            NSDictionary *trailer = self.trailers[0];
            NSString *trailerKey = trailer[@"key"];
            NSLog(@"%@", trailer[@"key"]);
            NSString *trailerBaseURL = @"https://www.youtube.com/watch?v=";
            NSString *trailerURLString = [trailerBaseURL stringByAppendingString:trailerKey];
            NSURL *trailerURL = [NSURL URLWithString:trailerURLString];
            
            NSURLRequest *trailerRequest = [NSURLRequest requestWithURL:trailerURL      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.trailerVIew loadRequest:trailerRequest];
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(id)sender {
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
