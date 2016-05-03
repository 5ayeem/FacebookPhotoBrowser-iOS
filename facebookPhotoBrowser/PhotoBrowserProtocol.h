//
//  PhotoBrowserProtocol.h
//  SlingDialClient
//
//  Created by Sayeem Hussain on 3/26/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoBrowserProtocol <NSObject>

/**
 Array of albums.
 */
@property (readonly) NSArray* albums;

@end
