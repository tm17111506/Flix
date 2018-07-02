//
//  MovieCell.h
//  Flix
//
//  Created by Tiffany Ma on 6/27/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (nonatomic, strong) Movie *movie;
@end
