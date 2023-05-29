//
//  MovieDetailsViewController.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 19/05/23.
//

#import <UIKit/UIKit.h>
#import <ComponentKit/CKComponent.h>
#import "Movie.h"


NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailsViewController : UIViewController

+ (instancetype)viewControlerWithMovie:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
