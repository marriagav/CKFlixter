//
//  HelloWorldComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import "HelloWorldComponent.h"
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKBackgroundLayoutComponent.h>
#import <ComponentKit/CKInsetComponent.h>

@implementation HelloWorldComponent

+ (instancetype)newWithText:(NSString *)text{
    CKLabelComponent *component = [CKLabelComponent newWithLabelAttributes:{
        .string = text,
        .font = [UIFont fontWithName:@"AmericanTypewriter" size:26]
    } viewAttributes:{
        {@selector(setBackgroundColor:), [UIColor clearColor]},
        {@selector(setUserInteractionEnabled:), @NO}
        
        //{@selector(setTextAlignment:), @(NSTextAlignmentCenter)},
        //{@selector(setLineBreakMode:), @(NSLineBreakByWordWrapping)},
        //{@selector(setFontSize:), @(26.0)},
    
    } size: CKComponentSize::fromCGSize([UIScreen mainScreen].bounds.size)];
    
    
    /*
    CKBackgroundLayoutComponent *backgroundComponent =
    [CKBackgroundLayoutComponent
     newWithComponent:component
     background:
         [CKComponent
          newWithView:
              {
        [UIView class],
        {
            {
                @selector(setBackgroundColor:), [UIColor whiteColor]
            },
            {
                CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), @0.0
            }
        }
    }
          size:{}]];
    
    CKInsetComponent *insetComponent =
    [CKInsetComponent
     newWithInsets:{.top = 10, .bottom = 10, .left = 10, .right = 10}
     component:backgroundComponent
    ];
     */
    
    return [super newWithComponent:component];
    
}



@end

