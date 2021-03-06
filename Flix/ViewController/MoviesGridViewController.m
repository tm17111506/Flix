//
//  MoviesGridViewController.m
//  Flix
//
//  Created by Tiffany Ma on 6/28/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "GridDetailsViewController.h"
#import "SVProgressHUD.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filteredData;
@property (nonatomic, strong) NSArray *data;
@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    [self fetchMovie];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    
    CGFloat posterPerLine = 2;
    CGFloat posterWidth = self.collectionView.frame.size.width/posterPerLine;
    
    layout.itemSize = CGSizeMake(posterWidth, posterWidth*1.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchMovie {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];
    
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.movies = dataDictionary[@"results"];
                self.data = self.movies;
                self.filteredData = self.movies;
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
            }
            [SVProgressHUD dismiss];
            [self.collectionView reloadData];
        }];
        [task resume];
    });
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *baseURLStringSmall = @"https://image.tmdb.org/t/p/w45";
    NSString *baseURLStringOrg = @"https://image.tmdb.org/t/p/original";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *smallString = [baseURLStringSmall stringByAppendingString:posterURLString];
    NSString *orgString = [baseURLStringOrg stringByAppendingString:posterURLString];
    //NSString *imageURLString = [baseURLString stringByAppendingString:posterURLString];
    //NSURL *imageURL = [NSURL URLWithString:imageURLString];
    cell.posterView.image = nil;
    //[cell.posterView setImageWithURL:imageURL];
    
    NSURL *urlSmall = [NSURL URLWithString:smallString];
    NSURL *urlLarge = [NSURL URLWithString:orgString];
    
    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    __weak MovieCollectionCell *weakSelf = cell;
    
    [cell.posterView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       weakSelf.posterView.alpha = 0.0;
                                       weakSelf.posterView.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.posterView.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [weakSelf.posterView setImageWithURLRequest:requestLarge
                                                                                      placeholderImage:smallImage
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                   weakSelf.posterView.image = largeImage;
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   // do something for the failure condition of the large image request
                                                                                                   // possibly setting the ImageView's image to a default image
                                                                                               }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filteredData.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length != 0){
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.data filteredArrayUsingPredicate:predicate];
    }
    else{
        self.filteredData = self.data;
    }
    
    [self.collectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
    [self.collectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    self.filteredData = self.data;
    [self.collectionView reloadData];
    [self.searchBar resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *tappedIndex = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[tappedIndex.item];
    
    GridDetailsViewController *gridDetailsViewController = [segue destinationViewController];
    
    gridDetailsViewController.movie = movie;
    
}


@end
