//
//  LeftMenuViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "HWSDK.h"
#import "ControlCenter.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "TeaCategory.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate>
@property (nonatomic,strong) NSMutableArray * years;
@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _years = [NSMutableArray array];
        for(int i = 0 ; i <= 17; i ++)
        {
            int year = 2014 - i;
            [_years addObject:[NSString stringWithFormat:@"%i",year]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadModel];
    self.headViewArray = [[NSMutableArray alloc]init ];
#ifdef iOS7_SDK
    if ([OSHelper iOS7]) {
        self.contentTable.separatorInset = UIEdgeInsetsZero;
    }
#endif
    [self.contentTable setBackgroundView:nil];
    [self.contentTable setBackgroundColor:[UIColor clearColor]];
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
    [self getAllTeaCategory];
    
    
}

- (void)getAllTeaCategory
{
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    if(appDelegate.allTeaCategory == nil)
    {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [[HttpService sharedInstance] getCategory:@{@"is_system":@"0"} completionBlock:^(id object) {
            
            [hud hide:YES];
            appDelegate.allTeaCategory = object;
            [self loadModel];
            [self.contentTable reloadData];
        } failureBlock:^(NSError *error, NSString *responseString) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加载失败";
            [hud hide:YES afterDelay:1.0];
        }];
    }
    else
    {
        [self loadModel];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadModel{
    _currentRow = -1;
    self.headViewArray = [[NSMutableArray alloc]init ];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    for(int i = 0;i< [appDelegate.allTeaCategory count] ;i++)
	{
        TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:i];
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
		headview.section = i;
        headview.tag = i;
        [headview.backBtn setTitle:[NSString stringWithFormat:@"  %@",category.name] forState:UIControlStateNormal];
        [headview.backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[self.headViewArray addObject:headview];
        headview = nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?45:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.headViewArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadView* headView = [self.headViewArray objectAtIndex:section];
    return headView.open?[_years count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
//        backBtn.tag = 20000;
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateHighlighted];
//        backBtn.userInteractionEnabled = NO;
//        [cell.contentView addSubview:backBtn];
//        backBtn = nil;
        
        
        UIView * view = [[UIView alloc]initWithFrame:cell.frame];
        [view setBackgroundColor:[UIColor blackColor]];
        view.alpha = 0.6;
        [cell setBackgroundView:view];
        
    }
//    UIButton* backBtn = (UIButton*)[cell.contentView viewWithTag:20000];
//    HeadView* view = [self.headViewArray objectAtIndex:indexPath.section];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateNormal];
//    
//    if (view.open) {
//        if (indexPath.row == _currentRow) {
//            [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateNormal];
//        }
//    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [_years objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    [self.contentTable reloadData];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:indexPath.section];
    NSString * year = [_years objectAtIndex:indexPath.row];
    [ControlCenter showTeaMarketWithCatagory:category withYear:year];
    
}

#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view viewTag:(NSInteger)tag{
    _currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[self.headViewArray count];i++)
        {
            if (tag == i) {
                HeadView *head = [self.headViewArray objectAtIndex:i];
                head.open = NO;
                [head.backBtn setBackgroundImage:[UIImage imageNamed:@"分类底"] forState:UIControlStateNormal];
                [head.indicatorBtn setSelected:NO];
            }
           
        }
        [self.contentTable reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
}

- (void)reset
{
    for(int i = 0;i<[self.headViewArray count];i++)
    {
        HeadView *head = [self.headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            [head.indicatorBtn setSelected:YES];
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"分类底"] forState:UIControlStateNormal];
            
        }
//        else {
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"产品展示底框"] forState:UIControlStateNormal];
//            [head.indicatorBtn setSelected:NO];
//            head.open = NO;
//        }
        
    }
    [self.contentTable reloadData];
}
@end
