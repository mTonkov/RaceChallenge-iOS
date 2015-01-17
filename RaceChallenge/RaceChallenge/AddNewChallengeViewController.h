//
//  AddNewChallengeViewController.h
//  RaceChallenge
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewChallengeViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *carInput;
@property (weak, nonatomic) IBOutlet UIPickerView *raceTypePicker;
@property (weak, nonatomic) IBOutlet UIButton *addChallengeBtn;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;

@end
