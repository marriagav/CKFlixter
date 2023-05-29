//
//  PosterComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 18/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterComponent : CKCompositeComponent

+ (instancetype)newWithMovie:(Movie *)movie
                      action:(const CKAction<UIGestureRecognizer *> &)action;

@end

NS_ASSUME_NONNULL_END
