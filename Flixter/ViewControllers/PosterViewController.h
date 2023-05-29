//
//  PosterViewController.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import <UIKit/UIKit.h>

@class ImageDownloader;
@class Movie;

@class ImageDownloader;

NS_ASSUME_NONNULL_BEGIN

@interface PosterViewController : UIViewController

+ (instancetype)viewController;
- (void)onTap:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
