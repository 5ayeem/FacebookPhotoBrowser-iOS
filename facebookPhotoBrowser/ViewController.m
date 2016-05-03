//
//  ViewController.m
//  FacebookPhotoBrowser
//
//  Created by Sayem Hussain on 3/31/14.
//  Copyright (c) 2014 ___sayeem.hussain___. All rights reserved.
//

#import "ViewController.h"
//#import "FacebookPhotoBrowser.h"
#import "AlbumCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)slideShow:(id)sender
{
    AlbumCollectionViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
