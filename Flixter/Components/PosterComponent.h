//
//  PosterComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "ImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterComponent : CKCompositeComponent

+(instancetype)newWithUrl:(NSURL*)url imageDownloader:(ImageDownloader *)imageDownloader size:(CKComponentSize)size;

@end

NS_ASSUME_NONNULL_END
