//
//  CustomiseServiceViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CustomiseServiceViewController.h"
#import "CustomiseServiceCell.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface CustomiseServiceViewController ()
{
    NSUInteger cellItemHeight;
}
@end

@implementation CustomiseServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
    cellItemHeight = 0;
    CustomiseServiceCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomiseServiceCell" owner:self options:nil]objectAtIndex:0];
    cellItemHeight = cell.frame.size.height;
    cell = nil;

    
    UINib *cellNib = [UINib nibWithNibName:@"CustomiseServiceCell" bundle:[NSBundle bundleForClass:[CustomiseServiceCell class]]];
    [self.contentTable registerNib:cellNib forCellReuseIdentifier:cellIdentifier];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellItemHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomiseServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
@end
