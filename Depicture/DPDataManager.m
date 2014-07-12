//
//  DPDataManager.m
//
//
//  Created by Matt Condon on 7/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPDataManager.h"

@implementation DPDataManager

@synthesize thisUser;

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

-(void)initThisUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@", [userDefaults objectForKey:@"username"]);
    if ([userDefaults objectForKey:@"username"]) {
        NSString *username = [userDefaults objectForKey:@"username"];
        NSString *identifier = [userDefaults objectForKey:@"identifier"];
        thisUser = [[DPUser alloc] initWithIdentifier:identifier andUsername:username];
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
            thisUser = [[DPUser alloc] initWithIdentifier:user.objectId andUsername:user.username];
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
        NSLog(@"%@", objects);
        NSMutableArray *friends = nil;
        if (!error) {
            // mangle results into local objects
            friends = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            for (PFUser *user in objects) {
                DPUser *friend = [[DPUser alloc] initWithIdentifier:user.objectId andUsername:user.username];
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

@end
