//
//  Movie.m
//  Flix
//
//  Created by Tiffany Ma on 7/2/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.title = dictionary[@"title"];
    self.posterURL = dictionary[@"poster_path"];
    self.blurb = dictionary[@"overview"];
    self.releaseDate = dictionary[@"release_date"];
    self.backDropURL = dictionary[@"backdrop_path"];
    self.idString = dictionary[@"id"];
    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *movies;
    for(NSDictionary *dictionary in dictionaries){
        [movies addObject:[[Movie alloc]initWithDictionary:dictionary]];
    }
    return movies;
}
@end

