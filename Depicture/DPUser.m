//
//  DPUser.m
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPUser.h"

@implementation DPUser

@synthesize username, identifier, friends;

+(DPUser *) thisUser
{
    static DPUser *thisUserSingleton = nil;
    if (thisUserSingleton == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        thisUserSingleton = [[self alloc] initWithIdentifier:[userDefaults objectForKey:@"identifier"] andUsername:[userDefaults objectForKey:@"username"]];
        thisUserSingleton = [[self alloc] initWithIdentifier:@"+5046168294" andUsername:@"matt"];
    }
    return thisUserSingleton;
}

-(DPUser *) initWithIdentifier:(NSString *)identifier andUsername:(NSString *)username
{
    self = [super init];
    if (self) {
        self.username = username;
        self.identifier = identifier;
        self.friends = @[@"pf", @"shrugs", @"test"];
    }
    return self;
}

@end
