//
//  CustomiseServiceViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "CustomiseServiceViewController.h"
#import "CustomiseServiceCell.h"
#import "UIViewController+BarItem.h"
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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TeamPList" ofType:@"plist"];
    self.plistArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    [self setLeftCustomBarItem:@"返回" action:nil];
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
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
    return self.plistArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomiseServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = [self.plistArray objectAtIndex:indexPath.row];
    cell.imageV.image = [UIImage imageNamed:[dic valueForKey:@"image"]];
    cell.phoneNum.text = [dic valueForKey:@"phoneNum"];
    cell.name.text = [dic valueForKey:@"name"];
    [cell.call addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)callAction:(UIButton *)button
{
    CustomiseServiceCell * cell;
    if([button.superview.superview isKindOfClass:[CustomiseServiceCell class]])
    {
        cell = (CustomiseServiceCell *)button.superview.superview;
    }
    else if([button.superview.superview.superview isKindOfClass:[CustomiseServiceCell class]])
    {
        cell = (CustomiseServiceCell *)button.superview.superview.superview;
    }
    else
    {
        return ;
    }
    
    NSIndexPath * indexPath = [_contentTable indexPathForCell:cell];
    NSDictionary *dic = [self.plistArray objectAtIndex:indexPath.row];
    NSString * telString = [NSString stringWithFormat:@"tel://%@",[dic valueForKey:@"phoneNum"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
    
}
@end
