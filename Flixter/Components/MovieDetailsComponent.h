//
//  MovieDetailsComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 20/05/23.
//

#import <ComponentKit/ComponentKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailsComponent : CKCompositeComponent

+(instancetype)newWithMovie:(Movie*)movie padding:(CKFlexboxSpacing)padding;

@end

NS_ASSUME_NONNULL_END
