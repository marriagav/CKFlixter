//
//  HelloWorldComponent.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import <ComponentKit/CKCompositeComponent.h>

//@class HelloWorldComponent;

/**
 A frosted quote component vertically stacks a quote and a " symbol and places it on a background.
 */
@interface HelloWorldComponent : CKCompositeComponent

+ (instancetype)newWithText:(NSString *)text;

@end
