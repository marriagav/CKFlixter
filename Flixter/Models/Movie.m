//
//  Movie.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "Movie.h"

@implementation Movie

- (instancetype) initWithTitle:(NSString *)title overview:(NSString *)overview posterUrl:(NSURL *)posterUrl{
    self = [super init];
    if (self) {
        _title = [title copy];
        _overview = [overview copy];
        _posterUrl = [posterUrl copy];
    }
    return self;
}

@end
