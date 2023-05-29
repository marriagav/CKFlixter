//
//  PostersContainerComponent.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 28/05/23.
//

#import "PostersContainerComponent.h"
#import "PosterComponent.h"

@implementation PostersContainerComponent

+(instancetype)newWithMovies:(NSArray<Movie*>*)movies sender:(PosterViewController *)sender padding:(CKFlexboxSpacing)padding{
    
       std::vector<CKFlexboxComponentChild> children;

       for (Movie *movie in movies) {
           CKAction<UIGestureRecognizer *>action = CKAction<UIGestureRecognizer *>::actionFromBlock(^(CKComponent *, UIGestureRecognizer *__strong) {
               [sender onTap:movie];
           });
           PosterComponent *posterComponent = [PosterComponent newWithMovie:movie action:action];
           CKFlexboxComponentChild child = {posterComponent};
           children.push_back(child);
       }
    
        CKComponent *flexboxComponent =  CK::FlexboxComponentBuilder()
            .alignItems(CKFlexboxAlignItemsCenter)
            .justifyContent(CKFlexboxJustifyContentCenter)
            .direction(CKFlexboxDirectionRow)
            .spacing(10)
            .children(std::move(children))
            .build();
    
        CKComponent *insetsComponent = CK::InsetComponentBuilder()
            .insetsTop(padding.top.dimension().value())
            .insetsLeft(padding.start.dimension().value())
            .insetsBottom(padding.bottom.dimension().value())
            .insetsRight(padding.end.dimension().value())
            .component(
                flexboxComponent
            )
            .build();
    
        CKComponent *containerComponent = [CKCompositeComponent newWithView:{
            [UIView class]
        } component:insetsComponent];
        
        PostersContainerComponent *PostersComponent = [super newWithComponent:containerComponent];
        return PostersComponent;
}

@end
