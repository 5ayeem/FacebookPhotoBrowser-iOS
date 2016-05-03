//
//  FacebookPhotoBrowser.m
//  SlingDialClient
//
//  Created bySayeem Hussain on 3/26/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import "FacebookPhotoBrowser.h"
#import "FacebookWebService.h"
#import "PhotoAlbum.h"
#import "Photo.h"
#import "AlbumCoverCell.h"

@implementation FacebookPhotoBrowser {
    FacebookWebService *_webService;
}

@synthesize albums = _albums;

- (void)_commonInit
{
    _webService = [[FacebookWebService alloc] init];
    [_webService authenticateWithCompletionHandler:^(BOOL granted, NSError *error) {
        if (_delegate) {
            if(granted) {
                if ([_delegate respondsToSelector:@selector(didAuthenticate)]) {
                    [_delegate didAuthenticate];
                }
            } else {
                if ([_delegate respondsToSelector:@selector(didFailToAuthenticate)]) {
                    [_delegate didFailToAuthenticate];
                }
            }
        }
        self.available = granted;
        if (_available) {
            [self _populateModel];
        }
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<FacebookPhotoBrowserDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        [self _commonInit];
    }
    return self;
}

- (void)_populateModel
{
    NSMutableArray *tempAlbums = [[NSMutableArray alloc] init];
    [_webService getAlbumsWithCompletionHandler:^(NSArray *albums) {
        dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
            if (_delegate && [_delegate respondsToSelector:@selector(didPopulateAlbums:)]) {
                [_delegate didPopulateAlbums:_albums];
            }
        });
        
        __block NSUInteger count = albums.count - 1;
        [albums enumerateObjectsUsingBlock:^(NSDictionary *albumDict, NSUInteger idx, BOOL *stop) {
            PhotoAlbum *album = [[PhotoAlbum alloc] init];
            album.title = [albumDict objectForKey:@"name"];
            album.date = [albumDict objectForKey:@"created_time"];
            album.album_id = [albumDict objectForKey:@"id"];
            [tempAlbums addObject:album];
            
            NSMutableArray *photoObjects = [[NSMutableArray alloc] init];
            [_webService getPhotosForAlbumIdentifier:album.album_id completionHandler:^(NSArray *photos) {
                [photos enumerateObjectsUsingBlock:^(NSDictionary *photoDict, NSUInteger idx, BOOL *stop) {
                    Photo *photo = [[Photo alloc] init];
                    NSString *name = [photoDict objectForKey:@"name"];
                    photo.title = name ? name : @"None";
                    photo.url = [photoDict objectForKey:@"source"];
                    photo.date = [photoDict objectForKey:@"created_time"];
                    [photoObjects addObject:photo];
                }];
                album.photos = photoObjects;
                
                if (_delegate && [_delegate respondsToSelector:@selector(didPopulatePhotosForAlbum:)]) {
                    [_delegate didPopulatePhotosForAlbum:album];
                }
                
                // Signal only when all albums are done being fetched
                if (count-- == 0) {
                    dispatch_semaphore_signal(dsema);
                }
            }];
        }];
        _albums = tempAlbums;
    }];
}

- (void)getCoverForAlbum:(PhotoAlbum *)album withCompletionHandler:(void(^)(UIImage *image))completion
{
    NSString *albumID = album.album_id;
    [_webService getCoverForAlbum:albumID withCompletionHandler:^(UIImage *image) {
        completion(image);
    }];
}

- (void)getThumbnailForPhoto:(Photo *)photo withCompletionHandler:(void(^)(UIImage *image))completion
{
    NSString *thumbnailURL = photo.url;
    [_webService getThumbnailForPhoto:thumbnailURL withCompletionHandler:^(UIImage *image) {
        completion(image);
    }];
}

@end
