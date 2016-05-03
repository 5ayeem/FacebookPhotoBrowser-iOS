//
//  PhotoCollectionViewController.m
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 4/9/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCell.h"
#import "PhotoScrollViewController.h"

@implementation PhotoCollectionViewController

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self album] photos] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"photo";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Photo *photo = [self.album.photos objectAtIndex:indexPath.row];
    [[self fbBrowser] getThumbnailForPhoto:photo withCompletionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photo.contentMode = UIViewContentModeScaleAspectFill;
            cell.photo.alpha = 0.0f;
            cell.photo.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                cell.photo.alpha = 1.0f;
            }];
        });
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoScrollViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScrollView"];
    vc.photoCount = [self.album.photos count];
//    NSLog(@"THIS IS THE COUNT: %d", vc.photoCount);
    vc.albumIndex = [self albumIndex];
//    NSLog(@"THIS IS THE ALBUM INDEX: %d", vc.albumIndex);
    vc.startIndex = indexPath.row;
//    NSLog(@"THIS IS THE INDEX PATH: %d", indexPath.row);
    vc.fbBrowser = [self fbBrowser];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
