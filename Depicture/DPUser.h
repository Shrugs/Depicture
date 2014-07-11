//
//  DPUser.h
//  Depicture
//
//  Created by Matt Condon on 7/11/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPUser : NSObject

+(DPUser *) thisUser;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *identifier;

@end
