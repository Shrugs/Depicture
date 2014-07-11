//
//  DPUser.m
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import "DPUser.h"

@implementation DPUser

@synthesize username, identifier;

+(DPUser *) thisUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[DPUser alloc] initWithIdentifier:[userDefaults objectForKey:@"identifier"] andUsername:[userDefaults objectForKey:@"username"]];
}

-(DPUser *) initWithIdentifier:(NSString *)identifier andUsername:(NSString *)username
{
    self = [super init];
    if (self) {
        self.username = username;
        self.identifier = identifier;
    }
    return self;
}

@end
