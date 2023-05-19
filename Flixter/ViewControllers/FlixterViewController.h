//
//  FlixterViewController.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import <UIKit/UIKit.h>
#import <ComponentKit/CKComponent.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlixterViewController : UIViewController

+ (instancetype)viewController;
- (void)onTap:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
