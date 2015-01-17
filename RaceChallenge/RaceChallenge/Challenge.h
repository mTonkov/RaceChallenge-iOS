//
//  Challenge.h
//  RaceChallenge
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Challenge : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString*   ownerId;
@property (retain) NSString*   ownerName;
@property (retain) NSString*   challengerName;
@property (retain) NSString*   ownerEmail;
@property (retain) NSString*   challengerEmail;

@property (retain) NSString* ownerCar;
@property (retain) NSString* challengerCar;
@property (retain) NSString* type;
@property (retain) NSString* location;

@end
