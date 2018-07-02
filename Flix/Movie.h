//
//  Movie.h
//  Flix
//
//  Created by Tiffany Ma on 7/2/18.
//  Copyright © 2018 Tiffany Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *posterURL;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *backDropURL;
@property (nonatomic, strong) NSString *idString;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;
@end
