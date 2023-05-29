//
//  MovieDetailsComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 20/05/23.
//

#import "MovieDetailsComponent.h"
#import "PosterComponent.h"
#import "CKComponentSubclass.h"
#import "NetworkManager.h"


@implementation MovieDetailsComponent

+ (id)initialState
{
    NSMutableDictionary<NSString *, id> *states = [NSMutableDictionary dictionaryWithDictionary:@{@"image": [UIImage new], @"imageDidLoad": @false}];
    return states;
}

+ (instancetype)newWithMovie:(Movie *)movie
                     padding:(CKFlexboxSpacing)padding{
    
    CKComponentScope scope(self);
    NSDictionary *state = scope.state();
    BOOL imageDidLoad = [state[@"imageDidLoad"] boolValue];
    UIImage *image = state[@"image"];
    
    const CKComponentSize imageSize = {
        .width = 110,
        .height = 150
    };
    
    const CKComponentSize backgroundImageSize = {
        .width = [UIScreen mainScreen].bounds.size.width,
        .height = 200
    };
    
    
    const CKComponentSize rowSize = {
        .width = [UIScreen mainScreen].bounds.size.width-imageSize.width.value()-50,
    };
    
    CKComponent *backgroundImageComponent = [CKLabelComponent newWithLabelAttributes:{
        .string = @"Loading...",
        .font = [UIFont systemFontOfSize:20 weight:0.5],
        .lineBreakMode = NSLineBreakByTruncatingTail,
    } viewAttributes:{{@selector(setUserInteractionEnabled:), @NO}} size:{backgroundImageSize}];
    
    
    if (imageDidLoad){
        backgroundImageComponent  = [CKImageComponent
                                                  newWithView:{
            [UIImageView class],
            {
                {@selector(setImage:), image},
                {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
                {@selector(setClipsToBounds:), @YES}
            }
        }
                                                  size:{backgroundImageSize}];
    }
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
    
    CKFlexboxComponent *backgroundImageContainer = CK::FlexboxComponentBuilder().child(backgroundImageComponent).positionType(CKFlexboxPositionTypeAbsolute).positionTop(0).direction(CKFlexboxDirectionColumn).justifyContent(CKFlexboxJustifyContentCenter).alignItems(CKFlexboxAlignItemsCenter)
        .view({
            [UIView class],
        })
        .build();
    
    
    CKLabelComponent *titleLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.title,
        .font = [UIFont systemFontOfSize:20 weight:0.5],
        .color = [UIColor redColor],
        .lineBreakMode = NSLineBreakByTruncatingTail,
    } viewAttributes:{{@selector(setUserInteractionEnabled:), @NO},{@selector(setBackgroundColor:), [UIColor clearColor]}} size:{rowSize}];
    
    CKLabelComponent *overviewLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.overview,
        .font = [UIFont systemFontOfSize:15],
        .lineBreakMode = NSLineBreakByTruncatingTail,
        .color = [UIColor labelColor]
    } viewAttributes:{ {@selector(setUserInteractionEnabled:), @NO},{@selector(setBackgroundColor:), [UIColor clearColor]}} size:{}];
    
    CKFlexboxComponent *component = CK::FlexboxComponentBuilder()
        .alignItems(CKFlexboxAlignItemsCenter)
        .justifyContent(CKFlexboxJustifyContentStart)
        .direction(CKFlexboxDirectionRow)
        .spacing(10)
        .child(posterImageComponent)
        .child(
               titleLabel
               )
        .build();
    
    CKFlexboxComponent *componentParent =
    CK::FlexboxComponentBuilder()
        .alignItems(CKFlexboxAlignItemsStart)
        .justifyContent(CKFlexboxJustifyContentCenter)
        .direction(CKFlexboxDirectionColumn)
        .spacing(10)
        .children({{component},{overviewLabel}})
        .build();
    
    
    CKComponent *paddedComponent = CK::InsetComponentBuilder()
        .insetsTop(padding.top.dimension().value()+150)
        .insetsLeft(padding.start.dimension().value())
        .insetsBottom(padding.bottom.dimension().value())
        .insetsRight(padding.end.dimension().value())
        .component(componentParent)
        .build();
    
    CKFlexboxComponent *componentView = [CKFlexboxComponent
                                         newWithView:{
        [UIView class],
    }
                                         size:{}
                                         style:{}
                                         children:{
        {backgroundImageContainer},{paddedComponent}
    }];
    
    MovieDetailsComponent *moviesComponent= [super newWithComponent:componentView];
    [moviesComponent loadImageWithUrl:movie.posterUrl];
    return moviesComponent;
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
