//
//  PosterComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import "PosterComponent.h"

@implementation PosterComponent

+(instancetype)newWithUrl:(NSURL *)url imageDownloader:(ImageDownloader *)imageDownloader size:(CKComponentSize)size{
    
    CKComponent *component = CK::InsetComponentBuilder()
        .insetsTop(0)
        .insetsLeft(0)
        .insetsBottom(0)
        .insetsRight(0)
        .component(

                    [CKNetworkImageComponent newWithURL:url imageDownloader:imageDownloader size:size options:{} attributes:{}])
                   .build();
    
    return [super newWithComponent:component];
    
}

@end
