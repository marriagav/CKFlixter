//
//  MoviesViewModel.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import "MoviesViewModel.h"
#import "NetworkManager.h"

@implementation MoviesViewModel

- (instancetype)initWithMovies:(NSArray<Movie *> *)movies {
    self = [super init];
    if (self) {
        _movies = movies;
    }
    return self;
}

- (instancetype)init {
    return [self initWithMovies:@[]];
}

- (void)fetchMoviesWithCompletion: (void (^)(NSData * _Nullable data, NSError * _Nullable error))completion{
    NetworkManager *networkManager = [NetworkManager sharedInstance];
    [networkManager getFromEndpoint:@"movie/now_playing" completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        completion(data, error);
    }];
}


@end
