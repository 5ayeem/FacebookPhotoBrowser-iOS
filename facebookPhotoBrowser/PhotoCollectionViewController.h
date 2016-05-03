//
//  PhotoCollectionViewController.h
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 4/9/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"
#import "FacebookPhotoBrowser.h"

@interface PhotoCollectionViewController : UICollectionViewController

@property (weak, nonatomic) PhotoAlbum *album;
@property (weak, nonatomic) FacebookPhotoBrowser *fbBrowser;
@property (assign, nonatomic) NSInteger albumIndex;

@end
