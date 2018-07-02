//
//  MovieCell.m
//  Flix
//
//  Created by Tiffany Ma on 6/27/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie{
    _movie = movie;
    self.titleLabel.text = self.movie.title;
    self.blurbLabel.text = self.movie.blurb;
    
    self.imageLabel.image = nil;
    if(movie.posterURL != nil){
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = self.movie.posterURL;
        NSString *imageURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];

        [self.imageLabel setImageWithURL:imageURL];
    }
}

@end
