//
//  ChallengeOpponentViewController.h
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"
#import <Parse/Parse.h>

@interface DareOpponentViewController : UIViewController

@property(strong, nonatomic) Challenge *selectedChallenge;
@property(strong, nonatomic) NSMutableArray *retrievedChallenges;

@end
