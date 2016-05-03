//
//  SocialWebService.h
//  SlingDialClient
//
//  Created by Sayem Hussain on 3/27/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookWebService : NSObject

@property (weak, nonatomic) UIImage *image;

- (void)authenticateWithCompletionHandler:(void (^)(BOOL granted, NSError *error))completion;

- (void)getAlbumsWithCompletionHandler:(void (^)(NSArray *albums))completion;

- (void)getPhotosForAlbumIdentifier:(NSString *)identifier completionHandler:(void (^)(NSArray *photos))completion;

- (void)getCoverForAlbum:(NSString *)albumIdentifier withCompletionHandler:(void(^)(UIImage *image))completion;

- (void)getThumbnailForPhoto:(NSString *)URL withCompletionHandler:(void(^)(UIImage *image))completion;

@end
