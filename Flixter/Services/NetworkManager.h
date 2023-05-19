//
//  NetworkManager.h
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 15/05/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

@property NSString* baseUrl;
@property NSString *API_KEY;  //TODO: DELETE THIS

+ (NetworkManager *)sharedInstance;
- (void)getFromEndpoint:(NSString *)endpoint completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;

+ (void)getFromUrl:(NSURL *)urlString completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;
+ (void) getImageFromUrl:(NSURL *)urlString completion:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
