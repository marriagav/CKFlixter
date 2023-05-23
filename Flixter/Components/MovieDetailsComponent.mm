//
//  MovieDetailsComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 20/05/23.
//

#import "MovieDetailsComponent.h"
#import "PosterComponent.h"

@implementation MovieDetailsComponent

+ (instancetype)newWithMovie:(Movie *)movie
             imageDownloader:(ImageDownloader *)imageDownloader
                     padding:(CKFlexboxSpacing)padding{
    const CKComponentSize imageSize = {
        .width = 100,
        .height = 120
    };
    
    const CKComponentSize backgroundImageSize = {
        .width = [UIScreen mainScreen].bounds.size.width,
        .height = 200
    };
    
    
    const CKComponentSize rowSize = {
        .width = [UIScreen mainScreen].bounds.size.width-imageSize.width.value()-50,
        //        .height = 80
    };
    
    //    CKAutoSizedImageComponent. sizeOption;
    //    sizeOption.mode = CKComponentSizeModeOptional;
    //    sizeOption.size = imageSize;
    
    UIViewContentModeScaleAspectFit
    //[CKImageComponent newWithImage:[UIImage imageNamed:@"hols" inBundle:{} withConfiguration:[UIImageConfiguration UIViewContentModeScaleAspectFit]] attributes:{} size:{}];
    
    //CKNetworkImageComponent *backgroundImage = [CKNetworkImageComponent newWithURL:movie.posterUrl imageDownloader:imageDownloader size:backgroundImageSize options:{} attributes:{}];
    
    [CKAutoSizedImageComponent newWithComponent:backgroundImage];
    
    CKFlexboxComponent *backgroundImageContainer = CK::FlexboxComponentBuilder().child(backgroundImage).positionType(CKFlexboxPositionTypeAbsolute).positionTop(0)
        .build();
    
    CKLabelComponent *titleLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.title,
        .font = [UIFont systemFontOfSize:20 weight:0.5],
        .color = [UIColor redColor],
        .lineBreakMode = NSLineBreakByTruncatingTail,
    } viewAttributes:{{@selector(setUserInteractionEnabled:), @NO}} size:{rowSize}];
    
    CKLabelComponent *overviewLabel = [CKLabelComponent newWithLabelAttributes:{
        .string = movie.overview,
        .font = [UIFont systemFontOfSize:15],
        .lineBreakMode = NSLineBreakByTruncatingTail,
    } viewAttributes:{ {@selector(setUserInteractionEnabled:), @NO}} size:{}];
    
//    CKImageComponentOptions *imageOptions = [CKImageComponentOptions new];
//    imageOptions.contentMode = UIViewContentModeScaleAspectFit;
    
    CKFlexboxComponent *component = CK::FlexboxComponentBuilder()
        .alignItems(CKFlexboxAlignItemsCenter)
        .justifyContent(CKFlexboxJustifyContentStart)
        .direction(CKFlexboxDirectionRow)
        .spacing(10)
        .child([CKNetworkImageComponent newWithURL:movie.posterUrl imageDownloader:imageDownloader size:imageSize options:{} attributes:{}])
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
//                                      {CKComponentTapGestureAttribute(action)}
                                  }
                                  size:{}
                                  style:{}
                                  children:{
                                    {backgroundImageContainer},{paddedComponent}
                                  }];
    
    return [super newWithComponent:componentView];
}


@end
