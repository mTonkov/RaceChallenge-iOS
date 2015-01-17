//
//  ViewController.m
//  RaceChallenge
//
//  Created by Admin on 11/2/14.
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "ListAllChallengesViewController.h"
#import "Challenge.h"
#import <Parse/Parse.h>
#import "DareOpponentViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@interface ListAllChallengesViewController ()

@end

@implementation ListAllChallengesViewController {
  NSMutableArray *_availableChallenges;
  PFUser *_currentUser;
  Reachability *networkReachability;
  NetworkStatus networkStatus;
  MBProgressHUD *HUD;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _currentUser = [PFUser currentUser];
  networkReachability = [Reachability reachabilityForInternetConnection];

  HUD = [[MBProgressHUD alloc] initWithView:self.view];
  [self.view addSubview:HUD];
  [HUD show:YES];

  [self getChallengesFromBackend];

  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [UIColor greenColor];
  self.refreshControl.tintColor = [UIColor blueColor];
  [self.refreshControl addTarget:self
                          action:@selector(getChallengesFromBackend)
                forControlEvents:UIControlEventValueChanged];

  self.title = @"All Challenges";
}

- (void)viewWillAppear:(BOOL)animated {
  [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)getChallengesFromBackend {
  if ([self checkInternetConnection]) {

    PFQuery *query = [Challenge query];
    [query whereKey:@"ownerId" notEqualTo:_currentUser.objectId];
    [query whereKeyDoesNotExist:@"challengerName"];
    [query orderByAscending:@"ownerName"];
    __weak id weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                              NSError *error) {
        if (!error) {
          _availableChallenges = [[NSMutableArray alloc] initWithArray:objects];
          [[weakSelf tableView] reloadData];
        }
        [self setMessageForQueriedData];

        if (self.refreshControl) {
          [self setRefreshingMessage];
          [self.refreshControl endRefreshing];
        }
    }];
  }
}

- (BOOL)checkInternetConnection {
  networkStatus = [networkReachability currentReachabilityStatus];
  if (networkStatus == NotReachable) {
    [self showAlert:@"Data cannot be reached!"
         andMessage:@"Please, check your Internet connection!"];
    if (self.refreshControl) {
      [self setRefreshingMessage];
      [self.refreshControl endRefreshing];
    }
    NSLog(@"There IS NO internet connection");
    return NO;
  }

  return YES;
}

- (void)setRefreshingMessage {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *title =
      [NSString stringWithFormat:@"Last update: %@",
                                 [formatter stringFromDate:[NSDate date]]];
  NSDictionary *attrsDictionary =
      [NSDictionary dictionaryWithObject:[UIColor blueColor]
                                  forKey:NSForegroundColorAttributeName];
  NSAttributedString *attributedTitle =
      [[NSAttributedString alloc] initWithString:title
                                      attributes:attrsDictionary];
  self.refreshControl.attributedTitle = attributedTitle;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  [HUD hide:YES];
  return _availableChallenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentifier = @"cellForAllChallenges";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }

  Challenge *chal = [_availableChallenges objectAtIndex:indexPath.row];
  UILabel *raceType = (UILabel *)[cell viewWithTag:1];
  [raceType setText:[NSString stringWithFormat:@"%@ Race",
                                               [chal.type capitalizedString]]];
  UILabel *raceAuthor = (UILabel *)[cell viewWithTag:2];
  [raceAuthor setText:chal.ownerName];
  UILabel *raceLocation = (UILabel *)[cell viewWithTag:3];
  [raceLocation setText:chal.location];

  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqualToString:@"dareOpponentSegue"]) {
    DareOpponentViewController *destination = [segue destinationViewController];
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];

    [destination
        setSelectedChallenge:[_availableChallenges objectAtIndex:ip.row]];
    [destination setRetrievedChallenges:_availableChallenges];
  }
}

#pragma mark Customizing table view
- (void)setMessageForQueriedData {
  if (_availableChallenges) {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = nil;
  } else {
    UILabel *messageLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                 self.view.bounds.size.height)];

    messageLabel.text =
        @"No data is currently available.\n Please, pull down " @"to refresh.";
    messageLabel.textColor = [UIColor blackColor];
    //        messageLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.6
    //        blue:0.1 alpha:0.8];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];

    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  }
}

- (IBAction)orderBy:(id)sender {
  UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
  NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

  NSString *criteria;
  switch (selectedSegment) {
  case 0:
    criteria = @"ownerName";
    break;
  case 1:
    criteria = @"type";
    break;
  case 2:
    criteria = @"location";
    break;

  default:
    break;
  }

  NSSortDescriptor *descriptor =
      [[NSSortDescriptor alloc] initWithKey:criteria ascending:YES];
  NSArray *sortedArray =
      [_availableChallenges sortedArrayUsingDescriptors:@[ descriptor ]];
  _availableChallenges = [NSMutableArray arrayWithArray:sortedArray];

  [[self tableView] reloadData];
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)msg {
  [[[UIAlertView alloc] initWithTitle:title
                              message:msg
                             delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
}

@end
