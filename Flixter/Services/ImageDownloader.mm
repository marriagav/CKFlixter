//
//  PAImageDownloader.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 17/05/23.
//

#import "ImageDownloader.h"
#import "NetworkManager.h"

@implementation ImageDownloader
- (id)downloadImageWithURL:(NSURL *)URL
                    caller:(id)caller
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion;
{
    
    [NetworkManager getImageFromUrl:URL completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
        dispatch_async(callbackQueue, ^{
            if (error) {
                completion(nil, error);
            } else {
                completion(image.CGImage, nil);
            }
        });
    }];
    return [URL absoluteString];
}

- (void)cancelImageDownload:(id)download;
{}
@end
