//
//  MovieDetailsComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 20/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "Movie.h"
#import "ImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailsComponent : CKCompositeComponent

+(instancetype)newWithMovie:(Movie*)movie imageDownloader:(ImageDownloader *)imageDownloader padding:(CKFlexboxSpacing)padding;

//@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
