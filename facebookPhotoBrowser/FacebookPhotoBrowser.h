//
//  FacebookPhotoBrowser.h
//  SlingDialClient
//
//  Created by Sayeem Hussain on 3/26/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoBrowserProtocol.h"
#import "Photo.h"

@class PhotoAlbum;

@protocol FacebookPhotoBrowserDelegate <NSObject>

@optional

- (void)didPopulateAlbums:(NSArray *)albums;
- (void)didPopulatePhotosForAlbum:(PhotoAlbum *)album;
- (void)didAuthenticate;
- (void)didFailToAuthenticate;

@end

@interface FacebookPhotoBrowser : NSObject<PhotoBrowserProtocol>

@property (assign, nonatomic, getter =isAvailable) BOOL available;
@property (weak, nonatomic) id<FacebookPhotoBrowserDelegate> delegate;

- (id)initWithDelegate:(id<FacebookPhotoBrowserDelegate>)delegate;
- (void)getCoverForAlbum:(PhotoAlbum *)album withCompletionHandler:(void(^)(UIImage *image))completion;
- (void)getThumbnailForPhoto:(Photo *)photo withCompletionHandler:(void(^)(UIImage *image))completion;

@end
