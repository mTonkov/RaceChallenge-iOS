//
//  ChallengeOpponentViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "DareOpponentViewController.h"
#import "CDChallenge.h"
#import "CoreDataDBHelper.h"

@interface DareOpponentViewController ()
@property(weak, nonatomic) IBOutlet UILabel *opponentName;
@property(weak, nonatomic) IBOutlet UILabel *opponentCar;
@property(weak, nonatomic) IBOutlet UILabel *raceLocation;
@property(weak, nonatomic) IBOutlet UILabel *raceType;
@property(weak, nonatomic) IBOutlet UITextField *currentUserCar;
@property(weak, nonatomic) IBOutlet UIButton *challengeBtn;

@end

@implementation DareOpponentViewController {
  PFUser *currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.opponentName.text = self.selectedChallenge.ownerName;
  self.opponentCar.text = self.selectedChallenge.ownerCar;
  self.raceLocation.text = self.selectedChallenge.location;
  self.raceType.text = self.selectedChallenge.type;
  self.challengeBtn.layer.cornerRadius = 10;
  currentUser = [PFUser currentUser];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)challengeOpponent:(id)sender {
    if (self.currentUserCar.text.length < 5) {
      [self showAlert:@"Not enough data for car!"
           andMessage:@"Please provide car data"];
  
      return;
    }
    

    [self animateButton:sender];
    self.selectedChallenge.challengerName = currentUser.username;
    self.selectedChallenge.challengerEmail = currentUser.email;
    self.selectedChallenge.challengerCar = self.currentUserCar.text;
    [self.selectedChallenge saveInBackground];
    [self.retrievedChallenges removeObject:self.selectedChallenge];
  
    // add to CoreData
    CoreDataDBHelper *dbHelper = [CoreDataDBHelper getInstance];
    CDChallenge *newCdChallenge =
        [NSEntityDescription insertNewObjectForEntityForName:@"CDChallenge"
                                      inManagedObjectContext:dbHelper.context];
    [newCdChallenge setValuesFromChallenge:self.selectedChallenge];
    newCdChallenge.displayOrder = [NSNumber numberWithInt:0];
    newCdChallenge.challengeOwnerId = currentUser.objectId;
  
    [dbHelper.context insertObject:newCdChallenge];
    [dbHelper saveContext];
    NSLog(@"%@", newCdChallenge);

    
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
          [btn setFrame:CGRectMake(40, CGRectGetMinY(btn.frame),
                                   CGRectGetWidth(btn.frame),
                                   CGRectGetHeight(btn.frame))];
      }
      completion:^(BOOL finished) {
          [UIView animateWithDuration:1
              delay:0
              options:UIViewAnimationOptionCurveLinear
              animations:^{

                  [btn setFrame:CGRectMake(2 * CGRectGetWidth(btn.frame),
                                           CGRectGetMinY(btn.frame),
                                           CGRectGetWidth(btn.frame),
                                           CGRectGetHeight(btn.frame))];
              }
              completion:^(BOOL finished) {
                  btn.hidden = YES;
                    [self showAlert:@"New challenge!"
                         andMessage:[NSString stringWithFormat:@"You just challenged %@",
                                                               self.selectedChallenge.ownerName]];
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

  [UIView animateWithDuration:1.6
      delay:0.65
      options:UIViewAnimationOptionCurveEaseOut
      animations:^{ imageView.frame = finalFrame; }
      completion:^(BOOL finished) { NSLog(@"Button animated!"); }];
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
