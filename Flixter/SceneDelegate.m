//
//  SceneDelegate.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import "SceneDelegate.h"
#import "FlixterViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    _window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];

//    UIViewController *viewController = [FlixterViewController new];
//    viewController.view.backgroundColor = [UIColor whiteColor];
//
    //viewController.navigationItem.rightBarButtonItem = [self makeBarButtonItem];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
//    label.text = @"Hello, ComponentKit!";
//    [viewController.view addSubview:label];
//
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
    
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    [flowLayout setMinimumInteritemSpacing:0];
//    [flowLayout setMinimumLineSpacing:0];
//
//    FlixterViewController *viewController = [FlixterViewController new];
//    viewController.view.backgroundColor = [UIColor whiteColor];
//    _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [_window makeKeyAndVisible];
//
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[FlixterViewController viewController]];
    [self.window makeKeyAndVisible];
    
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
