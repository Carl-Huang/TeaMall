//
//  PopupTagViewController.h
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CommonViewController.h"

typedef void (^DidSelectedItem)(NSString * item);

@interface PopupTagViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITableView *contentTable;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong ,nonatomic) NSArray * dataSource;
@property (strong ,nonatomic) DidSelectedItem block;
@end
