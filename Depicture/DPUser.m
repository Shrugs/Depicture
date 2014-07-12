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

-(DPUser *) initWithIdentifier:(NSString *)iden andUsername:(NSString *)uname
{
    self = [super init];
    if (self) {
        self.username = uname;
        self.identifier = iden;
    }
    return self;
}

@end
