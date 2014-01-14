//
//  LeftMenuViewController.m
//  TeaMall
//
//  Created by vedon on 13/1/14.
//  Copyright (c) 2014 helloworld. All rights reserved.
//

#import "LeftMenuViewController.h"
static NSString * cellIdentifier = @"cellIdentifier";
@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate,HeadViewDelegate>

@end

@implementation LeftMenuViewController

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
    [self loadModel];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadModel{
    _currentRow = -1;
    self.headViewArray = [[NSMutableArray alloc]init ];
    for(int i = 0;i< 5 ;i++)
	{
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
		headview.section = i;
        headview.tag = i;
        [headview.backBtn setTitle:[NSString stringWithFormat:@"  第%d组",i] forState:UIControlStateNormal];
        [headview.backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    return headView.open?5:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIButton* backBtn=  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        backBtn.tag = 20000;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateHighlighted];
        backBtn.userInteractionEnabled = NO;
        [cell.contentView addSubview:backBtn];
        backBtn = nil;
        
    }
    UIButton* backBtn = (UIButton*)[cell.contentView viewWithTag:20000];
    HeadView* view = [self.headViewArray objectAtIndex:indexPath.section];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateNormal];
    
    if (view.open) {
        if (indexPath.row == _currentRow) {
            [backBtn setBackgroundImage:[UIImage imageNamed:@"年份展板"] forState:UIControlStateNormal];
        }
    }
    cell.textLabel.text = @"hel";
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    [self.contentTable reloadData];
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
                [head.backBtn setBackgroundImage:[UIImage imageNamed:@"产品展示底框"] forState:UIControlStateNormal];
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
            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"产品展示底框"] forState:UIControlStateNormal];
            
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
