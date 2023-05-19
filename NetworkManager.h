//
//  NetworkManager.h
//  tumblr
//
//  Created by Miguel Arriaga Velasco on 15/05/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

@property NSString* baseUrl;
+ (NetworkManager *)sharedInstance;
- (void)get:(NSString *)endpoint completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;


@end

NS_ASSUME_NONNULL_END
