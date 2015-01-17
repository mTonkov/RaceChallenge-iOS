//
//  CDChallenge.h
//  RaceChallenge
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Challenge.h"

@interface CDChallenge : NSManagedObject

@property (nonatomic, retain) NSString * opponentName;
@property (nonatomic, retain) NSString * opponentEmail;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * raceType;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * opponentCar;
@property (nonatomic, retain) NSString * challengeOwnerId;

-(void) setValuesFromChallenge:(Challenge *)challenge;
@end
