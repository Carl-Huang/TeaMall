//
//  SearchViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "SearchViewController.h"
#import "PopupTagViewController.h"
#import "ControlCenter.h"
#import "MainViewController.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    PopupTagViewController * popupTagViewController;
}
@property (nonatomic,strong) NSMutableArray * searchList;
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard:) name:@"HideKeyboard" object:nil];
        _searchList = [NSMutableArray array];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"])
        {
            _searchList = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    if(![OSHelper iPhone5])
    {
        rect.size.height = 367;
        [self.view setFrame:rect];
    }

    popupTagViewController = nil;
    
    if(![OSHelper iOS7])
    {
        _searchBar.backgroundColor = [UIColor clearColor];
        //_searchBar.tintColor = [UIColor colorWithRed:189.0f/255.0f green:189.0/255.0 blue:195.0/255.0 alpha:1.0];
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchBar resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (void)reloadSearchHistory
{
    _searchList = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"];
    [self.contentTable reloadData];
}

- (void)dismissKeyboard:(NSNotification *)notification
{
    [_searchBar resignFirstResponder];
}

- (IBAction)showTagAction:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        if (!popupTagViewController) {
            
            popupTagViewController = [[PopupTagViewController alloc]initWithNibName:@"PopupTagViewController" bundle:nil];
            NSArray * array = @[@"品牌",@"产品",@"交易号",@"升价",@"降价"];
            [popupTagViewController setDataSource:array];
            //设置位置
            CGRect originalRect = popupTagViewController.view.frame;
            originalRect.origin.x = btn.frame.origin.x + btn.frame.size.width - originalRect.size.width/2-15;
            originalRect.origin.y = btn.frame.origin.y + btn.frame.size.height +10;
            [popupTagViewController.view setFrame:originalRect];
            __weak SearchViewController * searchVC = self;
            [popupTagViewController setBlock:^(NSString * item){
                [btn setSelected:NO];
                
                if([item isEqualToString:@"品牌"])
                {
                    [ControlCenter showCatetoryInTeaMarket];
                }
                else if([item isEqualToString:@"产品"])
                {
                    [ControlCenter showTeaMarket];
                }
                else if([item isEqualToString:@"交易号"])
                {
                    MainViewController * vc = (MainViewController *)searchVC.parentViewController;
                    [vc gotoSquareViewController];
                    
                }
                else if([item isEqualToString:@"升价"])
                {
                    [ControlCenter showMarketWithType:@"1"];
                }
                else if([item isEqualToString:@"降价"])
                {
                    [ControlCenter showMarketWithType:@"0"];
                }
                
                
            }];
            [self addChildViewController:popupTagViewController];
            [self.view addSubview:popupTagViewController.view];
            return;
        }
        [self.view addSubview:popupTagViewController.view];
    }else
    {
        [popupTagViewController.view removeFromSuperview];
    }
    
}

- (IBAction)cancelSearchAction:(id)sender
{
    _searchBar.text = nil;
    [_searchBar resignFirstResponder];
}

- (IBAction)clearHistoryAction:(id)sender
{
    [_searchList removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_searchList forKey:@"SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.contentTable reloadData];
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [ControlCenter showTeaMarketWithKeyword:searchBar.text];
    NSMutableArray * searchHistory = [NSMutableArray array];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"])
    {
        searchHistory = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SearchHistory"]];
    }
    
    if([searchHistory containsObject:searchBar.text])
    {
        return ;
    }
    
    [searchHistory addObject:searchBar.text];
    [[NSUserDefaults standardUserDefaults] setObject:searchHistory forKey:@"SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadSearchHistory];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [_searchList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ControlCenter showTeaMarketWithKeyword:[_searchList objectAtIndex:indexPath.row]];
}


@end
