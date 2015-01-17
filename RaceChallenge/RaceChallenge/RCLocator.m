//
//  RCLocator.m
//  RaceChallenge
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "RCLocator.h"
#import <CoreLocation/CoreLocation.h>

@interface RCLocator () <CLLocationManagerDelegate>

@end

@implementation RCLocator {
  CLLocationManager *locationManager;
  void (^_block)(CLLocation *);
  id _target;
  SEL _action;
}

- (instancetype)init {
  if (self = [super init]) {
    locationManager = [[CLLocationManager alloc] init];
    [self setupLocationManager];
  }
  return self;
}

- (void)getLocationWithBlock:(void (^)(CLLocation *))block {
  _block = block;
  [locationManager requestAlwaysAuthorization];
  [locationManager startUpdatingLocation];
}

- (void)getLocationWithTarget:(id)target andAction:(SEL)action {
  _target = target;
  _action = action;
  [locationManager requestAlwaysAuthorization];
  [locationManager startUpdatingLocation];
}

- (void)setupLocationManager {
  locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
  locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations lastObject];
  NSLog(@"Location update");
  NSLog(@"%@", location);
  if (_block) {
    _block(location);
    _block = nil;
  }
  if (_target && _action && [_target respondsToSelector:_action]) {
    [_target performSelector:_action withObject:location];
    _target = nil;
    _action = nil;
  }

  [locationManager stopUpdatingLocation];
}

@end
