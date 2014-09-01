//
//  TeaMarketSearchController.m
//  茶叶市场的主界面
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//
//定义颜色的宏
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//teaMarketSearchController模块
//分割线背景
#define kSeparateLineBg kColor(211, 211, 211)
//tableViewcell背景
#define kTableViewCellBg kColor(232, 233, 232)
//searchView背景
#define kSearchViewBg kColor(236, 236, 236)
//table的边距
#define kTableViewCellBorder 20

#import "TeaMarketSearchController.h"
#import "ControlCenter.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "TeaCategory.h"
#import "HeadView.h"
#import "TeaMarketViewController.h"

@interface TeaMarketSearchController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HeadViewDelegate>

{
    //搜索字符串
    NSString *_searchStr;
    NSMutableArray *_headerList;
    NSInteger _currentSection;
    NSInteger _currentRow;
    
    //年份
    NSArray *_years;
}

@end

@implementation TeaMarketSearchController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建页面
    [self setupUI];
    //添加手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    NSLog(@"self.subViews:%@",self.view.subviews);
    //创建年份数组
    [self createYears];
    //加载数据
    [self getAllTeaCategory];
}

- (void)createYears
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for(int i = 0 ; i <= 17; i ++)
    {
        int year = 2014 - i;
        [arrayM addObject:[NSString stringWithFormat:@"%i",year]];
    }
    _years = arrayM;
}

#pragma mark 建立UI界面
- (void)setupUI
{
    NSLog(@"self.view:%@",NSStringFromCGRect(self.view.frame));
    [self setLeftCustomBarItem:@"返回" action:nil];
    self.title = @"搜索";
    _searchBar.delegate = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //修改SearchBar风格
    self.searchBar.layer.cornerRadius=15.0f;
    self.searchBar.layer.borderColor = [[UIColor redColor] CGColor];
    self.searchBar.layer.borderWidth = 1.0;
}

#pragma mark 获取所有分类
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


- (void)loadModel{
    _currentRow = -1;
    _headerList = [[NSMutableArray alloc]init ];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    for(int i = 0;i< [appDelegate.allTeaCategory count] ;i++)
	{
        TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:i];
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
        [headview.indicatorBtn setImage:[UIImage imageNamed:@"search_down.png"] forState:UIControlStateSelected];
        [headview.indicatorBtn setImage:[UIImage imageNamed:@"search_up.png"] forState:UIControlStateNormal];
		headview.section = i;
        headview.tag = i;
        [headview.backBtn setTitle:[NSString stringWithFormat:@"  %@",category.name] forState:UIControlStateNormal];
        [headview.backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [headview setBackgroundColor:kTableViewCellBg];
        [headview.backBtn setBackgroundImage:nil forState:UIControlStateNormal];
		[_headerList addObject:headview];
        headview = nil;
	}
}

#pragma mark 手势响应，退出键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_searchBar resignFirstResponder];
}

#pragma mark 搜索按钮监听方法
- (void)searchClick
{
//    [self textFieldShouldReturn:_searchText];
    NSLog(@"%@",_searchStr);
}

#pragma mark - Tableview 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeadView* headView = [_headerList objectAtIndex:section];
    return headView.open?[_years count]:0;
}

#pragma mark 分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [_headerList objectAtIndex:section];
}

#pragma mark - 返回每个头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _years[indexPath.row];
    return cell;
}


#pragma mark textfield代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = textField.text;//取出搜索的文字
    
    [textField resignFirstResponder];//退出键盘
    return YES;
}


#pragma mark 搜索按钮确定方法
- (IBAction)sure:(id)sender {
    
    [_searchBar resignFirstResponder];
    if (_searchBar.text.length > 0) {
        TeaMarketViewController *vc = [[TeaMarketViewController alloc] init];
        vc.keyword = _searchBar.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - HeadViewdelegate
- (void)selectedWith:(HeadView *)view viewTag:(NSInteger)tag{
    _currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[_headerList count];i++)
        {
            if (tag == i) {
                HeadView *head = [_headerList objectAtIndex:i];
                head.open = NO;
                [head.indicatorBtn setSelected:NO];
            }
            
        }
        [self.contentTable reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
    
    NSLog(@"点击第%d组",tag);
    
    
}

- (void)reset
{
    for(int i = 0;i<[_headerList count];i++)
    {
        HeadView *head = [_headerList objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            [head.indicatorBtn setSelected:YES];
        }
    }
    [self.contentTable reloadData];
}


#pragma mark 选中某个cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    [self.contentTable reloadData];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:indexPath.section];
    NSString * year = [_years objectAtIndex:indexPath.row];
    TeaMarketViewController *vc = [[TeaMarketViewController alloc] init];
    vc.year = year;
    vc.teaCategory = category;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
