//
//  SearchViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;
- (IBAction)showTagAction:(id)sender;

- (IBAction)cancelSearchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
- (IBAction)clearHistoryAction:(id)sender;
@end
