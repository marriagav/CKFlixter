//
//  MovieComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "MovieComponent.h"
#import "CKComponentSubclass.h"
#import "NetworkManager.h"

@implementation MovieComponent

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
    
    
    const CKComponentSize synopsisSize = {
        .width = 210,
        .height = 80
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
    
    CKLabelComponent *titleLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.title,
        .font = [UIFont systemFontOfSize:20 weight:0.5],
        .color = [UIColor redColor]
    } viewAttributes:{{@selector(setUserInteractionEnabled:), @NO},{@selector(setBackgroundColor:), [UIColor clearColor]}} size:{}];
    
    CKLabelComponent *overviewLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.overview,
        .font = [UIFont systemFontOfSize:15],
        .lineBreakMode = NSLineBreakByTruncatingTail,
        .color = [UIColor labelColor],
    } viewAttributes:{ {@selector(setUserInteractionEnabled:), @NO}, {@selector(setBackgroundColor:), [UIColor clearColor]}} size:{}];
    
    CKComponent *component = CK::InsetComponentBuilder()
        .insetsTop(10)
        .insetsLeft(20)
        .insetsBottom(10)
        .insetsRight(20)
        .component(
            CK::FlexboxComponentBuilder()
            .alignItems(CKFlexboxAlignItemsCenter)
            .justifyContent(CKFlexboxJustifyContentStart)
            .direction(CKFlexboxDirectionRow)
            .spacing(10)
            .child(posterImageComponent)
            .child(
                CK::FlexboxComponentBuilder()
                .alignItems(CKFlexboxAlignItemsStart)
                .justifyContent(CKFlexboxJustifyContentCenter)
                .direction(CKFlexboxDirectionColumn)
                .spacing(5)
                .size(synopsisSize)
                .child(titleLabel)
                .child(overviewLabel)
                .build()
            )
            .build()
        )
        .build();
    
    CKComponent *containerComponent = [CKFlexboxComponent
        newWithView:{
            [UIView class],
            {CKComponentTapGestureAttribute(action)}
        }
        size:{}
        style:{}
        children:{
            {component}
        }];
    
    MovieComponent *movieComponent = [super newWithComponent:containerComponent];
    [movieComponent loadImageWithUrl:movie.posterUrl];
    return movieComponent;
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
