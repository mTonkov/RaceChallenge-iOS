//
//  TabBarViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/7/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController {
    int _controllerIndex ;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _controllerIndex = 0;
  UISwipeGestureRecognizer *rightSwipeRecognizer =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipe:)];

  UISwipeGestureRecognizer *leftSwipeRecognizer =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipe:)];
  leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

  [self.view addGestureRecognizer:rightSwipeRecognizer];
  [self.view addGestureRecognizer:leftSwipeRecognizer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)recognizer {
  NSString *message;
    
  switch (recognizer.direction) {
  case UISwipeGestureRecognizerDirectionRight:
    message = @"Swiped right";
          _controllerIndex = (int)self.selectedIndex-1;
    break;
  case UISwipeGestureRecognizerDirectionLeft:
    message = @"Swiped left";
          _controllerIndex = (int)self.selectedIndex+1;
    break;
  default:
    message = @"Not swiped";
    break;
  }
    
    if (_controllerIndex >= (int)self.viewControllers.count) {
        _controllerIndex = (int)self.viewControllers.count-1;
    }else if (_controllerIndex<0){
        _controllerIndex = 0;
    }
    
    if (_controllerIndex!=self.selectedIndex) {
       
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = [[self.viewControllers objectAtIndex:_controllerIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(_controllerIndex > self.selectedIndex ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.selectedIndex = _controllerIndex;
                        }
                    }];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
      if (event.subtype == UIEventSubtypeMotionShake) {
            [[[UIAlertView alloc]
                           initWithTitle:@"Exit?"
                                 message:@"Are you sure you want to exit this awesome app?"
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                       otherButtonTitles:@"Unfortunately, yes...", nil] show];
          }
    
      if ([super respondsToSelector:@selector(motionEnded:withEvent:)])
            [super motionEnded:motion withEvent:event];
    }

- (BOOL)canBecomeFirstResponder {
      return YES;
    }

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
      if (buttonIndex == 1) {
            exit(0);
         }
    }
@end
