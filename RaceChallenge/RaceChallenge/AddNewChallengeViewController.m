//
//  AddNewChallengeViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "AddNewChallengeViewController.h"

#import "Challenge.h"
#import <Parse/Parse.h>
#import "RCLocator.h"

@interface AddNewChallengeViewController ()

@end

@implementation AddNewChallengeViewController {
  NSArray *_raceTypes;
  NSString *_chosenRace;
  RCLocator *_locationProvider;
  NSString *_currentLocation;
  PFUser *_currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.carInput.layer.borderColor = [[UIColor blackColor] CGColor];
  self.carInput.layer.cornerRadius = 10;
  self.carInput.layer.borderWidth = 1.0;
  self.addChallengeBtn.layer.cornerRadius = 10;
  _locationProvider = [[RCLocator alloc] init];
  _currentUser = [PFUser currentUser];

  _raceTypes =
      [NSArray arrayWithObjects:@"Drag", @"Circuit", @"Sprint", @"Drift", nil];
  _chosenRace = _raceTypes[0];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)addNewChallenge:(id)sender {
  if ([self.carInput.text containsString:@"Car details"] ||
      self.carInput.text.length < 5) {
    [self showAlert:@"Incorrect input data!"
         andMessage:@"Please check you car details!"];
    return;
  }

  Challenge *newChallenge = [Challenge object];
  newChallenge.ownerId = _currentUser.objectId;
  newChallenge.ownerName = _currentUser.username;
  newChallenge.ownerEmail = _currentUser.email;
  newChallenge.ownerCar = self.carInput.text;
  newChallenge.type = _chosenRace;

    if (self.locationInput.text.length > 0) {
      newChallenge.location = self.locationInput.text;
      [newChallenge saveInBackground];
    } else {

  CLGeocoder *gCoder = [[CLGeocoder alloc] init];
  [_locationProvider getLocationWithBlock:^(CLLocation *location) {

      [gCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (!error) {
                         CLPlacemark *p = [placemarks lastObject];

                         newChallenge.location = p.addressDictionary[@"City"];
                         NSLog(@"%ld", placemarks.count);
                         NSLog(@"%@", p.addressDictionary[@"City"]);
                         NSLog(@"%@", p.addressDictionary[@"Country"]);
                                                      [newChallenge saveInBackground];
                       }
                   }];
  }];
    }
  [self animateButton:sender];
}

- (void)animateButton:(id)button {
  UIView *btn = button;
  [btn setFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame),
                           CGRectGetWidth(btn.frame),
                           CGRectGetHeight(btn.frame))];

  [UIView animateWithDuration:0.7
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
          // set the new frame
          [btn setFrame:CGRectMake(150, CGRectGetMinY(btn.frame),
                                   CGRectGetWidth(btn.frame),
                                   CGRectGetHeight(btn.frame))];
      }
      completion:^(BOOL finished) {
          [UIView animateWithDuration:0.8
              delay:0
              options:UIViewAnimationOptionCurveEaseIn
              animations:^{

                  [btn setFrame:CGRectMake(2 * CGRectGetWidth(btn.frame),
                                           CGRectGetMinY(btn.frame),
                                           CGRectGetWidth(btn.frame),
                                           CGRectGetHeight(btn.frame))];
              }
              completion:^(BOOL finished) {
                  [self showAlert:@"Challenge added!" andMessage:@""];
              }];

      }];
  UIImage *image = [UIImage imageNamed:@"racelegal"];

  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.frame = CGRectMake(0, CGRectGetMinY(btn.frame) - 50, 0, 130);
  imageView.contentMode = UIViewContentModeLeft;
  imageView.clipsToBounds = YES;
  [self.view addSubview:imageView];

  CGRect finalFrame = imageView.frame;
  finalFrame.size.width = 2 * CGRectGetWidth(btn.frame);

  [UIView animateWithDuration:1.4
      delay:0.5
      options:UIViewAnimationOptionCurveEaseInOut
      animations:^{ imageView.frame = finalFrame; }
      completion:^(BOOL finished) { NSLog(@"Button animated!"); }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
  return _raceTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return _raceTypes[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  _chosenRace = _raceTypes[row];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
  [[[UIAlertView alloc] initWithTitle:title
                              message:msg
                             delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
}
@end
