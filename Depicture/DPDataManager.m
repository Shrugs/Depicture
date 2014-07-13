//
//  DPDataManager.m
//
//
//  Created by Matt Condon on 7/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPDataManager.h"

@implementation DPDataManager

@synthesize thisUser, focusedUser;

static DPDataManager * _sharedDataManager = nil;

+(DPDataManager *)sharedDataManager
{
    if (!_sharedDataManager) {
        _sharedDataManager = [[DPDataManager alloc] init];
//        [_sharedDataManager logoutUser];
        [_sharedDataManager initThisUser];
    }
    return _sharedDataManager;
}

-(void)setFocusedUserName:(NSString *)username;
{
    self.focusedUser = [[DPUser alloc] initWithUsername: username];
}

-(void)initThisUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [userDefaults objectForKey:@"username"]);
    if ([userDefaults objectForKey:@"username"]) {
        NSString *username = [userDefaults objectForKey:@"username"];
        thisUser = [[DPUser alloc] initWithUsername:username];
    } else {
        NSLog(@"USER SHOULD LOG IN HERE");
        [self createUserWithUsername:@"matt" andPhoneNumber:@"+5046168294" withBlock:^(BOOL succeeded, NSError *error){
            NSLog(@"USER SIGNED UP YAY");
        }];
    }

}

-(void)createUserWithUsername:(NSString *)username andPhoneNumber:(NSString *)phoneNumber withBlock:(void (^)(BOOL, NSError *))callback
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = @"password";
    user[@"phoneNumber"] = phoneNumber;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            thisUser = [[DPUser alloc] initWithUsername:user.username];
            [userDefaults setObject:user.username forKey:@"username"];
            [userDefaults setObject:user.objectId forKey:@"identifier"];
            [userDefaults synchronize];

        } else {
            NSLog(@"ERROR CREATING USER: %@", error);
        }
        callback(succeeded, error);
    }];
}

-(void)logoutUser
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

// @TODO: Actually have friends
-(void)getUserFriendsWithBlock:(void (^)(NSArray *friends, NSError *error))callback
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *friends = nil;
        if (!error) {
            // mangle results into local objects
            friends = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            for (PFUser *user in objects) {
                DPUser *friend = [[DPUser alloc] initWithUsername:user.username];
                [friends addObject:friend];
            }
        }
        thisUser.friends = friends;
        callback(friends, error);
    }];
}

-(NSArray *)getUserFriends
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    return [query findObjects];
}

-(void)sendDepicture:(DPDepicture *)depicture toUser:(DPUser *)user
{
    NSString *title = [NSString stringWithFormat:@"%@'s Depicture to %@", thisUser.username, user.username];
    NSString *description = @"";
    NSData *imageData = UIImageJPEGRepresentation(depicture, 1.0f);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [MLIMGURUploader uploadPhoto:imageData title:title description:description imgurClientID:@"c95125e4141f2bd" completionBlock:^(NSString *result) {
        NSLog(@"%@", result);
    } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                    message:[NSString stringWithFormat:@"%@ (Status code %ld)", [error localizedDescription], (long)status]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }];
}

@end
