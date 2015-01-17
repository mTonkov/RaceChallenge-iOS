//
//  LoginRegisterViewController.h
//  RaceChallenge
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtnOutlet;

@end
