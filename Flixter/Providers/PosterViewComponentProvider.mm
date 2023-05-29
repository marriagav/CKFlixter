//
//  RootComponentProvider.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "PosterViewComponentProvider.h"
#import "Movie.h"
#import "PosterComponent.h"
#import "PosterViewController.h"
#import "PostersContainerComponent.h"

@implementation PosterViewComponentProvider
//
+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context;
{
    if([model isKindOfClass:[Movie class]]){
        return [PosterViewComponentProvider movieComponentWithMovie:model sender:(PosterViewController *)context];
    }else if([model isKindOfClass:[NSArray<Movie *> class]]){
        return [PosterViewComponentProvider moviesComponentWithMovies:model sender:(PosterViewController *)context];
    }
    else {
        NSAssert(NO, @"Should not happen");
        return nil;
    }
}

+ (CKComponent *)movieComponentWithMovie:(Movie *)model sender:(PosterViewController *)sender
{
    
    CKAction<UIGestureRecognizer *>action = CKAction<UIGestureRecognizer *>::actionFromBlock(^(CKComponent *, UIGestureRecognizer *__strong) {
        [sender onTap:model];
    });
    
    return [PosterComponent
            newWithMovie:model
            action: action];
}

+ (CKComponent *)moviesComponentWithMovies:(id<NSObject>)model sender:(PosterViewController *)sender
{
    if (![model isKindOfClass:[NSArray<Movie *> class]]) {
            NSAssert(NO, @"Model should be of type NSArray<Movie *> *");
            return nil;
        }

    NSArray<Movie *> *movies = (NSArray<Movie *> *)model;
    
    CKFlexboxSpacing padding = {
        .top = 10,    
        .bottom = 10,
        .start = 20,
        .end = 20,
    };

    return [PostersContainerComponent
            newWithMovies:movies sender:sender padding:padding];
}

@end
