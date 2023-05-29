//
//  PostersContainerComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 28/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "Movie.h"
#import "PosterViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostersContainerComponent : CKCompositeComponent

+(instancetype)newWithMovies:(NSArray<Movie*>*)movies sender:(PosterViewController *)sender padding:(CKFlexboxSpacing)padding;

@end

NS_ASSUME_NONNULL_END
