//
//  RootComponentProvider.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "RootComponentProvider.h"
#import "HelloWorldComponent.h"
#import "Movie.h"
#import "MovieComponent.h"
#import "FlixterViewController.h"

@implementation RootComponentProvider
//
+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context;
{
    if ([model isKindOfClass:[NSNull class]]) {
        return [RootComponentProvider stringComponent];
    }else if([model isKindOfClass:[Movie class]]){
        return [RootComponentProvider movieComponentWithMovie:model sender:(FlixterViewController *)context];
    }
    else {
        NSAssert(NO, @"Should not happen");
        return nil;
    }
}

+ (CKComponent *)stringComponent
{
    return [HelloWorldComponent newWithText:@"Hello World"];
}

+ (CKComponent *)movieComponentWithMovie:(Movie *)model sender:(FlixterViewController *)sender
{
    
    CKAction<UIGestureRecognizer *>action = CKAction<UIGestureRecognizer *>::actionFromBlock(^(CKComponent *, UIGestureRecognizer *__strong) {
        [sender onTap:model];
    });
    
    return [MovieComponent
            newWithMovie:model
            imageDownloader:sender.imageDownloader
            action: action];
}

@end
