//
//  NetworkManager.m
//  tumblr
//
//  Created by Miguel Arriaga Velasco on 15/05/23.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (NetworkManager *)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.baseUrl = @"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/";
    });
    return sharedInstance;
}

- (void) get:(NSString *)endpoint completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, endpoint];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                completion(nil, error);
            } else {
                completion(data, nil);
            }
        }];
        [task resume];
}

@end
