//
//  DPDataManager.h
//  Depicture
//
//  Created by Matt Condon on 7/12/14.
//  Copyright (c) 2014 Shrugs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPUser.h"
#import "DPDepicture.h"
#import <Parse/Parse.h>
#import "MLIMGURUploader.h"

@interface DPDataManager : NSObject

+(DPDataManager *)sharedDataManager;

//getUserFriends
//getUserSendDepictures
//getUserReceivedDepictures
//setDepictureSolved:depicture forPoints:points
-(void)getUserFriendsWithBlock:(void (^)(NSArray *friends,NSError *error))callback;

@property (nonatomic, strong) DPUser *thisUser;
@property (nonatomic, strong) DPUser *focusedUser;
-(void)setFocusedUserName:(NSString *)username;

-(void)createUserWithUsername:(NSString *)username andPhoneNumber:(NSString *)phoneNumber withBlock:(void (^)(BOOL succeeded, NSError *error))callback;
-(void)logoutUser;

@end
