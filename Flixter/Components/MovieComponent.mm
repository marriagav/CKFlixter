//
//  MovieComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "MovieComponent.h"
#import "PosterComponent.h"

@implementation MovieComponent

+ (instancetype)newWithMovie:(Movie *)movie
             imageDownloader:(ImageDownloader *)imageDownloader
                      action:(const CKAction<UIGestureRecognizer *> &)action {
    const CKComponentSize imageSize = {
        .width = 100,
        .height = 120
    };
    
    const CKComponentSize synopsisSize = {
        .width = 210,
        .height = 80
    };
    
    CKLabelComponent *titleLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.title,
        .font = [UIFont systemFontOfSize:20 weight:0.5],
        .color = [UIColor redColor]
    } viewAttributes:{{@selector(setUserInteractionEnabled:), @NO}} size:{}];
    
    CKLabelComponent *overviewLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.overview,
        .font = [UIFont systemFontOfSize:15],
        .lineBreakMode = NSLineBreakByTruncatingTail,
    } viewAttributes:{ {@selector(setUserInteractionEnabled:), @NO}} size:{}];
    
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
            .child([PosterComponent newWithUrl:movie.posterUrl
                               imageDownloader:imageDownloader
                                          size:imageSize])
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
    
    return [super newWithComponent:containerComponent];
}

@end
