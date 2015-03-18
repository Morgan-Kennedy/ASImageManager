//
//  ASImageManager.m
//  ASImageManager
//
//  Created by Morgan Kennedy on 2/02/2015.
/**
 ASImageManager can be downloaded from:
 https://github.com/Morgan-Kennedy/ASImageManager
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ASImageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface ASImageManager ()

@end

@implementation ASImageManager

#pragma mark -
#pragma mark - Lifecycle Methods
+ (ASImageManager *)sharedImageManager
{
    static ASImageManager *sharedImageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedImageManager = [[ASImageManager alloc] init];
    });
    return sharedImageManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark - ASImageCacheProtocol Methods
- (void)fetchCachedImageWithURL:(NSURL *)URL
                  callbackQueue:(dispatch_queue_t)callbackQueue
                     completion:(void (^)(CGImageRef imageFromCache))completion
{
    if (URL.absoluteString.length)
    {
        [[[SDWebImageManager sharedManager] imageCache] queryDiskCacheForKey:URL.absoluteString
                                                                        done:^(UIImage *image, SDImageCacheType cacheType) {
                                                                            if (callbackQueue)
                                                                            {
                                                                                UIImage __weak *weakImage = image;
                                                                                dispatch_async(callbackQueue, ^{
                                                                                    if (completion)
                                                                                    {
                                                                                        completion(weakImage.CGImage);
                                                                                    }
                                                                                });
                                                                            }
                                                                            else
                                                                            {
                                                                                completion(image.CGImage);
                                                                            }
        }];
    }
    else
    {
        if (callbackQueue)
        {
            dispatch_async(callbackQueue, ^{
                if (completion)
                {
                    completion(nil);
                }
            });
        }
        else
        {
            completion(nil);
        }
    }
}

#pragma mark -
#pragma mark - ASImageDownloaderProtocol Methods
- (id)downloadImageWithURL:(NSURL *)URL
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion
{
    return [[SDWebImageManager sharedManager] downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (downloadProgressBlock)
        {
            CGFloat progressPercent = (CGFloat)receivedSize / (CGFloat)expectedSize;
            
            if (callbackQueue)
            {
                dispatch_async(callbackQueue, ^{
                    downloadProgressBlock(progressPercent);
                });
            }
            else
            {
                downloadProgressBlock(progressPercent);
            }
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completion)
        {
            if (callbackQueue)
            {
                UIImage __weak *weakImage = image;
                NSError __weak *weakError = error;
                dispatch_async(callbackQueue, ^{
                    completion(weakImage.CGImage, weakError);
                });
            }
            else
            {
                completion(image.CGImage, error);
            }
        }
    }];
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier
{
    if ([[downloadIdentifier class] conformsToProtocol:@protocol(SDWebImageOperation)])
    {
        id<SDWebImageOperation> downloadOperation = downloadIdentifier;
        [downloadOperation cancel];
    }
}
@end
