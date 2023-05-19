//
//  MovieDetailsViewController.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 19/05/23.
//

#import <UIKit/UIKit.h>
#import <ComponentKit/CKComponent.h>
#import "Movie.h"

@class ImageDownloader;

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailsViewController : UIViewController

+ (instancetype)viewControlerWithMovie:(Movie *)movie imageDownloader:(ImageDownloader *)imageDownloader;

@end

NS_ASSUME_NONNULL_END
