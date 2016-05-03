//
//  PhotoAlbumProtocol.h
//  SlingDialClient
//
//  Created by Sayeem Hussain on 3/26/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoAlbum : NSObject

/**
 Photo album title.
 */
@property (nonatomic,copy) NSString* title;

/**
 Photo album date.
 */
@property (nonatomic) NSDate* date;

/**
 Array of photos in album (Photo class objects).
 */
@property (nonatomic, strong) NSArray* photos;

/**
 album id
 */
@property (nonatomic, copy) NSString* album_id;

@end