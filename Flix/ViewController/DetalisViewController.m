//
//  DetalisViewController.m
//  Flix
//
//  Created by Tiffany Ma on 6/28/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "DetalisViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetalisViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backDropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;

@end

@implementation DetalisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *imageURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    self.posterView.image = nil;
    [self.posterView setImageWithURL:imageURL];
    
    NSString *backDrop_pathString = self.movie[@"backdrop_path"];
    NSString *backDropURLString = [baseURLString stringByAppendingString:backDrop_pathString];
    NSURL *backDropURL = [NSURL URLWithString:backDropURLString];

    self.backDropView.image = nil;
    [self.backDropView setImageWithURL:backDropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.blurbLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.blurbLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
