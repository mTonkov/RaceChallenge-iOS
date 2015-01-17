//
//  MyChallengesTVC.m
//  RaceChallenge
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "MyChallengesTVC.h"
#import "CDChallenge.h"
#import "CoreDataDBHelper.h"
#import <Parse/Parse.h>

@interface MyChallengesTVC ()

@end

@implementation MyChallengesTVC {
  NSMutableArray *_myChallenges;
  CoreDataDBHelper *_cdHelper;
  PFUser *_currentUser;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _cdHelper = [CoreDataDBHelper getInstance];
  _currentUser = [PFUser currentUser];

  if (!_myChallenges) {
    [self getCdData];
  }

  UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(longPressGestureRecognized:)];
  [self.tableView addGestureRecognizer:longPress];
}

- (void)viewWillAppear:(BOOL)animated {

  [self getCdData];
}

- (void)viewWillDisappear:(BOOL)animated {
  // remember the order
  for (int i = 0; i < _myChallenges.count; i++) {
    CDChallenge *chal = _myChallenges[i];
    chal.displayOrder = [NSNumber numberWithInt:i + 1];
  }
  [_cdHelper saveContext];
}

- (void)getCdData {
  NSFetchRequest *request =
      [NSFetchRequest fetchRequestWithEntityName:@"CDChallenge"];
  NSSortDescriptor *sort =
      [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES];
  [request setSortDescriptors:[NSArray arrayWithObject:sort]];

  NSString *currentUserId = _currentUser.objectId;
  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"challengeOwnerId == %@", currentUserId];
  [request setPredicate:predicate];

  _myChallenges = [NSMutableArray
      arrayWithArray:[_cdHelper.context executeFetchRequest:request error:nil]];
    
    [self messageIfNoDataRetrieved];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _myChallenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"listMyChallenges";
  NSLog(@"cellForRowAtIndexPath");
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }

  CDChallenge *chal = [_myChallenges objectAtIndex:indexPath.row];

  UILabel *raceType = (UILabel *)[cell viewWithTag:1];
  UILabel *opponent = (UILabel *)[cell viewWithTag:2];
  UILabel *opponentEmail = (UILabel *)[cell viewWithTag:3];
  UILabel *car = (UILabel *)[cell viewWithTag:4];
  UILabel *raceLocation = (UILabel *)[cell viewWithTag:5];

  [raceType setText:chal.raceType];
  [opponent setText:chal.opponentName];
  [opponentEmail setText:chal.location];
  [car setText:chal.opponentCar];
  [raceLocation setText:chal.location];

  return cell;
}


#pragma mark - Customizing methods
- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress =
    (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil; ///< A snapshot of the row user is moving.
    static NSIndexPath *sourceIndexPath =
    nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     
                                     // Offset for gesture location.
                                     center.y = location.y;
                                     snapshot.center = center;
                                     snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                                     snapshot.alpha = 0.98;
                                     
                                     // Fade out.
                                     cell.alpha = 0.0;
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     cell.hidden = YES;
                                     
                                 }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                [_myChallenges exchangeObjectAtIndex:indexPath.row
                                   withObjectAtIndex:sourceIndexPath.row];
                
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            UITableViewCell *cell =
            [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25
                             animations:^{
                                 
                                 snapshot.center = cell.center;
                                 snapshot.transform = CGAffineTransformIdentity;
                                 snapshot.alpha = 0.0;
                                 
                                 cell.alpha = 1.0;
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 sourceIndexPath = nil;
                                 [snapshot removeFromSuperview];
                                 snapshot = nil;
                                 
                             }];
            break;
        }
    }
}


- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark - Helping methods
- (void)messageIfNoDataRetrieved {
    if (_myChallenges && _myChallenges.count>0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
    } else {
        UILabel *messageLabel = [[UILabel alloc]
                                 initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                                          self.view.bounds.size.height)];
        
        messageLabel.text =
        @"You have not challenged anyone, yet.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

@end
