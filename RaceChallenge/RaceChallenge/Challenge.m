//
//  Challenge.m
//  RaceChallenge
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "Challenge.h"
#import <Parse/PFObject+Subclass.h>

@implementation Challenge

@dynamic ownerId;
@dynamic ownerName;
@dynamic challengerName;
@dynamic ownerEmail;
@dynamic challengerEmail;

@dynamic ownerCar;
@dynamic challengerCar;
@dynamic type;
@dynamic location;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Challenge";
}

@end
