//
//  SocialWebService.m
//  SlingDialClient
//
//  Created by Sayem Hussain on 3/27/14.
//  Copyright (c) 2014 Sayeem Hussain. All rights reserved.
//

#import "FacebookWebService.h"
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountType.h>
#import <Social/Social.h>

NSString * const SLFacebookAppIdKey = @"626168677469888";
NSString * const SLFacebookTestAppIdKey = @"648954715191284";

@implementation FacebookWebService {
    ACAccount *_facebookAccount;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)authenticateWithCompletionHandler:(void (^)(BOOL granted, NSError *error))completion
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{
                              ACFacebookAppIdKey: SLFacebookAppIdKey,
                              ACFacebookPermissionsKey: @[@"email", @"user_photos"],
                              ACFacebookAudienceKey: ACFacebookAudienceOnlyMe
                              };
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options completion:^(BOOL granted, NSError *e) {
                                              if (granted) {
                                                  NSArray *accounts = [accountStore
                                                                       accountsWithAccountType:facebookAccountType];
                                                  // iOS only supports one FB account - so hard coded lastObject
                                                  _facebookAccount = [accounts lastObject];
                                                  NSLog(@"Did authenticate: %@", accounts);
                                              } else {
                                                  NSLog(@"Did not authenticate: %@", e);
                                              }
                                              completion(granted, e);
                                          }];
}

- (void)getCoverForAlbum:(NSString *)albumIdentifier withCompletionHandler:(void(^)(UIImage *image))completion
{
    NSString *base = @"https://graph.facebook.com/";
    NSString *endPoint = @"/picture";
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", base, albumIdentifier, endPoint];
    NSURL *albumURL = [NSURL URLWithString:URLString];
    
    SLRequest *coverRequest = [SLRequest
                             requestForServiceType:SLServiceTypeFacebook
                             requestMethod:SLRequestMethodGET
                             URL:albumURL
                             parameters:nil];

    coverRequest.account = _facebookAccount;

    [coverRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        completion([UIImage imageWithData:responseData]);
    }];
}

- (void)getAlbumsWithCompletionHandler:(void (^)(NSArray *albums))completion
{
    NSURL *albumURL = [NSURL URLWithString:@"https://graph.facebook.com/me/albums"];
    
    SLRequest *picRequest = [SLRequest
                             requestForServiceType:SLServiceTypeFacebook
                             requestMethod:SLRequestMethodGET
                             URL:albumURL
                             parameters:nil];
    
    picRequest.account = _facebookAccount;
    
    [picRequest performRequestWithHandler:^(NSData *responseData,
                                            NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
         NSArray *albums = [data objectForKey:@"data"];
         completion(albums);
     }];
}

- (void)getPhotosForAlbumIdentifier:(NSString *)identifier completionHandler:(void (^)(NSArray *photos))completion
{
    NSURL *photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/photos", identifier]];
    
    SLRequest *picRequest = [SLRequest
                             requestForServiceType:SLServiceTypeFacebook
                             requestMethod:SLRequestMethodGET
                             URL:photoURL
                             parameters:nil];
    
    picRequest.account = _facebookAccount;
    
    [picRequest performRequestWithHandler:^(NSData *responseData,
                                            NSHTTPURLResponse *urlResponse, NSError *error)
     {
         NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
         NSArray *photos = [data objectForKey:@"data"];
         completion(photos);
     }];
}

- (void)getThumbnailForPhoto:(NSString *)URL withCompletionHandler:(void(^)(UIImage *image))completion
{
    NSURL *photoURL = [NSURL URLWithString:URL];
    SLRequest *picRequest = [SLRequest
                             requestForServiceType:SLServiceTypeFacebook
                             requestMethod:SLRequestMethodGET
                             URL:photoURL
                             parameters:nil];
    
    picRequest.account = _facebookAccount;
    
    [picRequest performRequestWithHandler:^(NSData *responseData,
                                            NSHTTPURLResponse *urlResponse, NSError *error)
     {
         completion([UIImage imageWithData:responseData]);
     }];
}

@end
