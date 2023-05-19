//
//  MoviesViewModel.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoviesViewModel : NSObject

@property (nonatomic, strong) NSArray<Movie*> *movies;

- (instancetype)initWithMovies:(NSArray<Movie*>*)movies;
- (instancetype)init;
- (void)fetchMoviesWithCompletion: (void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
