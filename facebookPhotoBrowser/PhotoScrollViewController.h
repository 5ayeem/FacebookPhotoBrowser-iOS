//
//  PhotoScrollViewController.h
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 4/18/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookPhotoBrowser.h"

@interface PhotoScrollViewController : UIPageViewController <UIPageViewControllerDataSource>

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger albumIndex;
@property (weak, nonatomic) FacebookPhotoBrowser *fbBrowser;
@property (nonatomic, assign) NSInteger photoCount;

@end
