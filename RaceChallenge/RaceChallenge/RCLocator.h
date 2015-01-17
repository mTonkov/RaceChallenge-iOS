//
//  RCLocator.h
//  RaceChallenge
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RCLocator : NSObject

-(void) getLocationWithBlock: (void(^)(CLLocation* location)) block;

-(void) getLocationWithTarget:(id) target
                    andAction:(SEL) action;

@end
