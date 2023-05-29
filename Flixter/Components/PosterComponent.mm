//
//  PosterComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import "PosterComponent.h"
#import "CKComponentSubclass.h"
#import "NetworkManager.h"

@implementation PosterComponent

+ (id)initialState
{
    NSMutableDictionary<NSString *, id> *states = [NSMutableDictionary dictionaryWithDictionary:@{@"image": [UIImage new], @"imageDidLoad": @false}];
    return states;
}


+ (instancetype)newWithMovie:(Movie *)movie
                      action:(const CKAction<UIGestureRecognizer *> &)action {
    
    CKComponentScope scope(self);
    NSDictionary *state = scope.state();
    UIImage *image = state[@"image"];
    
    const CKComponentSize imageSize = {
        .width = 110,
        .height = 150
    };
    
    CKImageComponent *posterImageComponent  = [CKImageComponent
                                               newWithView:{
        [UIImageView class],
        {
            {@selector(setImage:), image},
            {@selector(setContentMode:), @(UIViewContentModeScaleAspectFit)},
            {@selector(setClipsToBounds:), @YES}
        }
    }
                                               size:{imageSize}];
    
    CKComponent *containerComponent = [CKCompositeComponent newWithView:{
        [UIView class],
        {CKComponentTapGestureAttribute(action)}
    } component:posterImageComponent];
    
    PosterComponent *PosterComponent = [super newWithComponent:containerComponent];
    [PosterComponent loadImageWithUrl:movie.posterUrl];
    return PosterComponent;
}

- (void)loadImageWithUrl:(NSURL*)posterUrl
{
    // Check if the image has already been loaded
    NSDictionary *currentState = self.state;
    BOOL imageDidLoad = [currentState[@"imageDidLoad"] boolValue];

    if (imageDidLoad){
        return;
    }

    [NetworkManager getImageFromUrl:posterUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error){
            //TODO: handle error
            NSLog(@"%@", error.description);
        }
        else{
            [self updateState:^(NSMutableDictionary<NSString *, id>* oldState){
                NSMutableDictionary *newState = [NSMutableDictionary dictionaryWithDictionary:@{@"image": image, @"imageDidLoad": @true}];
                return newState;
            } mode:CKUpdateModeAsynchronous];
        }
    }];
}

@end
