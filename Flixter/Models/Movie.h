//
//  Movie.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSURL *posterUrl;


- (instancetype)initWithTitle:(NSString *)title
                    overview:(NSString *)overview
                   posterUrl:(NSURL *)posterUrl;

@end

NS_ASSUME_NONNULL_END
