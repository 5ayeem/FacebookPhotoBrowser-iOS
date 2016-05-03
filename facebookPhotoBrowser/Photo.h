//
//  Photo.h
//  SlingDialClient
//
//  Created by Sayeem Hussain on 3/26/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

/**
 Photo fully qualified URL.
 */
@property (nonatomic, copy) NSString *url;

/**
 Photo title.
 */
@property (nonatomic, copy) NSString *title;

/**
 Photo date.
 */
@property (nonatomic) NSDate *date;

@end