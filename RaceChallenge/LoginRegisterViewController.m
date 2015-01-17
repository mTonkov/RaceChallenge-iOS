//
//  LoginRegisterViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import "ListAllChallengesViewController.h"
#import "Reachability.h"

@interface LoginRegisterViewController ()

@end

@implementation LoginRegisterViewController {
    BOOL isJustRegistered;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isJustRegistered = NO;
    self.loginBtnOutlet.layer.cornerRadius = 10;
    self.signUpBtnOutlet.layer.cornerRadius = 10;
}

- (void)viewDidAppear:(BOOL)animated {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)unwindToLoginRegister:(UIStoryboardSegue *)segue {
    [PFUser logOut];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)loginUser:(id)sender {
    Reachability *networkReachability =
    [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self showAlert:@"Login Failed!!!"
             andMessage:@"Please, check your Internet  connection!"];
        NSLog(@"There IS NO internet connection");
    } else {
        NSLog(@"There IS internet connection");
        
        if (![self validateUserInputs:NO]) {
            return;
        }
        
        [PFUser
         logInWithUsernameInBackground:self.usernameInput.text
         password:self.passwordInput.text
         block:^(PFUser *user, NSError *error) {
             if (user) {
                 [UIView animateWithDuration:1
                                       delay:0
                                     options:
                  UIViewAnimationOptionCurveEaseIn
                                  animations:^{
                                      
                                      [self.loginBtnOutlet setFrame:
                                       CGRectMake(2 * CGRectGetWidth(self.loginBtnOutlet.frame),
                                                  CGRectGetMinY(self.loginBtnOutlet.frame),
                                                  CGRectGetWidth(self.loginBtnOutlet.frame),
                                                  CGRectGetHeight(self.loginBtnOutlet.frame))];
                                  }
                                  completion:^(BOOL finished) {
                                      [self showAlert:@"Succesful Login !" andMessage: [NSString stringWithFormat: @"You are now logged in as %@", user.username]];
                                      [self performSegueWithIdentifier: @"loggedInSegue" sender: sender];
                                  }];
                 if (!isJustRegistered) {
                     [UIView animateWithDuration:1
                                           delay:0
                                         options:
                      UIViewAnimationOptionCurveEaseIn
                                      animations:^{
                                          
                                          [self.signUpBtnOutlet setFrame:
                                           CGRectMake( -2 * CGRectGetWidth( self.signUpBtnOutlet.frame),
                                                      CGRectGetMinY( self.signUpBtnOutlet.frame),
                                                      CGRectGetWidth( self.signUpBtnOutlet.frame),
                                                      CGRectGetHeight( self.signUpBtnOutlet.frame))];
                                      }
                                      completion:^(BOOL finished){}];
                 }
             } else {
                 [self showAlert:@"Login Failed!!!"
                      andMessage:[error userInfo][@"error"]];
             }
             self.usernameInput.text = @"";
             self.passwordInput.text = @"";
         }];
        //asdjhafsdjih
    }
}
- (IBAction)signUpUser:(id)sender {
    if (![self validateUserInputs:YES]) {
        return;
    }
    
    isJustRegistered = YES;
    PFUser *user = [PFUser user];
    user.username = self.usernameInput.text;
    user.password = self.passwordInput.text;
    user.email = self.emailInput.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            UIView *btn = sender;
            [UIView animateWithDuration:1
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 [btn setFrame:
                                  CGRectMake(CGRectGetMinX(btn.frame),
                                             2 * CGRectGetMinY(btn.frame),
                                             CGRectGetWidth(btn.frame),
                                             CGRectGetHeight(btn.frame))];
                             }
                             completion:^(BOOL finished) {
                                 [self showAlert:@"Succesful Registration!"
                                      andMessage:@"Now you may Login!"];
                             }];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [self showAlert:@"Registration Failed!!!" andMessage:errorString];
        }
    }];
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:title
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

- (BOOL)validateUserInputs:(BOOL)isSigningUp {
    UIAlertView *invalidInput;
    BOOL isInputValid = YES;
    
    if (self.usernameInput.text.length < 3 ||
        self.passwordInput.text.length < 3) {
        invalidInput = [[UIAlertView alloc]
                        initWithTitle:@"Invalid user data!"
                        message:@"Username and password should be at least 3 characters long. \n " @"Please try again!"
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil, nil];
        
        isInputValid = NO;
    }
    
    if (isSigningUp && self.emailInput.text.length < 3) {
        invalidInput.message =
        @"Username, password or email is invalid. \n " @"Please try again!";
        
        isInputValid = NO;
    }
    
    if (invalidInput) {
        [invalidInput show];
    }
    
    return isInputValid;
}
@end
