//
//  NetworkManager.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 15/05/23.
//

#import "NetworkManager.h"


// api_key=

@implementation NetworkManager

#pragma mark Shared base URL

+ (NetworkManager *)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.baseUrl = @"https://api.themoviedb.org/3";
        sharedInstance.API_KEY = @"b6f1fc6c25b5e5eb4ff322d17852b3b7";
    });
    return sharedInstance;
}

- (void) getFromEndpoint:(NSString *)endpoint completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?api_key=%@", self.baseUrl, endpoint, self.API_KEY];
    
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

#pragma mark Argument URL

+ (void) getFromUrl:(NSURL *)url completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion{
    
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

+ (void) getImageFromUrl:(NSURL *)url completion:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion{
    
    [self getFromUrl:url completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            completion(nil, error);
        } else {
            completion([UIImage imageWithData:data],nil);
        }
    }];
}


@end



//example
/*
 NetworkManager *networkManager = [NetworkManager sharedInstance];
 [networkManager get:@"posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV" completion:^(NSData * _Nullable data, NSError * _Nullable error) {
 if (error != nil) {
 NSLog(@"%@", [error localizedDescription]);
 }
 else {
 NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
 
 // Get the dictionary from the response key
 NSDictionary *responseDictionary = dataDictionary[@"response"];
 // Store the returned array of dictionaries in our posts property
 self.posts = responseDictionary[@"posts"];
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.postsTableView reloadData];
 });
 }
 }];
 */
