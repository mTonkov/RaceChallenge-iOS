//
//  CDChallenge.m
//  RaceChallenge
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "CDChallenge.h"

@implementation CDChallenge

@dynamic opponentName;
@dynamic opponentEmail;
@dynamic location;
@dynamic raceType;
@dynamic displayOrder;
@dynamic opponentCar;
@dynamic challengeOwnerId;

- (void)setValuesFromChallenge:(Challenge *)challenge {
  self.opponentName = challenge.ownerName;
  self.opponentEmail = challenge.ownerEmail;
  self.opponentCar = challenge.ownerCar;
  self.location = challenge.location;
  self.raceType = challenge.type;
}

@end
