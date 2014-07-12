//
//  DPUser.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPUser : NSObject

-(DPUser *) initWithIdentifier:(NSString *)iden andUsername:(NSString *)uname;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *friends;

@end
