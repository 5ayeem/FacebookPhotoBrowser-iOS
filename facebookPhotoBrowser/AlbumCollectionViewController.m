//
//  AlbumViewController.m
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 4/5/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import "AlbumCollectionViewController.h"
#import "AlbumCoverCell.h"
#import "FacebookPhotoBrowser.h"
#import "PhotoCollectionViewController.h"

@interface AlbumCollectionViewController () {
    FacebookPhotoBrowser *fbBrowser;
}

@end

@implementation AlbumCollectionViewController

- (void)_commonInit
{
    // Custom initialization
    fbBrowser = [[FacebookPhotoBrowser alloc] initWithDelegate:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                             
- (void)didPopulateAlbums:(NSArray *)albums
{
    NSLog(@"delegate: didPopulateAlbums");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)didPopulatePhotosForAlbum:(PhotoAlbum *)album
{
    NSLog(@"delegate: didPopulatePhotosForAlbum");
}

- (void)didAuthenticate
{
    NSLog(@"delegate: didAuthenticate");
}

- (void)didFailToAuthenticate
{
    NSLog(@"delegate: didFailToAuthenticate");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[fbBrowser albums] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"albumCover";
    AlbumCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [fbBrowser getCoverForAlbum:[[fbBrowser albums] objectAtIndex:indexPath.row] withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.image.contentMode = UIViewContentModeScaleAspectFill;
            cell.image.alpha = 0.0f;
            cell.image.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                cell.image.alpha = 1.0f;
            }];
        });
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoCollectionViewController"];
    vc.album = [[fbBrowser albums] objectAtIndex:indexPath.row];
    vc.fbBrowser = fbBrowser;
    vc.albumIndex = indexPath.row;
    [[self navigationController] pushViewController:vc animated:YES];
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
