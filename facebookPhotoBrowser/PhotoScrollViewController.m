//
//  PhotoScrollViewController.m
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 4/18/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import "PhotoScrollViewController.h"
#import "PhotoAlbum.h"
#import "PhotoViewController.h"

@interface PhotoScrollViewController ()

@end

@implementation PhotoScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.dataSource = self;
//    NSLog(@"viewDidLoad photoIndex: %d", _startIndex);
    PhotoViewController *photoView = [self viewControllerAtIndex:_startIndex];
    [self setViewControllers:@[photoView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(PhotoViewController *)viewController index] + 1;
    if (index > (_photoCount - 1)) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(PhotoViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (PhotoViewController *)viewControllerAtIndex:(NSInteger)index
{
    PhotoViewController *photoView = [[PhotoViewController alloc] init];
    photoView.index = index;
    PhotoAlbum *album = [[self.fbBrowser albums] objectAtIndex:self.albumIndex];
    Photo *photo = [album.photos objectAtIndex:index];
    [_fbBrowser getThumbnailForPhoto:photo withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            photoView.imgView.image = image;
        });
    }];
    return photoView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
