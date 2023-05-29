//
//  MovieComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "Movie.h"
#import "ImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieComponent : CKCompositeComponent

+(instancetype)newWithMovie:(Movie*)movie action:(const CKAction<UIGestureRecognizer *> &)action;

@end

NS_ASSUME_NONNULL_END
