//
//  SceneDelegate.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import "SceneDelegate.h"
#import "FlixterViewController.h"
#import "PosterViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    _window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    _tabBarController = [[UITabBarController alloc] init];

    UIViewController *VC1 = [FlixterViewController viewController];
    VC1.title = @"Playing now";
    UINavigationController *VC1Navigation = [[UINavigationController alloc]
                                                initWithRootViewController:VC1];
    
    VC1Navigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"house"] tag:0];

    UIViewController *VC2 = [PosterViewController viewController];
    VC2.title = @"Posters";
    UINavigationController *VC2Navigation = [[UINavigationController alloc]
                                                initWithRootViewController:VC2];
    VC2Navigation.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage systemImageNamed:@"photo.on.rectangle"] tag:1];

    NSArray* controllers = [NSArray arrayWithObjects:VC1Navigation, VC2Navigation, nil];
    _tabBarController.viewControllers = controllers;
    _window.rootViewController = self.tabBarController;
    [_window makeKeyAndVisible];
    
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
